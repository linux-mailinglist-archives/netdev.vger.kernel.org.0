Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8B4AC31
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbfFRUyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:54:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51516 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730838AbfFRUyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OArDxULu6al28d5X+v/95X5whHTd0OzGBIs1JN272z4=; b=RRtM1mJHa6g6SaT63hL6EctFeY
        2hJN3+0/iA/mbSiiuJFPwqMUMG4AkVFYf9U4LbFw8RUy9gTsxc38ro6yskcza8tb3Gg0vagGeGyu2
        mSfhWozW1fwYHRv7HoOr3skPu3Od3cQx9CdMk9lc433hvjgueLt1JTzVvcku7tgB2syljNUKKUaOd
        h4KSxn2VosvspGcIk0sF5OBVcCBxSXRmRm6JSrT2x7ADrLoz46zwhRhKEJ1iB+zRVSmyvMzEdolEH
        FtHAMypr9fm6gsyYkOkIvkf5MarGV7KcGmRDUskiGbc0z5MD7Khhy0uq0mk2ERjT+Ruo0NyeWyTgr
        OM+4IVGg==;
Received: from 177.133.86.196.dynamic.adsl.gvt.net.br ([177.133.86.196] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hdL77-0008SF-Kn; Tue, 18 Jun 2019 20:53:58 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hdL6z-0001zR-Rj; Tue, 18 Jun 2019 17:53:49 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: [PATCH v2 09/29] docs: driver-model: convert docs to ReST and rename to *.rst
Date:   Tue, 18 Jun 2019 17:53:27 -0300
Message-Id: <0ac41c7d682452cdbd867c4ae7729b6b34d79c0b.1560890800.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560890800.git.mchehab+samsung@kernel.org>
References: <cover.1560890800.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the various documents at the driver-model, preparing
them to be part of the driver-api book.

The conversion is actually:
  - add blank lines and identation in order to identify paragraphs;
  - fix tables markups;
  - add some lists markups;
  - mark literal blocks;
  - adjust title markups.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com> # ice
---
 Documentation/driver-api/gpio/driver.rst      |   2 +-
 .../driver-model/{binding.txt => binding.rst} |  20 +-
 .../driver-model/{bus.txt => bus.rst}         |  69 ++--
 .../driver-model/{class.txt => class.rst}     |  74 ++--
 ...esign-patterns.txt => design-patterns.rst} | 106 +++---
 .../driver-model/{device.txt => device.rst}   |  57 +--
 .../driver-model/{devres.txt => devres.rst}   |  50 +--
 .../driver-model/{driver.txt => driver.rst}   | 112 +++---
 Documentation/driver-model/index.rst          |  26 ++
 .../{overview.txt => overview.rst}            |  37 +-
 .../{platform.txt => platform.rst}            |  30 +-
 .../driver-model/{porting.txt => porting.rst} | 333 +++++++++---------
 Documentation/eisa.txt                        |   4 +-
 Documentation/hwmon/submitting-patches.rst    |   2 +-
 drivers/base/platform.c                       |   2 +-
 drivers/gpio/gpio-cs5535.c                    |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   2 +-
 scripts/coccinelle/free/devm_free.cocci       |   2 +-
 18 files changed, 489 insertions(+), 441 deletions(-)
 rename Documentation/driver-model/{binding.txt => binding.rst} (92%)
 rename Documentation/driver-model/{bus.txt => bus.rst} (76%)
 rename Documentation/driver-model/{class.txt => class.rst} (75%)
 rename Documentation/driver-model/{design-patterns.txt => design-patterns.rst} (59%)
 rename Documentation/driver-model/{device.txt => device.rst} (71%)
 rename Documentation/driver-model/{devres.txt => devres.rst} (93%)
 rename Documentation/driver-model/{driver.txt => driver.rst} (75%)
 create mode 100644 Documentation/driver-model/index.rst
 rename Documentation/driver-model/{overview.txt => overview.rst} (90%)
 rename Documentation/driver-model/{platform.txt => platform.rst} (95%)
 rename Documentation/driver-model/{porting.txt => porting.rst} (62%)

diff --git a/Documentation/driver-api/gpio/driver.rst b/Documentation/driver-api/gpio/driver.rst
index 4af9aae724f0..349f2dc33029 100644
--- a/Documentation/driver-api/gpio/driver.rst
+++ b/Documentation/driver-api/gpio/driver.rst
@@ -399,7 +399,7 @@ symbol:
   will pass the struct gpio_chip* for the chip to all IRQ callbacks, so the
   callbacks need to embed the gpio_chip in its state container and obtain a
   pointer to the container using container_of().
-  (See Documentation/driver-model/design-patterns.txt)
+  (See Documentation/driver-model/design-patterns.rst)
 
 - gpiochip_irqchip_add_nested(): adds a nested cascaded irqchip to a gpiochip,
   as discussed above regarding different types of cascaded irqchips. The
diff --git a/Documentation/driver-model/binding.txt b/Documentation/driver-model/binding.rst
similarity index 92%
rename from Documentation/driver-model/binding.txt
rename to Documentation/driver-model/binding.rst
index abfc8e290d53..7ea1d7a41e1d 100644
--- a/Documentation/driver-model/binding.txt
+++ b/Documentation/driver-model/binding.rst
@@ -1,5 +1,6 @@
-
+==============
 Driver Binding
+==============
 
 Driver binding is the process of associating a device with a device
 driver that can control it. Bus drivers have typically handled this
@@ -25,7 +26,7 @@ device_register
 When a new device is added, the bus's list of drivers is iterated over
 to find one that supports it. In order to determine that, the device
 ID of the device must match one of the device IDs that the driver
-supports. The format and semantics for comparing IDs is bus-specific. 
+supports. The format and semantics for comparing IDs is bus-specific.
 Instead of trying to derive a complex state machine and matching
 algorithm, it is up to the bus driver to provide a callback to compare
 a device against the IDs of a driver. The bus returns 1 if a match was
@@ -36,14 +37,14 @@ int match(struct device * dev, struct device_driver * drv);
 If a match is found, the device's driver field is set to the driver
 and the driver's probe callback is called. This gives the driver a
 chance to verify that it really does support the hardware, and that
-it's in a working state. 
+it's in a working state.
 
 Device Class
 ~~~~~~~~~~~~
 
 Upon the successful completion of probe, the device is registered with
 the class to which it belongs. Device drivers belong to one and only one
-class, and that is set in the driver's devclass field. 
+class, and that is set in the driver's devclass field.
 devclass_add_device is called to enumerate the device within the class
 and actually register it with the class, which happens with the
 class's register_dev callback.
@@ -53,7 +54,7 @@ Driver
 ~~~~~~
 
 When a driver is attached to a device, the device is inserted into the
-driver's list of devices. 
+driver's list of devices.
 
 
 sysfs
@@ -67,18 +68,18 @@ to the device's directory in the physical hierarchy.
 
 A directory for the device is created in the class's directory. A
 symlink is created in that directory that points to the device's
