Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411962CED76
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgLDLs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgLDLs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 06:48:59 -0500
Date:   Fri, 4 Dec 2020 12:49:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607082492;
        bh=8riUQT9bCbW54dDW4SqSDmsIYyllOic9IBnpv2jP8RY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=A46brJwjdIa872dTM+2vM7n7K9F806vWyhU5xH27mw1GwGZ5jCWn615wnRuCk0ifP
         aQ3U7L5uYHJDQ36n16uxjcx5LSjr50uszqUtlt8YBWaxj1oAUopkNCgdr3I3mQZTPu
         q0LaHDbMkjd5a4WnQiS1tSIRdE4kyw7f8vikc8Ck=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] driver core: auxiliary bus: minor coding style tweaks
Message-ID: <X8oiSFTpYHw1xE/o@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <X8og8xi3WkoYXet9@kroah.com>
 <X8ohB1ks1NK7kPop@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8ohB1ks1NK7kPop@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For some reason, the original aux bus patch had some really long lines
in a few places, probably due to it being a very long-lived patch in
development by many different people.  Fix that up so that the two files
all have the same length lines and function formatting styles.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: include the right files in the patch...

 drivers/base/auxiliary.c      | 58 +++++++++++++++++++----------------
 include/linux/auxiliary_bus.h |  6 ++--
 2 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index c44e85802b43..f303daadf843 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -50,8 +50,8 @@ static int auxiliary_uevent(struct device *dev, struct kobj_uevent_env *env)
 	name = dev_name(dev);
 	p = strrchr(name, '.');
 
