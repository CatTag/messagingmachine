#!/bin/sh

TAG=$(git describe --abbrev=0 --tags --match="v[0-9]*\.[0-9]*" 2>/dev/null)

# Is there a tag?
if [ $? != 0 ]; then
  # No tag was found, go from initial commit
  PATCH=$(git rev-list HEAD --count 2>/dev/null)
  TAG=v0.0
else
  # Tag was found, go from there
  PATCH=$(git rev-list $TAG..HEAD --count 2>/dev/null)
fi

# Split out tag into major, minor and patch numbers
MAJOR=$(echo $TAG | cut -c 2- | cut -d "." -f 1)
MINOR=$(echo $TAG | cut -c 2- | cut -d "." -f 2)

# Output version number in the desired format
if [ $PATCH = 0 ]; then
  printf '%d.%d' "$MAJOR" "$MINOR"
else
  printf '%d.%d.%d' "$MAJOR" "$MINOR" "$PATCH"
fi

# Get the current checked out branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCHTAG=$(echo $BRANCH | tr -cd [:alnum:])

# Add the build tag on non-release branches
if [ $BRANCH != "release" ] && [ $BRANCH != "HEAD" ]; then
  # Get the number of merges on the current branch since that tag
  BUILD=$(git rev-list master...$BRANCH --count)

  # Append builds since last branch, if appropriate
  if [ $BUILD != 0 ]; then
    printf -- "-$BRANCHTAG-%04d" "$BUILD"
  else
    printf -- "-$BRANCHTAG"
  fi
fi

# Append the short commit hash for now
printf -- "-$(git rev-parse --short HEAD)"
