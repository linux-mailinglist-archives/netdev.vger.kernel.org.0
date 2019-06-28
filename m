Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 334CA59B1B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfF1MbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:31:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39872 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbfF1Mas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nBpd8Fk+s8d+aaTmt6oIoDeIRX/XWEtS+DQSzNWScpE=; b=N0KdyA00b5X6Q9uq0E7P8iEVj0
        jmtzOc60PXzPDbTpOiHwPGFSerA7yVyIsHiuoV9FKQWBUg3EVKU+nx7FGUkOaW9IqUjqn7qmlqaN3
        fQ/SLtDQbhu1afpCxlO2B4FGpywbna5rirN+7t/10MOszesghvpHy3FIsb11K20hXFO6nMzMd5VrX
        HcHOkC/7j7VGDOT4lIyRkw12U2ZKMy1i3Na41PVYyyYNotO9+mknrUKGK71dVEhVjDo00BtNxlpz9
        RYQpgLrvrP7BY7noSrWtrpRKzCzImQmGTL+phwQ1enhJrgm6YKedXnZsQNedOVzcJPR3JxG225beu
        HuixlYTA==;
Received: from [186.213.242.156] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hgq1U-00055Y-Jg; Fri, 28 Jun 2019 12:30:37 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hgq1S-0005Sq-IY; Fri, 28 Jun 2019 09:30:34 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Kershner <david.kershner@unisys.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        cocci@systeme.lip6.fr
Subject: [PATCH 24/39] docs: driver-model: move it to the driver-api book
Date:   Fri, 28 Jun 2019 09:30:17 -0300
Message-Id: <920ff36c66233113b1825ab504fe675ed5a5bd7b.1561724493.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561724493.git.mchehab+samsung@kernel.org>
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The audience for the Kernel driver-model is clearly Kernel hackers.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/{ => driver-api}/driver-model/binding.rst       | 0
 Documentation/{ => driver-api}/driver-model/bus.rst           | 0
 Documentation/{ => driver-api}/driver-model/class.rst         | 0
 .../{ => driver-api}/driver-model/design-patterns.rst         | 0
 Documentation/{ => driver-api}/driver-model/device.rst        | 0
 Documentation/{ => driver-api}/driver-model/devres.rst        | 0
 Documentation/{ => driver-api}/driver-model/driver.rst        | 0
 Documentation/{ => driver-api}/driver-model/index.rst         | 2 --
 Documentation/{ => driver-api}/driver-model/overview.rst      | 0
 Documentation/{ => driver-api}/driver-model/platform.rst      | 0
 Documentation/{ => driver-api}/driver-model/porting.rst       | 2 +-
 Documentation/driver-api/gpio/driver.rst                      | 2 +-
 Documentation/driver-api/index.rst                            | 1 +
 Documentation/eisa.txt                                        | 4 ++--
 Documentation/filesystems/sysfs.txt                           | 2 +-
 Documentation/hwmon/submitting-patches.rst                    | 2 +-
 Documentation/translations/zh_CN/filesystems/sysfs.txt        | 2 +-
 drivers/base/platform.c                                       | 2 +-
 drivers/gpio/gpio-cs5535.c                                    | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c                     | 2 +-
 drivers/staging/unisys/Documentation/overview.txt             | 4 ++--
 include/linux/device.h                                        | 2 +-
 include/linux/platform_device.h                               | 2 +-
 scripts/coccinelle/free/devm_free.cocci                       | 2 +-
 24 files changed, 16 insertions(+), 17 deletions(-)
 rename Documentation/{ => driver-api}/driver-model/binding.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/bus.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/class.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/design-patterns.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/device.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/devres.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/driver.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/index.rst (96%)
 rename Documentation/{ => driver-api}/driver-model/overview.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/platform.rst (100%)
 rename Documentation/{ => driver-api}/driver-model/porting.rst (99%)

