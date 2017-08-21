Maintainer script flowcharts
============================

The flowcharts [#]_ included in this appendix use the following
conventions:

-  maintainer scripts and their arguments are within boxes;

-  actions carried out external to the scripts are in italics; and

-  the ``dpkg`` status of the package at the end of the run are in bold
   type.

.. figure:: images/policy-install.png
   :alt: Installing a package that was not previously installed

   Installing a package that was not previously installed

.. figure:: images/policy-install-conffiles.png
   :alt: Installing a package that was previously removed, but not purged

   Installing a package that was previously removed, but not purged

.. figure:: images/policy-upgrade.png
   :alt: Upgrading a package

   Upgrading a package

.. figure:: images/policy-remove.png
   :alt: Removing a package

   Removing a package

.. figure:: images/policy-purge.png
   :alt: Purging a package previously removed

   Purging a package previously removed

.. figure:: images/policy-remove-purge.png
   :alt: Removing and purging a package

   Removing and purging a package

.. [#]
   These flowcharts were originally created by Margarita Manterola for
   the Debian Women project wiki.