-physical location in the sysfs tree. 
+physical location in the sysfs tree.
 
 A symlink can be created (though this isn't done yet) in the device's
 physical directory to either its class directory, or the class's
 top-level directory. One can also be created to point to its driver's
-directory also. 
+directory also.
 
 
 driver_register
 ~~~~~~~~~~~~~~~
 
-The process is almost identical for when a new driver is added. 
+The process is almost identical for when a new driver is added.
 The bus's list of devices is iterated over to find a match. Devices
 that already have a driver are skipped. All the devices are iterated
 over, to bind as many devices as possible to the driver.
@@ -94,5 +95,4 @@ of the driver is decremented. All symlinks between the two are removed.
 
 When a driver is removed, the list of devices that it supports is
 iterated over, and the driver's remove callback is called for each
-one. The device is removed from that list and the symlinks removed. 
-
+one. The device is removed from that list and the symlinks removed.
diff --git a/Documentation/driver-model/bus.txt b/Documentation/driver-model/bus.rst
similarity index 76%
rename from Documentation/driver-model/bus.txt
rename to Documentation/driver-model/bus.rst
index c247b488a567..016b15a6e8ea 100644
--- a/Documentation/driver-model/bus.txt
+++ b/Documentation/driver-model/bus.rst
@@ -1,5 +1,6 @@
-
-Bus Types 
+=========
+Bus Types
+=========
 
 Definition
 ~~~~~~~~~~
@@ -13,12 +14,12 @@ Declaration
 
 Each bus type in the kernel (PCI, USB, etc) should declare one static
 object of this type. They must initialize the name field, and may
-optionally initialize the match callback.
+optionally initialize the match callback::
 
-struct bus_type pci_bus_type = {
-       .name	= "pci",
-       .match	= pci_bus_match,
-};
+   struct bus_type pci_bus_type = {
+          .name	= "pci",
+          .match	= pci_bus_match,
+   };
 
 The structure should be exported to drivers in a header file:
 
@@ -30,8 +31,8 @@ Registration
 
 When a bus driver is initialized, it calls bus_register. This
 initializes the rest of the fields in the bus object and inserts it
-into a global list of bus types. Once the bus object is registered, 
-the fields in it are usable by the bus driver. 
+into a global list of bus types. Once the bus object is registered,
+the fields in it are usable by the bus driver.
 
 
 Callbacks
@@ -43,17 +44,17 @@ match(): Attaching Drivers to Devices
 The format of device ID structures and the semantics for comparing
 them are inherently bus-specific. Drivers typically declare an array
 of device IDs of devices they support that reside in a bus-specific
-driver structure. 
+driver structure.
 
 The purpose of the match callback is to give the bus an opportunity to
 determine if a particular driver supports a particular device by
 comparing the device IDs the driver supports with the device ID of a
 particular device, without sacrificing bus-specific functionality or
-type-safety. 
+type-safety.
 
 When a driver is registered with the bus, the bus's list of devices is
 iterated over, and the match callback is called for each device that
-does not have a driver associated with it. 
+does not have a driver associated with it.
 
 
 
@@ -64,22 +65,23 @@ The lists of devices and drivers are intended to replace the local
 lists that many buses keep. They are lists of struct devices and
 struct device_drivers, respectively. Bus drivers are free to use the
 lists as they please, but conversion to the bus-specific type may be
-necessary. 
+necessary.
 
-The LDM core provides helper functions for iterating over each list.
+The LDM core provides helper functions for iterating over each list::
 
-int bus_for_each_dev(struct bus_type * bus, struct device * start, void * data,
-		     int (*fn)(struct device *, void *));
+  int bus_for_each_dev(struct bus_type * bus, struct device * start,
+		       void * data,
+		       int (*fn)(struct device *, void *));
 
-int bus_for_each_drv(struct bus_type * bus, struct device_driver * start, 
-		     void * data, int (*fn)(struct device_driver *, void *));
+  int bus_for_each_drv(struct bus_type * bus, struct device_driver * start,
+		       void * data, int (*fn)(struct device_driver *, void *));
 
 These helpers iterate over the respective list, and call the callback
 for each device or driver in the list. All list accesses are
 synchronized by taking the bus's lock (read currently). The reference
 count on each object in the list is incremented before the callback is
 called; it is decremented after the next object has been obtained. The
-lock is not held when calling the callback. 
+lock is not held when calling the callback.
 
 
 sysfs
@@ -87,14 +89,14 @@ sysfs
 There is a top-level directory named 'bus'.
 
 Each bus gets a directory in the bus directory, along with two default
-directories:
+directories::
 
 	/sys/bus/pci/
 	|-- devices
 	`-- drivers
 
 Drivers registered with the bus get a directory in the bus's drivers
-directory:
+directory::
 
 	/sys/bus/pci/
 	|-- devices
@@ -106,7 +108,7 @@ directory:
 
 Each device that is discovered on a bus of that type gets a symlink in
 the bus's devices directory to the device's directory in the physical
-hierarchy:
+hierarchy::
 
 	/sys/bus/pci/
 	|-- devices
@@ -118,26 +120,27 @@ hierarchy:
 
 Exporting Attributes
 ~~~~~~~~~~~~~~~~~~~~
-struct bus_attribute {
+
+::
+
+  struct bus_attribute {
 	struct attribute	attr;
 	ssize_t (*show)(struct bus_type *, char * buf);
 	ssize_t (*store)(struct bus_type *, const char * buf, size_t count);
-};
+  };
 
 Bus drivers can export attributes using the BUS_ATTR_RW macro that works
 similarly to the DEVICE_ATTR_RW macro for devices. For example, a
-definition like this:
+definition like this::
 
-static BUS_ATTR_RW(debug);
+	static BUS_ATTR_RW(debug);
 
-is equivalent to declaring:
+is equivalent to declaring::
 
-static bus_attribute bus_attr_debug;
+	static bus_attribute bus_attr_debug;
 
 This can then be used to add and remove the attribute from the bus's
-sysfs directory using:
-
-int bus_create_file(struct bus_type *, struct bus_attribute *);
-void bus_remove_file(struct bus_type *, struct bus_attribute *);
-
+sysfs directory using::
 
+	int bus_create_file(struct bus_type *, struct bus_attribute *);
+	void bus_remove_file(struct bus_type *, struct bus_attribute *);
diff --git a/Documentation/driver-model/class.txt b/Documentation/driver-model/class.rst
similarity index 75%
rename from Documentation/driver-model/class.txt
rename to Documentation/driver-model/class.rst
index 1fefc480a80b..fff55b80e86a 100644
--- a/Documentation/driver-model/class.txt
+++ b/Documentation/driver-model/class.rst
@@ -1,6 +1,6 @@
-
+==============
 Device Classes
-
+==============
 
 Introduction
 ~~~~~~~~~~~~
@@ -13,37 +13,37 @@ device. The following device classes have been identified:
 Each device class defines a set of semantics and a programming interface
 that devices of that class adhere to. Device drivers are the
 implementation of that programming interface for a particular device on
-a particular bus. 
+a particular bus.
 
 Device classes are agnostic with respect to what bus a device resides
-on. 
+on.
 
 
 Programming Interface
 ~~~~~~~~~~~~~~~~~~~~~
-The device class structure looks like: 
+The device class structure looks like::
 
 
-typedef int (*devclass_add)(struct device *);
-typedef void (*devclass_remove)(struct device *);
+  typedef int (*devclass_add)(struct device *);
+  typedef void (*devclass_remove)(struct device *);
 
 See the kerneldoc for the struct class.
 
-A typical device class definition would look like: 
+A typical device class definition would look like::
 
-struct device_class input_devclass = {
+  struct device_class input_devclass = {
         .name		= "input",
         .add_device	= input_add_device,
 	.remove_device	= input_remove_device,
-};
+  };
 
 Each device class structure should be exported in a header file so it
 can be used by drivers, extensions and interfaces.
 
-Device classes are registered and unregistered with the core using: 
+Device classes are registered and unregistered with the core using::
 
-int devclass_register(struct device_class * cls);
-void devclass_unregister(struct device_class * cls);
+  int devclass_register(struct device_class * cls);
+  void devclass_unregister(struct device_class * cls);
 
 
 Devices
@@ -52,16 +52,16 @@ As devices are bound to drivers, they are added to the device class
 that the driver belongs to. Before the driver model core, this would
 typically happen during the driver's probe() callback, once the device
 has been initialized. It now happens after the probe() callback
-finishes from the core. 
+finishes from the core.
 
 The device is enumerated in the class. Each time a device is added to
 the class, the class's devnum field is incremented and assigned to the
 device. The field is never decremented, so if the device is removed
 from the class and re-added, it will receive a different enumerated
-value. 
+value.
 
 The class is allowed to create a class-specific structure for the
-device and store it in the device's class_data pointer. 
+device and store it in the device's class_data pointer.
 
 There is no list of devices in the device class. Each driver has a
 list of devices that it supports. The device class has a list of
@@ -73,15 +73,15 @@ Device Drivers
 ~~~~~~~~~~~~~~
 Device drivers are added to device classes when they are registered
 with the core. A driver specifies the class it belongs to by setting
-the struct device_driver::devclass field. 
+the struct device_driver::devclass field.
 
 
 sysfs directory structure
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-There is a top-level sysfs directory named 'class'. 
+There is a top-level sysfs directory named 'class'.
 
 Each class gets a directory in the class directory, along with two
-default subdirectories:
+default subdirectories::
 
         class/
         `-- input
@@ -89,8 +89,8 @@ default subdirectories:
             `-- drivers
 
 
-Drivers registered with the class get a symlink in the drivers/ directory 
-that points to the driver's directory (under its bus directory):
+Drivers registered with the class get a symlink in the drivers/ directory
+that points to the driver's directory (under its bus directory)::
 
    class/
    `-- input
@@ -99,8 +99,8 @@ that points to the driver's directory (under its bus directory):
            `-- usb:usb_mouse -> ../../../bus/drivers/usb_mouse/
 
 
-Each device gets a symlink in the devices/ directory that points to the 
-device's directory in the physical hierarchy:
+Each device gets a symlink in the devices/ directory that points to the
+device's directory in the physical hierarchy::
 
    class/
    `-- input
@@ -111,37 +111,39 @@ device's directory in the physical hierarchy:
 
 Exporting Attributes
 ~~~~~~~~~~~~~~~~~~~~
-struct devclass_attribute {
+
+::
+
+  struct devclass_attribute {
         struct attribute        attr;
         ssize_t (*show)(struct device_class *, char * buf, size_t count, loff_t off);
         ssize_t (*store)(struct device_class *, const char * buf, size_t count, loff_t off);
-};
+  };
 
 Class drivers can export attributes using the DEVCLASS_ATTR macro that works
-similarly to the DEVICE_ATTR macro for devices. For example, a definition 
-like this:
+similarly to the DEVICE_ATTR macro for devices. For example, a definition
+like this::
 
-static DEVCLASS_ATTR(debug,0644,show_debug,store_debug);
+  static DEVCLASS_ATTR(debug,0644,show_debug,store_debug);
 
-is equivalent to declaring:
+is equivalent to declaring::
 
-static devclass_attribute devclass_attr_debug;
+  static devclass_attribute devclass_attr_debug;
 
 The bus driver can add and remove the attribute from the class's
-sysfs directory using:
+sysfs directory using::
 
-int devclass_create_file(struct device_class *, struct devclass_attribute *);
-void devclass_remove_file(struct device_class *, struct devclass_attribute *);
+  int devclass_create_file(struct device_class *, struct devclass_attribute *);
+  void devclass_remove_file(struct device_class *, struct devclass_attribute *);
 
 In the example above, the file will be named 'debug' in placed in the
-class's directory in sysfs. 
+class's directory in sysfs.
 
 
 Interfaces
 ~~~~~~~~~~
 There may exist multiple mechanisms for accessing the same device of a
-particular class type. Device interfaces describe these mechanisms. 
+particular class type. Device interfaces describe these mechanisms.
 
 When a device is added to a device class, the core attempts to add it
 to every interface that is registered with the device class.
-
diff --git a/Documentation/driver-model/design-patterns.txt b/Documentation/driver-model/design-patterns.rst
similarity index 59%
rename from Documentation/driver-model/design-patterns.txt
rename to Documentation/driver-model/design-patterns.rst
index ba7b2df64904..41eb8f41f7dd 100644
--- a/Documentation/driver-model/design-patterns.txt
+++ b/Documentation/driver-model/design-patterns.rst
@@ -1,6 +1,6 @@
-
+=============================
 Device Driver Design Patterns
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+=============================
 
 This document describes a few common design patterns found in device drivers.
 It is likely that subsystem maintainers will ask driver developers to
@@ -19,23 +19,23 @@ that the device the driver binds to will appear in several instances. This
 means that the probe() function and all callbacks need to be reentrant.
 
 The most common way to achieve this is to use the state container design
-pattern. It usually has this form:
+pattern. It usually has this form::
 
-struct foo {
-    spinlock_t lock; /* Example member */
-    (...)
-};
+  struct foo {
+      spinlock_t lock; /* Example member */
+      (...)
+  };
 
-static int foo_probe(...)
-{
-    struct foo *foo;
+  static int foo_probe(...)
+  {
+      struct foo *foo;
 
-    foo = devm_kzalloc(dev, sizeof(*foo), GFP_KERNEL);
-    if (!foo)
-        return -ENOMEM;
-    spin_lock_init(&foo->lock);
-    (...)
-}
+      foo = devm_kzalloc(dev, sizeof(*foo), GFP_KERNEL);
+      if (!foo)
+          return -ENOMEM;
+      spin_lock_init(&foo->lock);
+      (...)
+  }
 
 This will create an instance of struct foo in memory every time probe() is
 called. This is our state container for this instance of the device driver.
@@ -43,21 +43,21 @@ Of course it is then necessary to always pass this instance of the
 state around to all functions that need access to the state and its members.
 
 For example, if the driver is registering an interrupt handler, you would
-pass around a pointer to struct foo like this:
+pass around a pointer to struct foo like this::
 
-static irqreturn_t foo_handler(int irq, void *arg)
-{
-    struct foo *foo = arg;
-    (...)
-}
+  static irqreturn_t foo_handler(int irq, void *arg)
+  {
+      struct foo *foo = arg;
+      (...)
+  }
 
-static int foo_probe(...)
-{
-    struct foo *foo;
+  static int foo_probe(...)
+  {
+      struct foo *foo;
 
-    (...)
-    ret = request_irq(irq, foo_handler, 0, "foo", foo);
-}
+      (...)
+      ret = request_irq(irq, foo_handler, 0, "foo", foo);
+  }
 
 This way you always get a pointer back to the correct instance of foo in
 your interrupt handler.
@@ -66,38 +66,38 @@ your interrupt handler.
 2. container_of()
 ~~~~~~~~~~~~~~~~~
 
-Continuing on the above example we add an offloaded work:
+Continuing on the above example we add an offloaded work::
 
-struct foo {
-    spinlock_t lock;
-    struct workqueue_struct *wq;
-    struct work_struct offload;
-    (...)
-};
+  struct foo {
+      spinlock_t lock;
+      struct workqueue_struct *wq;
+      struct work_struct offload;
+      (...)
+  };
 
-static void foo_work(struct work_struct *work)
-{
-    struct foo *foo = container_of(work, struct foo, offload);
+  static void foo_work(struct work_struct *work)
+  {
+      struct foo *foo = container_of(work, struct foo, offload);
 
-    (...)
-}
+      (...)
+  }
 
-static irqreturn_t foo_handler(int irq, void *arg)
-{
-    struct foo *foo = arg;
+  static irqreturn_t foo_handler(int irq, void *arg)
+  {
+      struct foo *foo = arg;
 
-    queue_work(foo->wq, &foo->offload);
-    (...)
-}
+      queue_work(foo->wq, &foo->offload);
+      (...)
+  }
 
-static int foo_probe(...)
-{
-    struct foo *foo;
+  static int foo_probe(...)
+  {
+      struct foo *foo;
 
-    foo->wq = create_singlethread_workqueue("foo-wq");
-    INIT_WORK(&foo->offload, foo_work);
-    (...)
-}
+      foo->wq = create_singlethread_workqueue("foo-wq");
+      INIT_WORK(&foo->offload, foo_work);
+      (...)
+  }
 
 The design pattern is the same for an hrtimer or something similar that will
 return a single argument which is a pointer to a struct member in the
diff --git a/Documentation/driver-model/device.txt b/Documentation/driver-model/device.rst
similarity index 71%
rename from Documentation/driver-model/device.txt
rename to Documentation/driver-model/device.rst
index 2403eb856187..2b868d49d349 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.rst
@@ -1,6 +1,6 @@
-
+==========================
 The Basic Device Structure
-~~~~~~~~~~~~~~~~~~~~~~~~~~
+==========================
 
 See the kerneldoc for the struct device.
 
@@ -8,9 +8,9 @@ See the kerneldoc for the struct device.
 Programming Interface
 ~~~~~~~~~~~~~~~~~~~~~
 The bus driver that discovers the device uses this to register the
-device with the core:
+device with the core::
 
-int device_register(struct device * dev);
+  int device_register(struct device * dev);
 
 The bus should initialize the following fields:
 
@@ -20,30 +20,33 @@ The bus should initialize the following fields:
     - bus
 
 A device is removed from the core when its reference count goes to
-0. The reference count can be adjusted using:
+0. The reference count can be adjusted using::
 
-struct device * get_device(struct device * dev);
-void put_device(struct device * dev);
+  struct device * get_device(struct device * dev);
+  void put_device(struct device * dev);
 
 get_device() will return a pointer to the struct device passed to it
 if the reference is not already 0 (if it's in the process of being
 removed already).
 
-A driver can access the lock in the device structure using: 
+A driver can access the lock in the device structure using::
 
-void lock_device(struct device * dev);
-void unlock_device(struct device * dev);
+  void lock_device(struct device * dev);
+  void unlock_device(struct device * dev);
 
 
 Attributes
 ~~~~~~~~~~
-struct device_attribute {
+
+::
+
+  struct device_attribute {
 	struct attribute	attr;
 	ssize_t (*show)(struct device *dev, struct device_attribute *attr,
 			char *buf);
 	ssize_t (*store)(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count);
-};
+  };
 
 Attributes of devices can be exported by a device driver through sysfs.
 
@@ -54,39 +57,39 @@ As explained in Documentation/kobject.txt, device attributes must be
 created before the KOBJ_ADD uevent is generated. The only way to realize
 that is by defining an attribute group.
 
-Attributes are declared using a macro called DEVICE_ATTR:
+Attributes are declared using a macro called DEVICE_ATTR::
 
-#define DEVICE_ATTR(name,mode,show,store)
+  #define DEVICE_ATTR(name,mode,show,store)
 
-Example:
+Example:::
 
-static DEVICE_ATTR(type, 0444, show_type, NULL);
-static DEVICE_ATTR(power, 0644, show_power, store_power);
+  static DEVICE_ATTR(type, 0444, show_type, NULL);
+  static DEVICE_ATTR(power, 0644, show_power, store_power);
 
 This declares two structures of type struct device_attribute with respective
 names 'dev_attr_type' and 'dev_attr_power'. These two attributes can be
-organized as follows into a group:
+organized as follows into a group::
 
-static struct attribute *dev_attrs[] = {
+  static struct attribute *dev_attrs[] = {
 	&dev_attr_type.attr,
 	&dev_attr_power.attr,
 	NULL,
-};
+  };
 
-static struct attribute_group dev_attr_group = {
+  static struct attribute_group dev_attr_group = {
 	.attrs = dev_attrs,
-};
+  };
 
-static const struct attribute_group *dev_attr_groups[] = {
+  static const struct attribute_group *dev_attr_groups[] = {
 	&dev_attr_group,
 	NULL,
-};
+  };
 
 This array of groups can then be associated with a device by setting the
-group pointer in struct device before device_register() is invoked:
+group pointer in struct device before device_register() is invoked::
 
-      dev->groups = dev_attr_groups;
-      device_register(dev);
+        dev->groups = dev_attr_groups;
+        device_register(dev);
 
 The device_register() function will use the 'groups' pointer to create the
 device attributes and the device_unregister() function will use this pointer
diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.rst
similarity index 93%
rename from Documentation/driver-model/devres.txt
rename to Documentation/driver-model/devres.rst
index 69c7fa7f616c..4ac99122b5f1 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.rst
@@ -1,3 +1,4 @@
+================================
 Devres - Managed Device Resource
 ================================
 
@@ -5,17 +6,18 @@ Tejun Heo	<teheo@suse.de>
 
 First draft	10 January 2007
 
+.. contents
 
-1. Intro			: Huh? Devres?
-2. Devres			: Devres in a nutshell
-3. Devres Group			: Group devres'es and release them together
-4. Details			: Life time rules, calling context, ...
-5. Overhead			: How much do we have to pay for this?
-6. List of managed interfaces	: Currently implemented managed interfaces
+   1. Intro			: Huh? Devres?
+   2. Devres			: Devres in a nutshell
+   3. Devres Group		: Group devres'es and release them together
+   4. Details			: Life time rules, calling context, ...
+   5. Overhead			: How much do we have to pay for this?
+   6. List of managed interfaces: Currently implemented managed interfaces
 
 
-  1. Intro
-  --------
+1. Intro
+--------
 
 devres came up while trying to convert libata to use iomap.  Each
 iomapped address should be kept and unmapped on driver detach.  For
@@ -42,8 +44,8 @@ would leak resources or even cause oops when failure occurs.  iomap
 adds more to this mix.  So do msi and msix.
 
 
-  2. Devres
-  ---------
+2. Devres
+---------
 
 devres is basically linked list of arbitrarily sized memory areas
 associated with a struct device.  Each devres entry is associated with
@@ -58,7 +60,7 @@ using dma_alloc_coherent().  The managed version is called
 dmam_alloc_coherent().  It is identical to dma_alloc_coherent() except
 for the DMA memory allocated using it is managed and will be
 automatically released on driver detach.  Implementation looks like
-the following.
+the following::
 
   struct dma_devres {
 	size_t		size;
@@ -98,7 +100,7 @@ If a driver uses dmam_alloc_coherent(), the area is guaranteed to be
 freed whether initialization fails half-way or the device gets
 detached.  If most resources are acquired using managed interface, a
 driver can have much simpler init and exit code.  Init path basically
-looks like the following.
+looks like the following::
 
   my_init_one()
   {
@@ -119,7 +121,7 @@ looks like the following.
 	return register_to_upper_layer(d);
   }
 
-And exit path,
+And exit path::
 
   my_remove_one()
   {
@@ -140,13 +142,13 @@ on you. In some cases this may mean introducing checks that were not
 necessary before moving to the managed devm_* calls.
 
 
-  3. Devres group
-  ---------------
+3. Devres group
+---------------
 
 Devres entries can be grouped using devres group.  When a group is
 released, all contained normal devres entries and properly nested
 groups are released.  One usage is to rollback series of acquired
-resources on failure.  For example,
+resources on failure.  For example::
 
   if (!devres_open_group(dev, NULL, GFP_KERNEL))
 	return -ENOMEM;
@@ -172,7 +174,7 @@ like above are usually useful in midlayer driver (e.g. libata core
 layer) where interface function shouldn't have side effect on failure.
 For LLDs, just returning error code suffices in most cases.
 
-Each group is identified by void *id.  It can either be explicitly
+Each group is identified by `void *id`.  It can either be explicitly
 specified by @id argument to devres_open_group() or automatically
 created by passing NULL as @id as in the above example.  In both
 cases, devres_open_group() returns the group's id.  The returned id
@@ -180,7 +182,7 @@ can be passed to other devres functions to select the target group.
 If NULL is given to those functions, the latest open group is
 selected.
 
-For example, you can do something like the following.
+For example, you can do something like the following::
 
   int my_midlayer_create_something()
   {
@@ -199,8 +201,8 @@ For example, you can do something like the following.
   }
 
 
-  4. Details
-  ----------
+4. Details
+----------
 
 Lifetime of a devres entry begins on devres allocation and finishes
 when it is released or destroyed (removed and freed) - no reference
@@ -220,8 +222,8 @@ All devres interface functions can be called without context if the
 right gfp mask is given.
 
 
-  5. Overhead
-  -----------
+5. Overhead
+-----------
 
 Each devres bookkeeping info is allocated together with requested data
 area.  With debug option turned off, bookkeeping info occupies 16
@@ -237,8 +239,8 @@ and 400 bytes on 32bit machine after naive conversion (we can
 certainly invest a bit more effort into libata core layer).
 
 
-  6. List of managed interfaces
-  -----------------------------
+6. List of managed interfaces
+-----------------------------
 
 CLOCK
   devm_clk_get()
diff --git a/Documentation/driver-model/driver.txt b/Documentation/driver-model/driver.rst
similarity index 75%
rename from Documentation/driver-model/driver.txt
rename to Documentation/driver-model/driver.rst
index d661e6f7e6a0..11d281506a04 100644
--- a/Documentation/driver-model/driver.txt
+++ b/Documentation/driver-model/driver.rst
@@ -1,5 +1,6 @@
-
+==============
 Device Drivers
+==============
 
 See the kerneldoc for the struct device_driver.
 
@@ -26,50 +27,50 @@ Declaration
 As stated above, struct device_driver objects are statically
 allocated. Below is an example declaration of the eepro100
 driver. This declaration is hypothetical only; it relies on the driver
-being converted completely to the new model. 
+being converted completely to the new model::
 
-static struct device_driver eepro100_driver = {
-       .name		= "eepro100",
-       .bus		= &pci_bus_type,
-       
-       .probe		= eepro100_probe,
-       .remove		= eepro100_remove,
-       .suspend		= eepro100_suspend,
-       .resume		= eepro100_resume,
-};
+  static struct device_driver eepro100_driver = {
+         .name		= "eepro100",
+         .bus		= &pci_bus_type,
+
+         .probe		= eepro100_probe,
+         .remove		= eepro100_remove,
+         .suspend		= eepro100_suspend,
+         .resume		= eepro100_resume,
+  };
 
 Most drivers will not be able to be converted completely to the new
 model because the bus they belong to has a bus-specific structure with
-bus-specific fields that cannot be generalized. 
+bus-specific fields that cannot be generalized.
 
 The most common example of this are device ID structures. A driver
 typically defines an array of device IDs that it supports. The format
 of these structures and the semantics for comparing device IDs are
 completely bus-specific. Defining them as bus-specific entities would
-sacrifice type-safety, so we keep bus-specific structures around. 
+sacrifice type-safety, so we keep bus-specific structures around.
 
 Bus-specific drivers should include a generic struct device_driver in
-the definition of the bus-specific driver. Like this:
+the definition of the bus-specific driver. Like this::
 
-struct pci_driver {
-       const struct pci_device_id *id_table;
-       struct device_driver	  driver;
-};
+  struct pci_driver {
+         const struct pci_device_id *id_table;
+         struct device_driver	  driver;
+  };
 
 A definition that included bus-specific fields would look like
-(using the eepro100 driver again):
+(using the eepro100 driver again)::
 
-static struct pci_driver eepro100_driver = {
-       .id_table       = eepro100_pci_tbl,
-       .driver	       = {
+  static struct pci_driver eepro100_driver = {
+         .id_table       = eepro100_pci_tbl,
+         .driver	       = {
 		.name		= "eepro100",
 		.bus		= &pci_bus_type,
 		.probe		= eepro100_probe,
 		.remove		= eepro100_remove,
 		.suspend	= eepro100_suspend,
 		.resume		= eepro100_resume,
-       },
-};
+         },
+  };
 
 Some may find the syntax of embedded struct initialization awkward or
 even a bit ugly. So far, it's the best way we've found to do what we want...
@@ -77,12 +78,14 @@ even a bit ugly. So far, it's the best way we've found to do what we want...
 Registration
 ~~~~~~~~~~~~
 
-int driver_register(struct device_driver * drv);
+::
+
+  int driver_register(struct device_driver *drv);
 
 The driver registers the structure on startup. For drivers that have
 no bus-specific fields (i.e. don't have a bus-specific driver
 structure), they would use driver_register and pass a pointer to their
-struct device_driver object. 
+struct device_driver object.
 
 Most drivers, however, will have a bus-specific structure and will
 need to register with the bus using something like pci_driver_register.
@@ -101,7 +104,7 @@ By defining wrapper functions, the transition to the new model can be
 made easier. Drivers can ignore the generic structure altogether and
 let the bus wrapper fill in the fields. For the callbacks, the bus can
 define generic callbacks that forward the call to the bus-specific
-callbacks of the drivers. 
+callbacks of the drivers.
 
 This solution is intended to be only temporary. In order to get class
 information in the driver, the drivers must be modified anyway. Since
@@ -113,16 +116,16 @@ Access
 ~~~~~~
 
 Once the object has been registered, it may access the common fields of
-the object, like the lock and the list of devices. 
+the object, like the lock and the list of devices::
 
-int driver_for_each_dev(struct device_driver * drv, void * data, 
-		        int (*callback)(struct device * dev, void * data));
+  int driver_for_each_dev(struct device_driver *drv, void *data,
+			  int (*callback)(struct device *dev, void *data));
 
 The devices field is a list of all the devices that have been bound to
 the driver. The LDM core provides a helper function to operate on all
 the devices a driver controls. This helper locks the driver on each
 node access, and does proper reference counting on each device as it
-accesses it. 
+accesses it.
 
 
 sysfs
@@ -142,7 +145,9 @@ supports.
 Callbacks
 ~~~~~~~~~
 
-	int	(*probe)	(struct device * dev);
+::
+
+	int	(*probe)	(struct device *dev);
 
 The probe() entry is called in task context, with the bus's rwsem locked
 and the driver partially bound to the device.  Drivers commonly use
@@ -162,9 +167,9 @@ the driver to that device.
 
 A driver's probe() may return a negative errno value to indicate that
 the driver did not bind to this device, in which case it should have
-released all resources it allocated.
+released all resources it allocated::
 
-	int 	(*remove)	(struct device * dev);
+	int 	(*remove)	(struct device *dev);
 
 remove is called to unbind a driver from a device. This may be
 called if a device is physically removed from the system, if the
@@ -173,43 +178,46 @@ in other cases.
 
 It is up to the driver to determine if the device is present or
 not. It should free any resources allocated specifically for the
-device; i.e. anything in the device's driver_data field. 
+device; i.e. anything in the device's driver_data field.
 
 If the device is still present, it should quiesce the device and place
-it into a supported low-power state.
+it into a supported low-power state::
 
-	int	(*suspend)	(struct device * dev, pm_message_t state);
+	int	(*suspend)	(struct device *dev, pm_message_t state);
 
-suspend is called to put the device in a low power state.
+suspend is called to put the device in a low power state::
 
-	int	(*resume)	(struct device * dev);
+	int	(*resume)	(struct device *dev);
 
 Resume is used to bring a device back from a low power state.
 
 
 Attributes
 ~~~~~~~~~~
-struct driver_attribute {
-        struct attribute        attr;
-        ssize_t (*show)(struct device_driver *driver, char *buf);
-        ssize_t (*store)(struct device_driver *, const char * buf, size_t count);
-};
 
-Device drivers can export attributes via their sysfs directories. 
+::
+
+  struct driver_attribute {
+          struct attribute        attr;
+          ssize_t (*show)(struct device_driver *driver, char *buf);
+          ssize_t (*store)(struct device_driver *, const char *buf, size_t count);
+  };
+
+Device drivers can export attributes via their sysfs directories.
 Drivers can declare attributes using a DRIVER_ATTR_RW and DRIVER_ATTR_RO
 macro that works identically to the DEVICE_ATTR_RW and DEVICE_ATTR_RO
 macros.
 
-Example:
+Example::
 
-DRIVER_ATTR_RW(debug);
+	DRIVER_ATTR_RW(debug);
 
-This is equivalent to declaring:
+This is equivalent to declaring::
 
-struct driver_attribute driver_attr_debug;
+	struct driver_attribute driver_attr_debug;
 
 This can then be used to add and remove the attribute from the
-driver's directory using:
+driver's directory using::
 
-int driver_create_file(struct device_driver *, const struct driver_attribute *);
-void driver_remove_file(struct device_driver *, const struct driver_attribute *);
+  int driver_create_file(struct device_driver *, const struct driver_attribute *);
+  void driver_remove_file(struct device_driver *, const struct driver_attribute *);
diff --git a/Documentation/driver-model/index.rst b/Documentation/driver-model/index.rst
new file mode 100644
index 000000000000..9f85d579ce56
--- /dev/null
+++ b/Documentation/driver-model/index.rst
@@ -0,0 +1,26 @@
+:orphan:
+
+============
+Driver Model
+============
+
+.. toctree::
+   :maxdepth: 1
+
+   binding
+   bus
+   class
+   design-patterns
+   device
+   devres
+   driver
+   overview
+   platform
+   porting
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/driver-model/overview.txt b/Documentation/driver-model/overview.rst
similarity index 90%
rename from Documentation/driver-model/overview.txt
rename to Documentation/driver-model/overview.rst
index 6a8f9a8075d8..d4d1e9b40e0c 100644
--- a/Documentation/driver-model/overview.txt
+++ b/Documentation/driver-model/overview.rst
@@ -1,4 +1,6 @@
+=============================
 The Linux Kernel Device Model
+=============================
 
 Patrick Mochel	<mochel@digitalimplant.org>
 
@@ -41,14 +43,14 @@ data structure. These fields must still be accessed by the bus layers,
 and sometimes by the device-specific drivers.
 
 Other bus layers are encouraged to do what has been done for the PCI layer.
-struct pci_dev now looks like this:
+struct pci_dev now looks like this::
 
-struct pci_dev {
+  struct pci_dev {
 	...
 
 	struct device dev;     /* Generic device interface */
 	...
-};
+  };
 
 Note first that the struct device dev within the struct pci_dev is
 statically allocated. This means only one allocation on device discovery.
@@ -80,26 +82,26 @@ easy. This has been accomplished by implementing a special purpose virtual
 file system named sysfs.
 
 Almost all mainstream Linux distros mount this filesystem automatically; you
-can see some variation of the following in the output of the "mount" command:
+can see some variation of the following in the output of the "mount" command::
 
-$ mount
-...
-none on /sys type sysfs (rw,noexec,nosuid,nodev)
-...
-$
+  $ mount
+  ...
+  none on /sys type sysfs (rw,noexec,nosuid,nodev)
+  ...
+  $
 
 The auto-mounting of sysfs is typically accomplished by an entry similar to
-the following in the /etc/fstab file:
+the following in the /etc/fstab file::
 
-none     	/sys	sysfs    defaults	  	0 0
+  none     	/sys	sysfs    defaults	  	0 0
 
-or something similar in the /lib/init/fstab file on Debian-based systems:
+or something similar in the /lib/init/fstab file on Debian-based systems::
 
-none            /sys    sysfs    nodev,noexec,nosuid    0 0
+  none            /sys    sysfs    nodev,noexec,nosuid    0 0
 
-If sysfs is not automatically mounted, you can always do it manually with:
+If sysfs is not automatically mounted, you can always do it manually with::
 
-# mount -t sysfs sysfs /sys
+	# mount -t sysfs sysfs /sys
 
 Whenever a device is inserted into the tree, a directory is created for it.
 This directory may be populated at each layer of discovery - the global layer,
@@ -108,7 +110,7 @@ the bus layer, or the device layer.
 The global layer currently creates two files - 'name' and 'power'. The
 former only reports the name of the device. The latter reports the
 current power state of the device. It will also be used to set the current
-power state. 
+power state.
 
 The bus layer may also create files for the devices it finds while probing the
 bus. For example, the PCI layer currently creates 'irq' and 'resource' files
@@ -118,6 +120,5 @@ A device-specific driver may also export files in its directory to expose
 device-specific data or tunable interfaces.
 
 More information about the sysfs directory layout can be found in
-the other documents in this directory and in the file 
+the other documents in this directory and in the file
 Documentation/filesystems/sysfs.txt.
-
diff --git a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.rst
similarity index 95%
rename from Documentation/driver-model/platform.txt
rename to Documentation/driver-model/platform.rst
index 9d9e47dfc013..334dd4071ae4 100644
--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.rst
@@ -1,5 +1,7 @@
+============================
 Platform Devices and Drivers
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+============================
+
 See <linux/platform_device.h> for the driver model interface to the
 platform bus:  platform_device, and platform_driver.  This pseudo-bus
 is used to connect devices on busses with minimal infrastructure,
@@ -19,15 +21,15 @@ be connected through a segment of some other kind of bus; but its
 registers will still be directly addressable.
 
 Platform devices are given a name, used in driver binding, and a
-list of resources such as addresses and IRQs.
+list of resources such as addresses and IRQs::
 
-struct platform_device {
+  struct platform_device {
 	const char	*name;
 	u32		id;
 	struct device	dev;
 	u32		num_resources;
 	struct resource	*resource;
-};
+  };
 
 
 Platform drivers
@@ -35,9 +37,9 @@ Platform drivers
 Platform drivers follow the standard driver model convention, where
 discovery/enumeration is handled outside the drivers, and drivers
 provide probe() and remove() methods.  They support power management
-and shutdown notifications using the standard conventions.
+and shutdown notifications using the standard conventions::
 
-struct platform_driver {
+  struct platform_driver {
 	int (*probe)(struct platform_device *);
 	int (*remove)(struct platform_device *);
 	void (*shutdown)(struct platform_device *);
@@ -46,25 +48,25 @@ struct platform_driver {
 	int (*resume_early)(struct platform_device *);
 	int (*resume)(struct platform_device *);
 	struct device_driver driver;
-};
+  };
 
 Note that probe() should in general verify that the specified device hardware
 actually exists; sometimes platform setup code can't be sure.  The probing
 can use device resources, including clocks, and device platform_data.
 
-Platform drivers register themselves the normal way:
+Platform drivers register themselves the normal way::
 
 	int platform_driver_register(struct platform_driver *drv);
 
 Or, in common situations where the device is known not to be hot-pluggable,
 the probe() routine can live in an init section to reduce the driver's
-runtime memory footprint:
+runtime memory footprint::
 
 	int platform_driver_probe(struct platform_driver *drv,
 			  int (*probe)(struct platform_device *))
 
 Kernel modules can be composed of several platform drivers. The platform core
-provides helpers to register and unregister an array of drivers:
+provides helpers to register and unregister an array of drivers::
 
 	int __platform_register_drivers(struct platform_driver * const *drivers,
 				      unsigned int count, struct module *owner);
@@ -73,7 +75,7 @@ provides helpers to register and unregister an array of drivers:
 
 If one of the drivers fails to register, all drivers registered up to that
 point will be unregistered in reverse order. Note that there is a convenience
-macro that passes THIS_MODULE as owner parameter:
+macro that passes THIS_MODULE as owner parameter::
 
 	#define platform_register_drivers(drivers, count)
 
@@ -81,7 +83,7 @@ macro that passes THIS_MODULE as owner parameter:
 Device Enumeration
 ~~~~~~~~~~~~~~~~~~
 As a rule, platform specific (and often board-specific) setup code will
-register platform devices:
+register platform devices::
 
 	int platform_device_register(struct platform_device *pdev);
 
@@ -133,14 +135,14 @@ tend to already have "normal" modes, such as ones using device nodes that
 were created by PNP or by platform device setup.
 
 None the less, there are some APIs to support such legacy drivers.  Avoid
-using these calls except with such hotplug-deficient drivers.
+using these calls except with such hotplug-deficient drivers::
 
 	struct platform_device *platform_device_alloc(
 			const char *name, int id);
 
 You can use platform_device_alloc() to dynamically allocate a device, which
 you will then initialize with resources and platform_device_register().
-A better solution is usually:
+A better solution is usually::
 
 	struct platform_device *platform_device_register_simple(
 			const char *name, int id,
diff --git a/Documentation/driver-model/porting.txt b/Documentation/driver-model/porting.rst
similarity index 62%
rename from Documentation/driver-model/porting.txt
rename to Documentation/driver-model/porting.rst
index 453053f1661f..ae4bf843c1d6 100644
--- a/Documentation/driver-model/porting.txt
+++ b/Documentation/driver-model/porting.rst
@@ -1,5 +1,6 @@
-
+=======================================
 Porting Drivers to the New Driver Model
+=======================================
 
 Patrick Mochel
 
@@ -8,8 +9,8 @@ Patrick Mochel
 
 Overview
 
-Please refer to Documentation/driver-model/*.txt for definitions of
-various driver types and concepts. 
+Please refer to `Documentation/driver-model/*.rst` for definitions of
+various driver types and concepts.
 
 Most of the work of porting devices drivers to the new model happens
 at the bus driver layer. This was intentional, to minimize the
@@ -18,11 +19,11 @@ of bus drivers.
 
 In a nutshell, the driver model consists of a set of objects that can
 be embedded in larger, bus-specific objects. Fields in these generic
-objects can replace fields in the bus-specific objects. 
+objects can replace fields in the bus-specific objects.
 
 The generic objects must be registered with the driver model core. By
 doing so, they will exported via the sysfs filesystem. sysfs can be
-mounted by doing 
+mounted by doing::
 
 	# mount -t sysfs sysfs /sys
 
@@ -30,108 +31,109 @@ mounted by doing
 
 The Process
 
-Step 0: Read include/linux/device.h for object and function definitions. 
+Step 0: Read include/linux/device.h for object and function definitions.
 
-Step 1: Registering the bus driver. 
+Step 1: Registering the bus driver.
 
 
-- Define a struct bus_type for the bus driver.
+- Define a struct bus_type for the bus driver::
 
-struct bus_type pci_bus_type = {
-        .name           = "pci",
-};
+    struct bus_type pci_bus_type = {
+          .name           = "pci",
+    };
 
 
 - Register the bus type.
+
   This should be done in the initialization function for the bus type,
-  which is usually the module_init(), or equivalent, function. 
+  which is usually the module_init(), or equivalent, function::
 
-static int __init pci_driver_init(void)
-{
-        return bus_register(&pci_bus_type);
-}
+    static int __init pci_driver_init(void)
+    {
+            return bus_register(&pci_bus_type);
+    }
 
-subsys_initcall(pci_driver_init);
+    subsys_initcall(pci_driver_init);
 
 
   The bus type may be unregistered (if the bus driver may be compiled
-  as a module) by doing:
+  as a module) by doing::
 
      bus_unregister(&pci_bus_type);
 
 
-- Export the bus type for others to use. 
+- Export the bus type for others to use.
 
-  Other code may wish to reference the bus type, so declare it in a 
+  Other code may wish to reference the bus type, so declare it in a
   shared header file and export the symbol.
 
-From include/linux/pci.h:
+From include/linux/pci.h::
 
-extern struct bus_type pci_bus_type;
+  extern struct bus_type pci_bus_type;
 
 
-From file the above code appears in:
+From file the above code appears in::
 
-EXPORT_SYMBOL(pci_bus_type);
+  EXPORT_SYMBOL(pci_bus_type);
 
 
 
 - This will cause the bus to show up in /sys/bus/pci/ with two
-  subdirectories: 'devices' and 'drivers'.
+  subdirectories: 'devices' and 'drivers'::
 
-# tree -d /sys/bus/pci/
-/sys/bus/pci/
-|-- devices
-`-- drivers
+    # tree -d /sys/bus/pci/
+    /sys/bus/pci/
+    |-- devices
+    `-- drivers
 
 
 
-Step 2: Registering Devices. 
+Step 2: Registering Devices.
 
 struct device represents a single device. It mainly contains metadata
-describing the relationship the device has to other entities. 
+describing the relationship the device has to other entities.
 
 
-- Embed a struct device in the bus-specific device type. 
+- Embed a struct device in the bus-specific device type::
 
 
-struct pci_dev {
-       ...
-       struct  device  dev;            /* Generic device interface */
-       ...
-};
+    struct pci_dev {
+           ...
+           struct  device  dev;            /* Generic device interface */
+           ...
+    };
 
-  It is recommended that the generic device not be the first item in 
+  It is recommended that the generic device not be the first item in
   the struct to discourage programmers from doing mindless casts
   between the object types. Instead macros, or inline functions,
-  should be created to convert from the generic object type.
+  should be created to convert from the generic object type::
 
 
-#define to_pci_dev(n) container_of(n, struct pci_dev, dev)
+    #define to_pci_dev(n) container_of(n, struct pci_dev, dev)
 
-or 
+    or
 
-static inline struct pci_dev * to_pci_dev(struct kobject * kobj)
-{
+    static inline struct pci_dev * to_pci_dev(struct kobject * kobj)
+    {
 	return container_of(n, struct pci_dev, dev);
-}
+    }
 
-  This allows the compiler to verify type-safety of the operations 
+  This allows the compiler to verify type-safety of the operations
   that are performed (which is Good).
 
 
 - Initialize the device on registration.
 
-  When devices are discovered or registered with the bus type, the 
+  When devices are discovered or registered with the bus type, the
   bus driver should initialize the generic device. The most important
   things to initialize are the bus_id, parent, and bus fields.
 
   The bus_id is an ASCII string that contains the device's address on
   the bus. The format of this string is bus-specific. This is
-  necessary for representing devices in sysfs. 
+  necessary for representing devices in sysfs.
 
   parent is the physical parent of the device. It is important that
-  the bus driver sets this field correctly. 
+  the bus driver sets this field correctly.
 
   The driver model maintains an ordered list of devices that it uses
   for power management. This list must be in order to guarantee that
@@ -140,13 +142,13 @@ static inline struct pci_dev * to_pci_dev(struct kobject * kobj)
   devices.
 
   Also, the location of the device's sysfs directory depends on a
-  device's parent. sysfs exports a directory structure that mirrors 
+  device's parent. sysfs exports a directory structure that mirrors
   the device hierarchy. Accurately setting the parent guarantees that
   sysfs will accurately represent the hierarchy.
 
   The device's bus field is a pointer to the bus type the device
   belongs to. This should be set to the bus_type that was declared
-  and initialized before. 
+  and initialized before.
 
   Optionally, the bus driver may set the device's name and release
   fields.
@@ -155,107 +157,107 @@ static inline struct pci_dev * to_pci_dev(struct kobject * kobj)
 
      "ATI Technologies Inc Radeon QD"
 
-  The release field is a callback that the driver model core calls 
-  when the device has been removed, and all references to it have 
+  The release field is a callback that the driver model core calls
+  when the device has been removed, and all references to it have
   been released. More on this in a moment.
 
 
-- Register the device. 
+- Register the device.
 
   Once the generic device has been initialized, it can be registered
-  with the driver model core by doing:
+  with the driver model core by doing::
 
        device_register(&dev->dev);
 
-  It can later be unregistered by doing: 
+  It can later be unregistered by doing::
 
        device_unregister(&dev->dev);
 
-  This should happen on buses that support hotpluggable devices. 
+  This should happen on buses that support hotpluggable devices.
   If a bus driver unregisters a device, it should not immediately free
-  it. It should instead wait for the driver model core to call the 
-  device's release method, then free the bus-specific object. 
+  it. It should instead wait for the driver model core to call the
+  device's release method, then free the bus-specific object.
   (There may be other code that is currently referencing the device
-  structure, and it would be rude to free the device while that is 
+  structure, and it would be rude to free the device while that is
   happening).
 
 
-  When the device is registered, a directory in sysfs is created. 
-  The PCI tree in sysfs looks like: 
+  When the device is registered, a directory in sysfs is created.
+  The PCI tree in sysfs looks like::
 
-/sys/devices/pci0/
-|-- 00:00.0
-|-- 00:01.0
-|   `-- 01:00.0
-|-- 00:02.0
-|   `-- 02:1f.0
-|       `-- 03:00.0
-|-- 00:1e.0
-|   `-- 04:04.0
-|-- 00:1f.0
-|-- 00:1f.1
-|   |-- ide0
-|   |   |-- 0.0
-|   |   `-- 0.1
-|   `-- ide1
-|       `-- 1.0
-|-- 00:1f.2
-|-- 00:1f.3
-`-- 00:1f.5
+    /sys/devices/pci0/
+    |-- 00:00.0
+    |-- 00:01.0
+    |   `-- 01:00.0
+    |-- 00:02.0
+    |   `-- 02:1f.0
+    |       `-- 03:00.0
+    |-- 00:1e.0
+    |   `-- 04:04.0
+    |-- 00:1f.0
+    |-- 00:1f.1
+    |   |-- ide0
+    |   |   |-- 0.0
+    |   |   `-- 0.1
+    |   `-- ide1
+    |       `-- 1.0
+    |-- 00:1f.2
+    |-- 00:1f.3
+    `-- 00:1f.5
 
   Also, symlinks are created in the bus's 'devices' directory
-  that point to the device's directory in the physical hierarchy. 
+  that point to the device's directory in the physical hierarchy::
 
-/sys/bus/pci/devices/
-|-- 00:00.0 -> ../../../devices/pci0/00:00.0
-|-- 00:01.0 -> ../../../devices/pci0/00:01.0
-|-- 00:02.0 -> ../../../devices/pci0/00:02.0
-|-- 00:1e.0 -> ../../../devices/pci0/00:1e.0
-|-- 00:1f.0 -> ../../../devices/pci0/00:1f.0
-|-- 00:1f.1 -> ../../../devices/pci0/00:1f.1
-|-- 00:1f.2 -> ../../../devices/pci0/00:1f.2
-|-- 00:1f.3 -> ../../../devices/pci0/00:1f.3
-|-- 00:1f.5 -> ../../../devices/pci0/00:1f.5
-|-- 01:00.0 -> ../../../devices/pci0/00:01.0/01:00.0
-|-- 02:1f.0 -> ../../../devices/pci0/00:02.0/02:1f.0
-|-- 03:00.0 -> ../../../devices/pci0/00:02.0/02:1f.0/03:00.0
-`-- 04:04.0 -> ../../../devices/pci0/00:1e.0/04:04.0
+    /sys/bus/pci/devices/
+    |-- 00:00.0 -> ../../../devices/pci0/00:00.0
+    |-- 00:01.0 -> ../../../devices/pci0/00:01.0
+    |-- 00:02.0 -> ../../../devices/pci0/00:02.0
+    |-- 00:1e.0 -> ../../../devices/pci0/00:1e.0
+    |-- 00:1f.0 -> ../../../devices/pci0/00:1f.0
+    |-- 00:1f.1 -> ../../../devices/pci0/00:1f.1
+    |-- 00:1f.2 -> ../../../devices/pci0/00:1f.2
+    |-- 00:1f.3 -> ../../../devices/pci0/00:1f.3
+    |-- 00:1f.5 -> ../../../devices/pci0/00:1f.5
+    |-- 01:00.0 -> ../../../devices/pci0/00:01.0/01:00.0
+    |-- 02:1f.0 -> ../../../devices/pci0/00:02.0/02:1f.0
+    |-- 03:00.0 -> ../../../devices/pci0/00:02.0/02:1f.0/03:00.0
+    `-- 04:04.0 -> ../../../devices/pci0/00:1e.0/04:04.0
 
 
 
 Step 3: Registering Drivers.
 
 struct device_driver is a simple driver structure that contains a set
-of operations that the driver model core may call. 
+of operations that the driver model core may call.
 
 
-- Embed a struct device_driver in the bus-specific driver. 
+- Embed a struct device_driver in the bus-specific driver.
 
-  Just like with devices, do something like:
+  Just like with devices, do something like::
 
-struct pci_driver {
-       ...
-       struct device_driver    driver;
-};
+    struct pci_driver {
+           ...
+           struct device_driver    driver;
+    };
 
 
-- Initialize the generic driver structure. 
+- Initialize the generic driver structure.
 
   When the driver registers with the bus (e.g. doing pci_register_driver()),
   initialize the necessary fields of the driver: the name and bus
-  fields. 
+  fields.
 
 
 - Register the driver.
 
-  After the generic driver has been initialized, call
+  After the generic driver has been initialized, call::
 
 	driver_register(&drv->driver);
 
   to register the driver with the core.
 
   When the driver is unregistered from the bus, unregister it from the
-  core by doing:
+  core by doing::
 
         driver_unregister(&drv->driver);
 
@@ -265,15 +267,15 @@ struct pci_driver {
 
 - Sysfs representation.
 
-  Drivers are exported via sysfs in their bus's 'driver's directory. 
-  For example:
+  Drivers are exported via sysfs in their bus's 'driver's directory.
+  For example::
 
-/sys/bus/pci/drivers/
-|-- 3c59x
-|-- Ensoniq AudioPCI
-|-- agpgart-amdk7
-|-- e100
-`-- serial
+    /sys/bus/pci/drivers/
+    |-- 3c59x
+    |-- Ensoniq AudioPCI
+    |-- agpgart-amdk7
+    |-- e100
+    `-- serial
 
 
 Step 4: Define Generic Methods for Drivers.
@@ -281,30 +283,30 @@ Step 4: Define Generic Methods for Drivers.
 struct device_driver defines a set of operations that the driver model
 core calls. Most of these operations are probably similar to
 operations the bus already defines for drivers, but taking different
-parameters. 
+parameters.
 
 It would be difficult and tedious to force every driver on a bus to
 simultaneously convert their drivers to generic format. Instead, the
 bus driver should define single instances of the generic methods that
-forward call to the bus-specific drivers. For instance: 
+forward call to the bus-specific drivers. For instance::
 
 
-static int pci_device_remove(struct device * dev)
-{
-        struct pci_dev * pci_dev = to_pci_dev(dev);
-        struct pci_driver * drv = pci_dev->driver;
+  static int pci_device_remove(struct device * dev)
+  {
+          struct pci_dev * pci_dev = to_pci_dev(dev);
+          struct pci_driver * drv = pci_dev->driver;
 
-        if (drv) {
-                if (drv->remove)
-                        drv->remove(pci_dev);
-                pci_dev->driver = NULL;
-        }
-        return 0;
-}
+          if (drv) {
+                  if (drv->remove)
+                          drv->remove(pci_dev);
+                  pci_dev->driver = NULL;
+          }
+          return 0;
+  }
 
 
 The generic driver should be initialized with these methods before it
-is registered. 
+is registered::
 
         /* initialize common driver fields */
         drv->driver.name = drv->name;
@@ -320,23 +322,23 @@ is registered.
 
 Ideally, the bus should only initialize the fields if they are not
 already set. This allows the drivers to implement their own generic
-methods. 
+methods.
 
 
-Step 5: Support generic driver binding. 
+Step 5: Support generic driver binding.
 
 The model assumes that a device or driver can be dynamically
 registered with the bus at any time. When registration happens,
 devices must be bound to a driver, or drivers must be bound to all
-devices that it supports. 
+devices that it supports.
 
 A driver typically contains a list of device IDs that it supports. The
-bus driver compares these IDs to the IDs of devices registered with it. 
+bus driver compares these IDs to the IDs of devices registered with it.
 The format of the device IDs, and the semantics for comparing them are
-bus-specific, so the generic model does attempt to generalize them. 
+bus-specific, so the generic model does attempt to generalize them.
 
 Instead, a bus may supply a method in struct bus_type that does the
-comparison: 
+comparison::
 
   int (*match)(struct device * dev, struct device_driver * drv);
 
@@ -346,59 +348,59 @@ and zero otherwise. It may also return error code (for example
 not possible.
 
 When a device is registered, the bus's list of drivers is iterated
-over. bus->match() is called for each one until a match is found. 
+over. bus->match() is called for each one until a match is found.
 
 When a driver is registered, the bus's list of devices is iterated
 over. bus->match() is called for each device that is not already
-claimed by a driver. 
+claimed by a driver.
 
 When a device is successfully bound to a driver, device->driver is
 set, the device is added to a per-driver list of devices, and a
 symlink is created in the driver's sysfs directory that points to the
-device's physical directory:
+device's physical directory::
 
-/sys/bus/pci/drivers/
-|-- 3c59x
-|   `-- 00:0b.0 -> ../../../../devices/pci0/00:0b.0
-|-- Ensoniq AudioPCI
-|-- agpgart-amdk7
-|   `-- 00:00.0 -> ../../../../devices/pci0/00:00.0
-|-- e100
-|   `-- 00:0c.0 -> ../../../../devices/pci0/00:0c.0
-`-- serial
+  /sys/bus/pci/drivers/
+  |-- 3c59x
+  |   `-- 00:0b.0 -> ../../../../devices/pci0/00:0b.0
+  |-- Ensoniq AudioPCI
+  |-- agpgart-amdk7
+  |   `-- 00:00.0 -> ../../../../devices/pci0/00:00.0
+  |-- e100
+  |   `-- 00:0c.0 -> ../../../../devices/pci0/00:0c.0
+  `-- serial
 
 
 This driver binding should replace the existing driver binding
-mechanism the bus currently uses. 
+mechanism the bus currently uses.
 
 
 Step 6: Supply a hotplug callback.
 
 Whenever a device is registered with the driver model core, the
-userspace program /sbin/hotplug is called to notify userspace. 
+userspace program /sbin/hotplug is called to notify userspace.
 Users can define actions to perform when a device is inserted or
-removed. 
+removed.
 
 The driver model core passes several arguments to userspace via
 environment variables, including
 
 - ACTION: set to 'add' or 'remove'
-- DEVPATH: set to the device's physical path in sysfs. 
+- DEVPATH: set to the device's physical path in sysfs.
 
 A bus driver may also supply additional parameters for userspace to
 consume. To do this, a bus must implement the 'hotplug' method in
-struct bus_type:
+struct bus_type::
 
-     int (*hotplug) (struct device *dev, char **envp, 
+     int (*hotplug) (struct device *dev, char **envp,
                      int num_envp, char *buffer, int buffer_size);
 
-This is called immediately before /sbin/hotplug is executed. 
+This is called immediately before /sbin/hotplug is executed.
 
 
 Step 7: Cleaning up the bus driver.
 
 The generic bus, device, and driver structures provide several fields
-that can replace those defined privately to the bus driver. 
+that can replace those defined privately to the bus driver.
 
 - Device list.
 
@@ -407,36 +409,36 @@ type. This includes all devices on all instances of that bus type.
 An internal list that the bus uses may be removed, in favor of using
 this one.
 
-The core provides an iterator to access these devices. 
+The core provides an iterator to access these devices::
 
-int bus_for_each_dev(struct bus_type * bus, struct device * start, 
-                     void * data, int (*fn)(struct device *, void *));
+  int bus_for_each_dev(struct bus_type * bus, struct device * start,
+                       void * data, int (*fn)(struct device *, void *));
 
 
 - Driver list.
 
 struct bus_type also contains a list of all drivers registered with
-it. An internal list of drivers that the bus driver maintains may 
-be removed in favor of using the generic one. 
+it. An internal list of drivers that the bus driver maintains may
+be removed in favor of using the generic one.
 
-The drivers may be iterated over, like devices: 
+The drivers may be iterated over, like devices::
 
-int bus_for_each_drv(struct bus_type * bus, struct device_driver * start,
-                     void * data, int (*fn)(struct device_driver *, void *));
+  int bus_for_each_drv(struct bus_type * bus, struct device_driver * start,
+                       void * data, int (*fn)(struct device_driver *, void *));
 
 
 Please see drivers/base/bus.c for more information.
 
 
-- rwsem 
+- rwsem
 
 struct bus_type contains an rwsem that protects all core accesses to
 the device and driver lists. This can be used by the bus driver
 internally, and should be used when accessing the device or driver
-lists the bus maintains. 
+lists the bus maintains.
 
 
-- Device and driver fields. 
+- Device and driver fields.
 
 Some of the fields in struct device and struct device_driver duplicate
 fields in the bus-specific representations of these objects. Feel free
@@ -444,4 +446,3 @@ to remove the bus-specific ones and favor the generic ones. Note
 though, that this will likely mean fixing up all the drivers that
 reference the bus-specific fields (though those should all be 1-line
 changes).
-
diff --git a/Documentation/eisa.txt b/Documentation/eisa.txt
index 2806e5544e43..f388545a85a7 100644
--- a/Documentation/eisa.txt
+++ b/Documentation/eisa.txt
@@ -103,7 +103,7 @@ id_table	an array of NULL terminated EISA id strings,
 		(driver_data).
 
 driver		a generic driver, such as described in
-		Documentation/driver-model/driver.txt. Only .name,
+		Documentation/driver-model/driver.rst. Only .name,
 		.probe and .remove members are mandatory.
 =============== ====================================================
 
@@ -152,7 +152,7 @@ state    set of flags indicating the state of the device. Current
 	 flags are EISA_CONFIG_ENABLED and EISA_CONFIG_FORCED.
 res	 set of four 256 bytes I/O regions allocated to this device
 dma_mask DMA mask set from the parent device.
-dev	 generic device (see Documentation/driver-model/device.txt)
+dev	 generic device (see Documentation/driver-model/device.rst)
 ======== ============================================================
 
 You can get the 'struct eisa_device' from 'struct device' using the
diff --git a/Documentation/hwmon/submitting-patches.rst b/Documentation/hwmon/submitting-patches.rst
index f9796b9d9db6..d5b05d3e54ba 100644
--- a/Documentation/hwmon/submitting-patches.rst
+++ b/Documentation/hwmon/submitting-patches.rst
@@ -89,7 +89,7 @@ increase the chances of your change being accepted.
   console. Excessive logging can seriously affect system performance.
 
 * Use devres functions whenever possible to allocate resources. For rationale
-  and supported functions, please see Documentation/driver-model/devres.txt.
+  and supported functions, please see Documentation/driver-model/devres.rst.
   If a function is not supported by devres, consider using devm_add_action().
 
 * If the driver has a detect function, make sure it is silent. Debug messages
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4d1729853d1a..713903290385 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2002-3 Patrick Mochel
  * Copyright (c) 2002-3 Open Source Development Labs
  *
- * Please see Documentation/driver-model/platform.txt for more
+ * Please see Documentation/driver-model/platform.rst for more
  * information.
  */
 
diff --git a/drivers/gpio/gpio-cs5535.c b/drivers/gpio/gpio-cs5535.c
index 6314225dbed0..3611a0571667 100644
--- a/drivers/gpio/gpio-cs5535.c
+++ b/drivers/gpio/gpio-cs5535.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(mask, "GPIO channel mask.");
 
 /*
  * FIXME: convert this singleton driver to use the state container
- * design pattern, see Documentation/driver-model/design-patterns.txt
+ * design pattern, see Documentation/driver-model/design-patterns.rst
  */
 static struct cs5535_gpio_chip {
 	struct gpio_chip chip;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 28ec0d57941d..41c90f2ddb31 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2286,7 +2286,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	struct ice_hw *hw;
 	int err;
 
-	/* this driver uses devres, see Documentation/driver-model/devres.txt */
+	/* this driver uses devres, see Documentation/driver-model/devres.rst */
 	err = pcim_enable_device(pdev);
 	if (err)
 		return err;
diff --git a/scripts/coccinelle/free/devm_free.cocci b/scripts/coccinelle/free/devm_free.cocci
index b2a2cf8bf81f..e32236a979a8 100644
--- a/scripts/coccinelle/free/devm_free.cocci
+++ b/scripts/coccinelle/free/devm_free.cocci
@@ -2,7 +2,7 @@
 /// functions.  Values allocated using the devm_functions are freed when
 /// the device is detached, and thus the use of the standard freeing
 /// function would cause a double free.
-/// See Documentation/driver-model/devres.txt for more information.
+/// See Documentation/driver-model/devres.rst for more information.
 ///
 /// A difficulty of detecting this problem is that the standard freeing
 /// function might be called from a different function than the one
-- 
2.21.0