diff --git a/Documentation/driver-model/binding.rst b/Documentation/driver-api/driver-model/binding.rst
similarity index 100%
rename from Documentation/driver-model/binding.rst
rename to Documentation/driver-api/driver-model/binding.rst
diff --git a/Documentation/driver-model/bus.rst b/Documentation/driver-api/driver-model/bus.rst
similarity index 100%
rename from Documentation/driver-model/bus.rst
rename to Documentation/driver-api/driver-model/bus.rst
diff --git a/Documentation/driver-model/class.rst b/Documentation/driver-api/driver-model/class.rst
similarity index 100%
rename from Documentation/driver-model/class.rst
rename to Documentation/driver-api/driver-model/class.rst
diff --git a/Documentation/driver-model/design-patterns.rst b/Documentation/driver-api/driver-model/design-patterns.rst
similarity index 100%
rename from Documentation/driver-model/design-patterns.rst
rename to Documentation/driver-api/driver-model/design-patterns.rst
diff --git a/Documentation/driver-model/device.rst b/Documentation/driver-api/driver-model/device.rst
similarity index 100%
rename from Documentation/driver-model/device.rst
rename to Documentation/driver-api/driver-model/device.rst
diff --git a/Documentation/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
similarity index 100%
rename from Documentation/driver-model/devres.rst
rename to Documentation/driver-api/driver-model/devres.rst
diff --git a/Documentation/driver-model/driver.rst b/Documentation/driver-api/driver-model/driver.rst
similarity index 100%
rename from Documentation/driver-model/driver.rst
rename to Documentation/driver-api/driver-model/driver.rst
diff --git a/Documentation/driver-model/index.rst b/Documentation/driver-api/driver-model/index.rst
similarity index 96%
rename from Documentation/driver-model/index.rst
rename to Documentation/driver-api/driver-model/index.rst
index 9f85d579ce56..755016422269 100644
--- a/Documentation/driver-model/index.rst
+++ b/Documentation/driver-api/driver-model/index.rst
@@ -1,5 +1,3 @@
-:orphan:
-
 ============
 Driver Model
 ============
diff --git a/Documentation/driver-model/overview.rst b/Documentation/driver-api/driver-model/overview.rst
similarity index 100%
rename from Documentation/driver-model/overview.rst
rename to Documentation/driver-api/driver-model/overview.rst
diff --git a/Documentation/driver-model/platform.rst b/Documentation/driver-api/driver-model/platform.rst
similarity index 100%
rename from Documentation/driver-model/platform.rst
rename to Documentation/driver-api/driver-model/platform.rst
diff --git a/Documentation/driver-model/porting.rst b/Documentation/driver-api/driver-model/porting.rst
similarity index 99%
rename from Documentation/driver-model/porting.rst
rename to Documentation/driver-api/driver-model/porting.rst
index ae4bf843c1d6..931ea879af3f 100644
--- a/Documentation/driver-model/porting.rst
+++ b/Documentation/driver-api/driver-model/porting.rst
@@ -9,7 +9,7 @@ Patrick Mochel
 
 Overview
 
-Please refer to `Documentation/driver-model/*.rst` for definitions of
+Please refer to `Documentation/driver-api/driver-model/*.rst` for definitions of
 various driver types and concepts.
 
 Most of the work of porting devices drivers to the new model happens
diff --git a/Documentation/driver-api/gpio/driver.rst b/Documentation/driver-api/gpio/driver.rst
index 349f2dc33029..921c71a3d683 100644
--- a/Documentation/driver-api/gpio/driver.rst
+++ b/Documentation/driver-api/gpio/driver.rst
@@ -399,7 +399,7 @@ symbol:
   will pass the struct gpio_chip* for the chip to all IRQ callbacks, so the
   callbacks need to embed the gpio_chip in its state container and obtain a
   pointer to the container using container_of().
