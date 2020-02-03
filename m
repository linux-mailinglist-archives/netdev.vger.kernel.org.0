Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB35150549
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 12:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgBCL3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 06:29:24 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39886 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgBCL3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 06:29:24 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so16521555wme.4
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 03:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BW6+FcVvXoWKx673OHc/pLds+3Zm/1oRcASUEYB6nPk=;
        b=gmN8bjffLtPUqpMoFr9Draae64MXTGn8RQrACd/ajjv1vehEToT01wbCriRCuWz63d
         bCIjPvXs3IXirl2SOo1x2glMJ7S/aFzxHL32SUIiwG9mLjbTx69RSNW+tUchWxusOv1j
         UoYFFerhWpbgrrTbJgXJE9PsAYwJTipaI8prK0N9dS/YjoVhcFFpuyJK/qUUrhNhdERV
         0hOemrFkO+tapzg1nxBo7eb+KlEd4CamgaOGvAH5+x85Fl1nokmsykirN/oJSWQ4R+S/
         phEUAzhVZs2KIHgMIKnq44WVZgidyc1HtqaC6gnackjYt/1VaLbQD4rsmHyxIa6NFw/V
         NjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BW6+FcVvXoWKx673OHc/pLds+3Zm/1oRcASUEYB6nPk=;
        b=SnVm6n3Kf/SiTvAXhWT8LPjdgDp3Kr7rN04VzkegJfZhix/PIaSBp8CxXx5FQfxTFF
         zWgqKZa+8uYVzi9jb/xriiuQR27m1Qlc6QuXm84kmI+tJ7lkMwilnn/qNgApyUfkcfJz
         vJollSB/sI/cCBtMxxVokHwQRnwZk9d8+mXgPvQl0PugZx3dnNBdl/W2CgjiCzTW9/JN
         m4YQurY1T2HWkPTtKjhZnCra575F52cOmM2TT+8n5h5EczzYk5lT+pu/df093XTcrKgC
         D2kV45sXtSExfTJz9XGue5mcE3MNMWX94Kbdke+Z+JLCnbHrFILOCtFTCyCMJr88gF2q
         x4pg==
X-Gm-Message-State: APjAAAUEIeouNsHONHJ0/bOXHupnhvurTQYeMPqk2VK1JmZ0vlFmsN1m
        3iPtw/5eG+3+3YMnb0QloxFCSw==
X-Google-Smtp-Source: APXvYqwlUv2BI7hVlX4lTModGY2A9uqkd/4qmQQRDdmq3+lANO1yyjWMjppKMiY99IuazVBi+RTeBQ==
X-Received: by 2002:a1c:238e:: with SMTP id j136mr28909412wmj.33.1580729360937;
        Mon, 03 Feb 2020 03:29:20 -0800 (PST)
Received: from localhost (ip-89-177-6-126.net.upcbroadband.cz. [89.177.6.126])
        by smtp.gmail.com with ESMTPSA id s22sm22443437wmh.4.2020.02.03.03.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 03:29:20 -0800 (PST)
Date:   Mon, 3 Feb 2020 12:29:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
Subject: Re: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and
 devlinkm_free
