Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C4FDBD45
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438069AbfJRFyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:54:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33531 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfJRFyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:54:43 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so8521137wme.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 22:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IH5O+JFgo9xxNOHRujQMsqGAct1TGmQdAPQzqEkfwWA=;
        b=VWo2cj7T4O4iFh+NgzgLRSSLZKBdc0UpV6m1LOE6m1udasYFd6hULeyz5felfLNypQ
         KWj9ADAY6vwVRHCnRTcrnU2UqoiUTImvxonGUyhtjZV8Yf7Z7pey7vQ64HyUhHZ4DRwR
         vFsax/h5ZLm0lXLDPeMJtLDbNc8IfhaIPHJWFs4duYDeVVFnfYRq4F9KGGVji6SHOalb
         HHIT2mZZ7GXX+cD9eRoUyzGKogUXO6pF9NGWbdIU/g4u07+p8sg0jG1eIKmcPAmWlexc
         a+6UFCs6P9XXGPun7HD0dEorRM/rznaKZP+qIM1gafYo4Irwd3Tj83+jQZPaiPcT4Qnu
         ET6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IH5O+JFgo9xxNOHRujQMsqGAct1TGmQdAPQzqEkfwWA=;
        b=fqam2JENSS08IFhXTpuCyTnXwulKoA7ZymqNTYKq9dcDlGObbUpAGJBEABejHyzbzc
         nzPeMDq8VmBXrAlfZQMJLGWQ24lOTuf8Mx3SRuVglfsYgjjLsc3htwMWXMvilxIgZoHx
         1MNpF1lLSA0m54TtsrQM73QNFV5XxrOG4dbfwTqbZFwweV03fa1R5QxTqfu1t7ZSwYnG
         QoHDCP5190h164zLe0rQWLpZb2LlZCiJbfhpV2jzHnqm4VH5Qt0us+lncXvLhyJhnzeU
         7ildCy2/QhuX7x6ZLjeH5OxaphuFLkjDEKvMUKQaWocuTFSG7wyWgv3M9DdnPBHRQR+8
         k7yg==
X-Gm-Message-State: APjAAAX4I7KM4Ry6sGo6uqGsmFdaD2iAIfzdQ5MKztelt8xJI4XpCn0J
        kLUjVkVEdFhNr8nrEPLkhK+05w==
X-Google-Smtp-Source: APXvYqxe27K/H6/aP2x6SpggOSvQoR+lfqWDUgdqpP3ms56CKRtWMe2Hk/q3KQe8GFHRoW42G/22uw==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr6120820wmk.52.1571378078177;
        Thu, 17 Oct 2019 22:54:38 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id o4sm6859497wre.91.2019.10.17.22.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 22:54:37 -0700 (PDT)
Date:   Fri, 18 Oct 2019 07:54:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: Add support for devlink device
 parameters
Message-ID: <20191018055436.GC2185@nanopsycho>
References: <20191017192055.23770-1-andrew@lunn.ch>
 <20191017192055.23770-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017192055.23770-2-andrew@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 17, 2019 at 09:20:54PM CEST, andrew@lunn.ch wrote:
