# Use the official Ruby base image
FROM ruby:latest

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the Gemfile and Gemfile.lock to install dependencies
COPY Gemfile Gemfile.lock ./

# Install the gems defined in Gemfile
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose the port that Sinatra will run on
EXPOSE 8005

# Define the command to run your application using Rack
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "8005"]