Message-ID: <20200203112919.GB2260@nanopsycho>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-9-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130225913.1671982-9-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 30, 2020 at 11:59:03PM CET, jacob.e.keller@intel.com wrote:
>Add devres managed allocation functions for allocating a devlink
>instance. These can be used by device drivers based on the devres
>framework which want to allocate a devlink instance.
>
>For simplicity and to reduce churn in the devlink core code, the devres
>management works by creating a node with a double-pointer. The devlink
>instance is allocated using the normal devlink_alloc and released using
>the normal devlink_free.
>
>An alternative solution where the raw memory for devlink is allocated
>directly via devres_alloc could be done. Such an implementation would
>either significantly increase code duplication or code churn in order to
>refactor the setup from the allocation.
>
>The new devres managed allocation function will be used by the ice
>driver in a following change to implement initial devlink support.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> include/net/devlink.h |  4 ++++
> lib/devres.c          |  1 +
> net/core/devlink.c    | 54 +++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 59 insertions(+)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 63e954241404..1c3540280396 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -858,11 +858,15 @@ struct ib_device;
> struct net *devlink_net(const struct devlink *devlink);
> void devlink_net_set(struct devlink *devlink, struct net *net);
> struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
>+struct devlink *devlinkm_alloc(struct device * dev,
>+			       const struct devlink_ops *ops,
>+			       size_t priv_size);
> int devlink_register(struct devlink *devlink, struct device *dev);
> void devlink_unregister(struct devlink *devlink);
> void devlink_reload_enable(struct devlink *devlink);
> void devlink_reload_disable(struct devlink *devlink);
> void devlink_free(struct devlink *devlink);
>+void devlinkm_free(struct device *dev, struct devlink *devlink);
> int devlink_port_register(struct devlink *devlink,
> 			  struct devlink_port *devlink_port,
> 			  unsigned int port_index);
>diff --git a/lib/devres.c b/lib/devres.c
>index 6ef51f159c54..239c81d40612 100644
>--- a/lib/devres.c
>+++ b/lib/devres.c
>@@ -5,6 +5,7 @@
> #include <linux/gfp.h>
> #include <linux/export.h>
> #include <linux/of_address.h>
>+#include <net/devlink.h>
> 
> enum devm_ioremap_type {
> 	DEVM_IOREMAP = 0,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 574008c536fa..b2b855d12a11 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -6531,6 +6531,60 @@ void devlink_free(struct devlink *devlink)
> }
> EXPORT_SYMBOL_GPL(devlink_free);
> 
>+static void devres_devlink_release(struct device *dev, void *res)
>+{
>+	devlink_free(*(struct devlink **)res);
>+}
>+
>+static int devres_devlink_match(struct device *dev, void *res, void *data)
>+{
>+	return *(struct devlink **)res == data;
>+}
>+
>+/**
>+ * devlinkm_alloc - Allocate devlink instance managed by devres
>+ * @dev: device to allocate devlink for
>+ * @ops: devlink ops structure
>+ * @priv_size: size of private data portion
>+ *
>+ * Allocate a devlink instance and manage its release via devres.
>+ */
>+struct devlink *devlinkm_alloc(struct device *dev,

Why "devlinkm"? Looks like the usual prefix for this is "devm_"
So "devm_devlink_alloc/free"?


>+			       const struct devlink_ops *ops,
>+			       size_t priv_size)
>+{
>+	struct devlink **ptr, *devlink = NULL;
>+
>+	ptr = devres_alloc(devres_devlink_release, sizeof(*ptr), GFP_KERNEL);
>+	if (!ptr)
>+		return NULL;
>+
>+	devlink = devlink_alloc(ops, priv_size);
>+	if (devlink) {
>+		*ptr = devlink;
>+		devres_add(dev, ptr);
>+	} else {
>+		devres_free(ptr);
>+	}
>+
>+	return devlink;
>+}
>+EXPORT_SYMBOL_GPL(devlinkm_alloc);
>+
>+/**
>+ * devlinkm_free - Free devlink instance managed by devres
>+ * @dev: device to remove the allocated devlink from
>+ * @devlink: devlink instance to free
>+ *
>+ * Find and remove the devres node associated with the given devlink.
>+ */
>+void devlinkm_free(struct device *dev, struct devlink *devlink)
>+{
>+	WARN_ON(devres_release(dev, devres_devlink_release,
>+			       devres_devlink_match, devlink));
>+}
>+EXPORT_SYMBOL_GPL(devlinkm_free);
>+
> static void devlink_port_type_warn(struct work_struct *work)
> {
> 	WARN(true, "Type was not set for devlink port.");
>-- 
>2.25.0.rc1
>