-	return add_uevent_var(env, "MODALIAS=%s%.*s", AUXILIARY_MODULE_PREFIX, (int)(p - name),
-			      name);
+	return add_uevent_var(env, "MODALIAS=%s%.*s", AUXILIARY_MODULE_PREFIX,
+			      (int)(p - name), name);
 }
 
 static const struct dev_pm_ops auxiliary_dev_pm_ops = {
@@ -113,16 +113,18 @@ static struct bus_type auxiliary_bus_type = {
  * auxiliary_device_init - check auxiliary_device and initialize
  * @auxdev: auxiliary device struct
  *
- * This is the first step in the two-step process to register an auxiliary_device.
+ * This is the first step in the two-step process to register an
+ * auxiliary_device.
  *
- * When this function returns an error code, then the device_initialize will *not* have
- * been performed, and the caller will be responsible to free any memory allocated for the
- * auxiliary_device in the error path directly.
+ * When this function returns an error code, then the device_initialize will
+ * *not* have been performed, and the caller will be responsible to free any
+ * memory allocated for the auxiliary_device in the error path directly.
  *
- * It returns 0 on success.  On success, the device_initialize has been performed.  After this
- * point any error unwinding will need to include a call to auxiliary_device_uninit().
- * In this post-initialize error scenario, a call to the device's .release callback will be
- * triggered, and all memory clean-up is expected to be handled there.
+ * It returns 0 on success.  On success, the device_initialize has been
+ * performed.  After this point any error unwinding will need to include a call
+ * to auxiliary_device_uninit().  In this post-initialize error scenario, a call
+ * to the device's .release callback will be triggered, and all memory clean-up
+ * is expected to be handled there.
  */
 int auxiliary_device_init(struct auxiliary_device *auxdev)
 {
@@ -149,16 +151,19 @@ EXPORT_SYMBOL_GPL(auxiliary_device_init);
  * @auxdev: auxiliary bus device to add to the bus
  * @modname: name of the parent device's driver module
  *
- * This is the second step in the two-step process to register an auxiliary_device.
+ * This is the second step in the two-step process to register an
+ * auxiliary_device.
  *
- * This function must be called after a successful call to auxiliary_device_init(), which
- * will perform the device_initialize.  This means that if this returns an error code, then a
- * call to auxiliary_device_uninit() must be performed so that the .release callback will
- * be triggered to free the memory associated with the auxiliary_device.
+ * This function must be called after a successful call to
+ * auxiliary_device_init(), which will perform the device_initialize.  This
+ * means that if this returns an error code, then a call to
+ * auxiliary_device_uninit() must be performed so that the .release callback
+ * will be triggered to free the memory associated with the auxiliary_device.
  *
- * The expectation is that users will call the "auxiliary_device_add" macro so that the caller's
- * KBUILD_MODNAME is automatically inserted for the modname parameter.  Only if a user requires
- * a custom name would this version be called directly.
+ * The expectation is that users will call the "auxiliary_device_add" macro so
+ * that the caller's KBUILD_MODNAME is automatically inserted for the modname
+ * parameter.  Only if a user requires a custom name would this version be
+ * called directly.
  */
 int __auxiliary_device_add(struct auxiliary_device *auxdev, const char *modname)
 {
@@ -166,13 +171,13 @@ int __auxiliary_device_add(struct auxiliary_device *auxdev, const char *modname)
 	int ret;
 
 	if (!modname) {
-		pr_err("auxiliary device modname is NULL\n");
+		dev_err(dev, "auxiliary device modname is NULL\n");
 		return -EINVAL;
 	}
 
 	ret = dev_set_name(dev, "%s.%s.%d", modname, auxdev->name, auxdev->id);
 	if (ret) {
-		pr_err("auxiliary device dev_set_name failed: %d\n", ret);
+		dev_err(dev, "auxiliary device dev_set_name failed: %d\n", ret);
 		return ret;
 	}
 
@@ -197,9 +202,9 @@ EXPORT_SYMBOL_GPL(__auxiliary_device_add);
  * if it does.  If the callback returns non-zero, this function will
  * return to the caller and not iterate over any more devices.
  */
-struct auxiliary_device *
-auxiliary_find_device(struct device *start, const void *data,
-		      int (*match)(struct device *dev, const void *data))
+struct auxiliary_device *auxiliary_find_device(struct device *start,
+					       const void *data,
+					       int (*match)(struct device *dev, const void *data))
 {
 	struct device *dev;
 
@@ -217,14 +222,15 @@ EXPORT_SYMBOL_GPL(auxiliary_find_device);
  * @owner: owning module/driver
  * @modname: KBUILD_MODNAME for parent driver
  */
-int __auxiliary_driver_register(struct auxiliary_driver *auxdrv, struct module *owner,
-				const char *modname)
+int __auxiliary_driver_register(struct auxiliary_driver *auxdrv,
+				struct module *owner, const char *modname)
 {
 	if (WARN_ON(!auxdrv->probe) || WARN_ON(!auxdrv->id_table))
 		return -EINVAL;
 
 	if (auxdrv->name)
-		auxdrv->driver.name = kasprintf(GFP_KERNEL, "%s.%s", modname, auxdrv->name);
+		auxdrv->driver.name = kasprintf(GFP_KERNEL, "%s.%s", modname,
+						auxdrv->name);
 	else
 		auxdrv->driver.name = kasprintf(GFP_KERNEL, "%s", modname);
 	if (!auxdrv->driver.name)
diff --git a/include/linux/auxiliary_bus.h b/include/linux/auxiliary_bus.h
index d67b17606210..fc51d45f106b 100644
--- a/include/linux/auxiliary_bus.h
+++ b/include/linux/auxiliary_bus.h
@@ -70,8 +70,8 @@ void auxiliary_driver_unregister(struct auxiliary_driver *auxdrv);
 #define module_auxiliary_driver(__auxiliary_driver) \
 	module_driver(__auxiliary_driver, auxiliary_driver_register, auxiliary_driver_unregister)
 
-struct auxiliary_device *
-auxiliary_find_device(struct device *start, const void *data,
-		      int (*match)(struct device *dev, const void *data));
+struct auxiliary_device *auxiliary_find_device(struct device *start,
+					       const void *data,
+					       int (*match)(struct device *dev, const void *data));
 
 #endif /* _AUXILIARY_BUS_H_ */
-- 
2.29.2