>Add plumbing to allow DSA drivers to register parameters with devlink.
>
>To keep with the abstraction, the DSA drivers pass the ds structure to
>these helpers, and the DSA core then translates that to the devlink
>structure associated to the device.
>
>Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>---
> include/net/dsa.h | 23 +++++++++++++++++++++++
> net/dsa/dsa.c     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
> net/dsa/dsa2.c    |  7 ++++++-
> 3 files changed, 77 insertions(+), 1 deletion(-)
>
>diff --git a/include/net/dsa.h b/include/net/dsa.h
>index 8c3ea0530f65..6623f4428930 100644
>--- a/include/net/dsa.h
>+++ b/include/net/dsa.h
>@@ -541,6 +541,29 @@ struct dsa_switch_ops {
> 	 */
> 	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
> 					  struct sk_buff *skb);
>+	/* Devlink parameters */
>+	int	(*devlink_param_get)(struct dsa_switch *ds, u32 id,
>+				     struct devlink_param_gset_ctx *ctx);
>+	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
>+				     struct devlink_param_gset_ctx *ctx);
>+};
>+
>+#define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
>+	DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes,		\
>+			     dsa_dl_param_get,	dsa_dl_param_set, NULL)
>+
>+int dsa_dl_param_get(struct devlink *dl, u32 id,
>+		     struct devlink_param_gset_ctx *ctx);
>+int dsa_dl_param_set(struct devlink *dl, u32 id,
>+		     struct devlink_param_gset_ctx *ctx);
>+int dsa_devlink_params_register(struct dsa_switch *ds,

"dl/devlink". I think that the names should be consistent.


>+				const struct devlink_param *params,
>+				size_t params_count);
>+void dsa_devlink_params_unregister(struct dsa_switch *ds,
>+				   const struct devlink_param *params,
>+				   size_t params_count);
>+struct dsa_devlink_priv {
>+	struct dsa_switch *ds;
> };
> 
> struct dsa_switch_driver {
>diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
>index 43120a3fb06f..ea7678650d8c 100644
>--- a/net/dsa/dsa.c
>+++ b/net/dsa/dsa.c
>@@ -329,6 +329,54 @@ int call_dsa_notifiers(unsigned long val, struct net_device *dev,
> }
> EXPORT_SYMBOL_GPL(call_dsa_notifiers);
> 
>+int dsa_dl_param_get(struct devlink *dl, u32 id,
>+		     struct devlink_param_gset_ctx *ctx)
>+{
>+	struct dsa_devlink_priv *dl_priv;
>+	struct dsa_switch *ds;
>+
>+	dl_priv = devlink_priv(dl);
>+	ds = dl_priv->ds;
>+
>+	if (!ds->ops->devlink_param_get)
>+		return -EOPNOTSUPP;
>+
>+	return ds->ops->devlink_param_get(ds, id, ctx);
>+}
>+EXPORT_SYMBOL_GPL(dsa_dl_param_get);
>+
>+int dsa_dl_param_set(struct devlink *dl, u32 id,
>+		     struct devlink_param_gset_ctx *ctx)
>+{
>+	struct dsa_devlink_priv *dl_priv;
>+	struct dsa_switch *ds;
>+
>+	dl_priv = devlink_priv(dl);
>+	ds = dl_priv->ds;
>+
>+	if (!ds->ops->devlink_param_set)
>+		return -EOPNOTSUPP;
>+
>+	return ds->ops->devlink_param_set(ds, id, ctx);
>+}
>+EXPORT_SYMBOL_GPL(dsa_dl_param_set);
>+
>+int dsa_devlink_params_register(struct dsa_switch *ds,
>+				const struct devlink_param *params,
>+				size_t params_count)
>+{
>+	return devlink_params_register(ds->devlink, params, params_count);
>+}
>+EXPORT_SYMBOL_GPL(dsa_devlink_params_register);
>+
>+void dsa_devlink_params_unregister(struct dsa_switch *ds,
>+				   const struct devlink_param *params,
>+				   size_t params_count)
>+{
>+	devlink_params_unregister(ds->devlink, params, params_count);
>+}
>+EXPORT_SYMBOL_GPL(dsa_devlink_params_unregister);
>+
> static int __init dsa_init_module(void)
> {
> 	int rc;
>diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
>index 73002022c9d8..d74cc82fb44a 100644
>--- a/net/dsa/dsa2.c
>+++ b/net/dsa/dsa2.c
>@@ -367,6 +367,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
> 
> static int dsa_switch_setup(struct dsa_switch *ds)
> {
>+	struct dsa_devlink_priv *dl_priv;
> 	int err = 0;
> 
> 	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
>@@ -379,9 +380,11 @@ static int dsa_switch_setup(struct dsa_switch *ds)
> 	/* Add the switch to devlink before calling setup, so that setup can
> 	 * add dpipe tables
> 	 */
>-	ds->devlink = devlink_alloc(&dsa_devlink_ops, 0);
>+	ds->devlink = devlink_alloc(&dsa_devlink_ops, sizeof(*devlink_priv));

This should most likely be:
sizeof(*dl_priv)


> 	if (!ds->devlink)
> 		return -ENOMEM;
>+	dl_priv = devlink_priv(ds->devlink);
>+	dl_priv->ds = ds;
> 
> 	err = devlink_register(ds->devlink, ds->dev);
> 	if (err)
>@@ -395,6 +398,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
> 	if (err < 0)
> 		goto unregister_notifier;
> 
>+	devlink_params_publish(ds->devlink);
>+
> 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
> 		if (!ds->slave_mii_bus) {
>-- 
>2.23.0
>
