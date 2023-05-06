alias t := test

test:
    find src -name "*.zig" | xargs -I {} sh -c 'echo "Testing {}"; zig test {}; echo'