-  (See Documentation/driver-model/design-patterns.rst)
+  (See Documentation/driver-api/driver-model/design-patterns.rst)
 
 - gpiochip_irqchip_add_nested(): adds a nested cascaded irqchip to a gpiochip,
   as discussed above regarding different types of cascaded irqchips. The
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index fea0034afa56..93d187bf4853 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -14,6 +14,7 @@ available subsections can be seen below.
 .. toctree::
    :maxdepth: 2
 
+   driver-model/index
    basics
    infrastructure
    early-userspace/index
diff --git a/Documentation/eisa.txt b/Documentation/eisa.txt
index f388545a85a7..c07565ba57da 100644
--- a/Documentation/eisa.txt
+++ b/Documentation/eisa.txt
@@ -103,7 +103,7 @@ id_table	an array of NULL terminated EISA id strings,
 		(driver_data).
 
 driver		a generic driver, such as described in
-		Documentation/driver-model/driver.rst. Only .name,
+		Documentation/driver-api/driver-model/driver.rst. Only .name,
 		.probe and .remove members are mandatory.
 =============== ====================================================
 
@@ -152,7 +152,7 @@ state    set of flags indicating the state of the device. Current
 	 flags are EISA_CONFIG_ENABLED and EISA_CONFIG_FORCED.
 res	 set of four 256 bytes I/O regions allocated to this device
 dma_mask DMA mask set from the parent device.
-dev	 generic device (see Documentation/driver-model/device.rst)
+dev	 generic device (see Documentation/driver-api/driver-model/device.rst)
 ======== ============================================================
 
 You can get the 'struct eisa_device' from 'struct device' using the
diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 5b5311f9358d..ddf15b1b0d5a 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -319,7 +319,7 @@ quick way to lookup the sysfs interface for a device from the result of
 a stat(2) operation.
 
 More information can driver-model specific features can be found in
-Documentation/driver-model/. 
+Documentation/driver-api/driver-model/.
 
 
 TODO: Finish this section.
diff --git a/Documentation/hwmon/submitting-patches.rst b/Documentation/hwmon/submitting-patches.rst
index d5b05d3e54ba..452fc28d8e0b 100644
--- a/Documentation/hwmon/submitting-patches.rst
+++ b/Documentation/hwmon/submitting-patches.rst
@@ -89,7 +89,7 @@ increase the chances of your change being accepted.
   console. Excessive logging can seriously affect system performance.
 
 * Use devres functions whenever possible to allocate resources. For rationale
-  and supported functions, please see Documentation/driver-model/devres.rst.
+  and supported functions, please see Documentation/driver-api/driver-model/devres.rst.
   If a function is not supported by devres, consider using devm_add_action().
 
 * If the driver has a detect function, make sure it is silent. Debug messages
diff --git a/Documentation/translations/zh_CN/filesystems/sysfs.txt b/Documentation/translations/zh_CN/filesystems/sysfs.txt
index 452271dda141..ee1f37da5b23 100644
--- a/Documentation/translations/zh_CN/filesystems/sysfs.txt
+++ b/Documentation/translations/zh_CN/filesystems/sysfs.txt
@@ -288,7 +288,7 @@ dev/ 包含两个子目录： char/ 和 block/。在这两个子目录中，有
 中相应的设备。/sys/dev 提供一个通过一个 stat(2) 操作结果，查找
 设备 sysfs 接口快捷的方法。
 
-更多有关 driver-model 的特性信息可以在 Documentation/driver-model/
+更多有关 driver-model 的特性信息可以在 Documentation/driver-api/driver-model/
 中找到。
 
 
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 713903290385..506a0175a5a7 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -5,7 +5,7 @@
  * Copyright (c) 2002-3 Patrick Mochel
  * Copyright (c) 2002-3 Open Source Development Labs
  *
- * Please see Documentation/driver-model/platform.rst for more
+ * Please see Documentation/driver-api/driver-model/platform.rst for more
  * information.
  */
 
