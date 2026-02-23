# Sync to GCP VM with smart defaults
# Stores last used instance/zone for quick re-sync
#
# Helper function to convert .gitignore to rsync filter file
# Uses two-pass awk: protect rules (!) first, then exclude rules
_gcp_gitignore_to_filter() {
    local gitignore_file="$1"
    local filter_file="$2"
    
    [[ ! -f "$gitignore_file" ]] && return 1
    
    # Process .gitignore: include rules (!) must come BEFORE exclude rules
    {
        # First pass: all negation patterns become INCLUDE rules (+)
        awk '/^!/ && !/^#/ && !/^[[:space:]]*$/ { 
            sub(/^!/, ""); 
            gsub(/^[[:space:]]+|[[:space:]]+$/, "");
            if (length($0) > 0) print "+ " $0 
        }' "$gitignore_file"
        
        # Second pass: all exclude rules (non-negations)
        awk '!/^!/ && !/^#/ && !/^[[:space:]]*$/ { 
            gsub(/^[[:space:]]+|[[:space:]]+$/, "");
            if (length($0) > 0) print "- " $0 
        }' "$gitignore_file"
    } > "$filter_file"
    
    return 0
}

# Push to GCP VM with smart defaults
gcp-sync() {
    local config_file="$HOME/.gcp-sync-config"
    local dry_run=false
    local delete_mode=false
    local use_gitignore=true
    local use_checksum=false
    
    # Parse flags
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run|-n)
                dry_run=true
                shift
                ;;
            --delete|-d)
                delete_mode=true
                shift
                ;;
            --no-gitignore)
                use_gitignore=false
                shift
                ;;
            --checksum|-c)
                use_checksum=true
                shift
                ;;
            -h|--help)
                echo "Usage: gcp-sync [OPTIONS] [instance-name] [zone] <local-repo-path> <remote-path>"
                echo ""
                echo "Options:"
                echo "  --dry-run, -n      Show what would be synced"
                echo "  --delete, -d       Delete files on remote that don't exist locally"
                echo "  --no-gitignore     Don't use .gitignore filtering"
                echo "  --checksum, -c     Use checksum instead of timestamp for comparison (slower but accurate)"
                echo "  -h, --help         Show this help"
                echo ""
                echo "Examples:"
                echo "  gcp-sync ~/projects/myapp /home/user/myapp"
                echo "  gcp-sync --checksum ~/projects/myapp /home/user/myapp"
                echo "  gcp-sync --dry-run --delete ~/projects/myapp /home/user/myapp"
                return 0
                ;;
            *)
                break
                ;;
        esac
    done
    
    local instance_name zone local_path remote_path
    
    # Parse arguments
    if [[ $# -eq 4 ]]; then
        instance_name="$1"; zone="$2"; local_path="$3"; remote_path="$4"
        echo "INSTANCE=$instance_name" > "$config_file"
        echo "ZONE=$zone" >> "$config_file"
    elif [[ $# -eq 2 ]]; then
        if [[ -f "$config_file" ]]; then
            source "$config_file"
            instance_name="$INSTANCE"; zone="$ZONE"
            local_path="$1"; remote_path="$2"
        else
            echo "Error: No saved instance/zone found."
            return 1
        fi
    else
        echo "Error: Invalid arguments"
        return 1
    fi

    # Create remote directory
    if [[ "$dry_run" == false ]]; then
        gcloud compute ssh "$instance_name" --zone="$zone" --command="mkdir -p $remote_path" 2>/dev/null
    fi

    echo "Syncing: $local_path → $instance_name:$remote_path"
    echo "Zone: $zone"
    [[ "$delete_mode" == true ]] && echo "Mode: Delete remote files not in source"
    [[ "$use_checksum" == true ]] && echo "Mode: Checksum-based comparison (slower but accurate)"
    echo ""

    # Build rsync command as array
    local rsync_cmd=(rsync -avzh --progress)
    
    [[ "$dry_run" == true ]] && rsync_cmd+=(--dry-run)
    [[ "$delete_mode" == true ]] && rsync_cmd+=(--delete-after)
    [[ "$use_checksum" == true ]] && rsync_cmd+=(--checksum)
    
    rsync_cmd+=(--exclude='.git/')
    
    # Handle .gitignore filtering
    local temp_filter_file=""
    if [[ "$use_gitignore" == true ]] && _gcp_gitignore_to_filter "$local_path/.gitignore" "/tmp/rsync-filter-$$"; then
        temp_filter_file="/tmp/rsync-filter-$$"
        rsync_cmd+=(--filter=". $temp_filter_file")
    fi
    
    rsync_cmd+=(-e "gcloud compute ssh $instance_name --zone=$zone --")
    rsync_cmd+=("$local_path/")
    rsync_cmd+=(":$remote_path/")
    
    # Execute rsync
    [[ "$dry_run" == true ]] && echo "DRY RUN MODE"
    "${rsync_cmd[@]}"
    
    local exit_code=$?
    
    # Cleanup
    [[ -n "$temp_filter_file" && -f "$temp_filter_file" ]] && rm "$temp_filter_file"
    
    if [[ $exit_code -eq 0 ]]; then
        echo ""
        [[ "$dry_run" == true ]] && echo "✓ Dry run completed" || echo "✓ Sync completed"
    fi
}

# Pull from GCP VM to local
gcp-pull() {
    local config_file="$HOME/.gcp-sync-config"
    local dry_run=false
    local delete_mode=false
    local use_gitignore=true
    local use_checksum=false
    
    # Parse flags
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run|-n)
                dry_run=true
                shift
                ;;
            --delete|-d)
                delete_mode=true
                shift
                ;;
            --no-gitignore)
                use_gitignore=false
                shift
                ;;
            --checksum|-c)
                use_checksum=true
                shift
                ;;
            -h|--help)
                echo "Usage: gcp-pull [OPTIONS] [instance-name] [zone] <remote-path> <local-path>"
                echo ""
                echo "Options:"
                echo "  --dry-run, -n      Show what would be synced"
                echo "  --delete, -d       Delete local files that don't exist on remote"
                echo "  --no-gitignore     Don't use .gitignore filtering"
                echo "  --checksum, -c     Use checksum instead of timestamp for comparison (slower but accurate)"
                echo "  -h, --help         Show this help"
                echo ""
                echo "Examples:"
                echo "  gcp-pull /home/user/myapp ~/projects/myapp"
                echo "  gcp-pull --checksum /home/user/myapp ~/projects/myapp"
                echo "  gcp-pull --dry-run --delete /home/user/myapp ."
                return 0
                ;;
            *)
                break
                ;;
        esac
    done
    
    local instance_name zone remote_path local_path
    
    # Parse arguments
    if [[ $# -eq 4 ]]; then
        instance_name="$1"; zone="$2"; remote_path="$3"; local_path="$4"
        echo "INSTANCE=$instance_name" > "$config_file"
        echo "ZONE=$zone" >> "$config_file"
    elif [[ $# -eq 2 ]]; then
        if [[ -f "$config_file" ]]; then
            source "$config_file"
            instance_name="$INSTANCE"; zone="$ZONE"
            remote_path="$1"; local_path="$2"
        else
            echo "Error: No saved instance/zone found."
            return 1
        fi
    else
        echo "Error: Invalid arguments"
        return 1
    fi

    # Create local directory
    if [[ "$dry_run" == false && ! -d "$local_path" ]]; then
        mkdir -p "$local_path"
    fi

    echo "Pulling: $instance_name:$remote_path → $local_path"
    echo "Zone: $zone"
    [[ "$delete_mode" == true ]] && echo "Mode: Delete local files not on remote"
    [[ "$use_checksum" == true ]] && echo "Mode: Checksum-based comparison (slower but accurate)"
    echo ""

    # Build rsync command as array
    local rsync_cmd=(rsync -avzh --progress)
    
    [[ "$dry_run" == true ]] && rsync_cmd+=(--dry-run)
    [[ "$delete_mode" == true ]] && rsync_cmd+=(--delete-after)
    [[ "$use_checksum" == true ]] && rsync_cmd+=(--checksum)
    
    rsync_cmd+=(--exclude='.git/')
    
    # Handle .gitignore filtering
    local temp_filter_file=""
    if [[ "$use_gitignore" == true ]] && _gcp_gitignore_to_filter "$local_path/.gitignore" "/tmp/rsync-filter-$$"; then
        temp_filter_file="/tmp/rsync-filter-$$"
        rsync_cmd+=(--filter=". $temp_filter_file")
    fi
    
    rsync_cmd+=(-e "gcloud compute ssh $instance_name --zone=$zone --")
    rsync_cmd+=(":$remote_path/")
    rsync_cmd+=("$local_path/")
    
    # Execute rsync
    [[ "$dry_run" == true ]] && echo "DRY RUN MODE"
    "${rsync_cmd[@]}"
    
    local exit_code=$?
    
    # Cleanup
    [[ -n "$temp_filter_file" && -f "$temp_filter_file" ]] && rm "$temp_filter_file"
    
    if [[ $exit_code -eq 0 ]]; then
        echo ""
        [[ "$dry_run" == true ]] && echo "✓ Dry run completed" || echo "✓ Pull completed"
    fi
}

# Push single file to VM
gcp-sync-file() {
    local config_file="$HOME/.gcp-sync-config"
    
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: gcp-sync-file [instance-name] [zone] <local-file> <remote-path>"
        echo "Push a single file to GCP VM."
        return 0
    fi
    
    local instance_name zone local_file remote_path
    
    if [[ $# -eq 4 ]]; then
        instance_name="$1"; zone="$2"; local_file="$3"; remote_path="$4"
        echo "INSTANCE=$instance_name" > "$config_file"
        echo "ZONE=$zone" >> "$config_file"
    elif [[ $# -eq 2 ]]; then
        if [[ -f "$config_file" ]]; then
            source "$config_file"
            instance_name="$INSTANCE"; zone="$ZONE"
            local_file="$1"; remote_path="$2"
        else
            echo "Error: No saved instance/zone found."
            return 1
        fi
    else
        echo "Error: Invalid arguments"
        return 1
    fi

    # Create remote directory if needed
    if [[ "$remote_path" == */ ]]; then
        gcloud compute ssh "$instance_name" --zone="$zone" --command="mkdir -p $remote_path" 2>/dev/null
    else
        local parent_dir=$(dirname "$remote_path")
        gcloud compute ssh "$instance_name" --zone="$zone" --command="mkdir -p $parent_dir" 2>/dev/null
    fi

    echo "Pushing: $local_file → $instance_name:$remote_path"
    gcloud compute scp "$local_file" "$instance_name:$remote_path" --zone="$zone"
    [[ $? -eq 0 ]] && echo "✓ File pushed"
}

# Pull single file from VM
gcp-pull-file() {
    local config_file="$HOME/.gcp-sync-config"
    
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        echo "Usage: gcp-pull-file [instance-name] [zone] <remote-file> <local-path>"
        echo "Pull a single file from GCP VM."
        return 0
    fi
    
    local instance_name zone remote_file local_path
    
    if [[ $# -eq 4 ]]; then
        instance_name="$1"; zone="$2"; remote_file="$3"; local_path="$4"
        echo "INSTANCE=$instance_name" > "$config_file"
        echo "ZONE=$zone" >> "$config_file"
    elif [[ $# -eq 2 ]]; then
        if [[ -f "$config_file" ]]; then
            source "$config_file"
            instance_name="$INSTANCE"; zone="$ZONE"
            remote_file="$1"; local_path="$2"
        else
            echo "Error: No saved instance/zone found."
            return 1
        fi
    else
        echo "Error: Invalid arguments"
        return 1
    fi

    # Create local directory if needed
    if [[ "$local_path" == */ ]] || [[ -d "$local_path" ]]; then
        [[ ! -d "$local_path" ]] && mkdir -p "$local_path"
    else
        local parent_dir=$(dirname "$local_path")
        [[ ! -d "$parent_dir" ]] && mkdir -p "$parent_dir"
    fi

    echo "Pulling: $instance_name:$remote_file → $local_path"
    gcloud compute scp "$instance_name:$remote_file" "$local_path" --zone="$zone"
    [[ $? -eq 0 ]] && echo "✓ File pulled"
}
