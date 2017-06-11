FROM ruby:2.3
RUN apt-get update -qy && apt-get install -y graphviz && gem update bundler
COPY . /app
RUN cd /app && bundle install --jobs 4 && puppet module install puppetlabs-stdlib
EXPOSE 12000
ENTRYPOINT puppet debugger