diff --git a/drivers/gpio/gpio-cs5535.c b/drivers/gpio/gpio-cs5535.c
index 3611a0571667..53b24e3ae7de 100644
--- a/drivers/gpio/gpio-cs5535.c
+++ b/drivers/gpio/gpio-cs5535.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(mask, "GPIO channel mask.");
 
 /*
  * FIXME: convert this singleton driver to use the state container
- * design pattern, see Documentation/driver-model/design-patterns.rst
+ * design pattern, see Documentation/driver-api/driver-model/design-patterns.rst
  */
 static struct cs5535_gpio_chip {
 	struct gpio_chip chip;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 41c90f2ddb31..63db08d9bafa 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2286,7 +2286,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	struct ice_hw *hw;
 	int err;
 
-	/* this driver uses devres, see Documentation/driver-model/devres.rst */
+	/* this driver uses devres, see Documentation/driver-api/driver-model/devres.rst */
 	err = pcim_enable_device(pdev);
 	if (err)
 		return err;
diff --git a/drivers/staging/unisys/Documentation/overview.txt b/drivers/staging/unisys/Documentation/overview.txt
index 9ab30af265a5..f8a4144b239c 100644
--- a/drivers/staging/unisys/Documentation/overview.txt
+++ b/drivers/staging/unisys/Documentation/overview.txt
@@ -15,7 +15,7 @@ normally be unsharable, specifically:
 * visorinput - keyboard and mouse
 
 These drivers conform to the standard Linux bus/device model described
-within Documentation/driver-model/, and utilize a driver named visorbus to
+within Documentation/driver-api/driver-model/, and utilize a driver named visorbus to
 present the virtual busses involved. Drivers in the 'visor*' driver set are
 commonly referred to as "guest drivers" or "client drivers".  All drivers
 except visorbus expose a device of a specific usable class to the Linux guest
@@ -141,7 +141,7 @@ called automatically by the visorbus driver at appropriate times:
 -----------------------------------
 
 Because visorbus is a standard Linux bus driver in the model described in
-Documentation/driver-model/, the hierarchy of s-Par virtual devices is
+Documentation/driver-api/driver-model/, the hierarchy of s-Par virtual devices is
 published in the sysfs tree beneath /bus/visorbus/, e.g.,
 /sys/bus/visorbus/devices/ might look like:
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 4f65c424e5fd..93b12aec9bff 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -6,7 +6,7 @@
  * Copyright (c) 2004-2009 Greg Kroah-Hartman <gregkh@suse.de>
  * Copyright (c) 2008-2009 Novell Inc.
  *
- * See Documentation/driver-model/ for more information.
+ * See Documentation/driver-api/driver-model/ for more information.
  */
 
 #ifndef _DEVICE_H_
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index beb25f277889..9bc36b589827 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -4,7 +4,7 @@
  *
  * Copyright (c) 2001-2003 Patrick Mochel <mochel@osdl.org>
  *
- * See Documentation/driver-model/ for more information.
+ * See Documentation/driver-api/driver-model/ for more information.
  */
 
 #ifndef _PLATFORM_DEVICE_H_
diff --git a/scripts/coccinelle/free/devm_free.cocci b/scripts/coccinelle/free/devm_free.cocci
index fefd0331a2de..441799b5359b 100644
--- a/scripts/coccinelle/free/devm_free.cocci
+++ b/scripts/coccinelle/free/devm_free.cocci
@@ -3,7 +3,7 @@
 /// functions.  Values allocated using the devm_functions are freed when
 /// the device is detached, and thus the use of the standard freeing
 /// function would cause a double free.
-/// See Documentation/driver-model/devres.rst for more information.
+/// See Documentation/driver-api/driver-model/devres.rst for more information.
 ///
 /// A difficulty of detecting this problem is that the standard freeing
 /// function might be called from a different function than the one
-- 
2.21.0

