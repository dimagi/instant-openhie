Community Health Information System
===================================

A package that installs and starts up an instance of CommCare HQ.

Running CommCare HQ in Instant OpenHIE
--------------------------------------

Run the following commands in the root directory of this codebase.

1. Download the Instant OpenHIE CLI
   ::

       $ curl -L https://github.com/openhie/package-starter-kit/releases/download/latest/gocli-linux -o goinstant
       $ chmod +x goinstant

2. Build this codebase as the "openhie/instant:latest" Docker image.
   ::

       $ ./build-image.sh

3. Use the CLI to initialize the Instant OpenHIE **core** package, which is
   OpenHIM and HAPI FHIR. ::

       $ ./goinstant init -t=docker core

4. Now stop the containers. We need to do this because currently Formplayer port
   8080 conflicts with OpenHIM and CommCare HQ's Postgres port 5432 conflicts
   with HAPI FHIR's Postgres. ::

       $ ./goinstant down -t=docker core

5. Initialize the CommCare HQ environment.
   ::

       $ ./goinstant init -t=docker --only chis

   "chis" is the generic name for the CommCare HQ package, for Community Health
   Information System. All package names are generic.

   The "--only" option runs CommCare HQ without first starting up the "core"
   package.

   The "init" command will run the **cchq-config** container, which initializes
   the CommCare HQ database, and creates a demo user.

   .. WARNING:: What actually happens is the **cchq-config** and **cchq-kafka**
      containers die unexpectedly after 40 to 50 seconds, and the database does
      not get initialised.

      This does not happen when running the same containers in the
      **commcare-hq** repo using ``scripts/docker runserver``. (See the
      "nh/healthcheck" branch.)

      We need to resolve this.

6. You should now be ready to run the Instant OpenHIE **core** and **chis**
   packages. Use the "up" CLI command, and this time omit the "--only" option,
   so that the **core** package is also started. ::

       $ ./goinstant up -t=docker chis

You can open CommCare HQ at http://localhost:8000/ and log in as the demo user.

The username is "admin@example.com" and the password is "Passw0rd!".

Follow-up tasks
---------------

1. Resolve the bug with the **cchq-kafka** and **cchq-config** containers.

2. CommCare HQ will need to be configured to use different ports for Formplayer
   and Postgres.
