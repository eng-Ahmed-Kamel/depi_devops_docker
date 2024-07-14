#!/bin/bash

while true; do
    echo "Choose an option:"
    echo "1 - List all containers"
    echo "2 - List running containers"
    echo "3 - List all images"
    echo "4 - Run container in detach mode"
    echo "5 - Stop container"
    echo "6 - Remove container"
    echo "7 - Remove image"
    echo "8 - Remove all unused images"
    echo "9 - Remove all stopped containers"
    echo "10 - Remove all containers"
    echo "11 - Remove all images"
    echo "12 - Pull image"
    echo "13 - Exit"

    read -p "Enter option: " option

    case "$option" in
        "1") docker ps -a ;;
        "2") docker ps ;;
        "3") docker images ;;
        "4")
            while true; do
                read -p "Enter Docker image name: " IMAGE_NAME

                if [[ -z "$IMAGE_NAME" ]]; then
                    echo "Error: Image name cannot be empty."
                elif ! docker inspect "$IMAGE_NAME" &> /dev/null; then
                    echo "Error: Image '$IMAGE_NAME' not found. Please try again."
                else
                    break  # Exit the loop if image name is valid
                fi
            done

            read -p "Enter port on main device to forward (e.g., 8080): " HOST_PORT
            read -p "Enter port on container to forward to (e.g., 80): " CONTAINER_PORT
            read -p "Enter name for the container: " CONTAINER_NAME
            read -p "Enter tag for the Docker image (default is 'latest'): " IMAGE_TAG
            IMAGE_TAG=${IMAGE_TAG:-latest}  # Set default tag to 'latest' if not provided

            docker run -d -p "$HOST_PORT:$CONTAINER_PORT" --name "$CONTAINER_NAME" "$IMAGE_NAME:$IMAGE_TAG"
            ;;
        "5")
            echo "Enter name of container to stop: "
            read stop_container
            docker stop "$stop_container"
            ;;
        "6")
            echo "Enter name of container to remove: "
            read delete_container
            docker rm -f "$delete_container"
            ;;
        "7")
            echo "Enter name of image to remove: "
            read delete_image
            docker rmi "$delete_image"
            ;;
        "8") docker image prune -a ;;
        "9") docker container prune ;;
        "10") docker rm -f $(docker ps -aq) ;;
        "11") docker rmi -f $(docker images -aq) ;;
        "12")
            echo "Enter name of image to pull: "
            read IMAGE_NAME

            while [[ -z "$IMAGE_NAME" ]]; do
                echo "Error: Image name cannot be empty."
                read -p "Enter name of image to pull: " IMAGE_NAME
            done

            echo "Enter tag for the Docker image (default is 'latest'): "
            read TAG

            docker pull "$IMAGE_NAME:${TAG:-latest}"
            ;;
        "13") 
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose a number from 1 to 13."
            ;;
    esac

    echo  # Add a blank line for readability
done

