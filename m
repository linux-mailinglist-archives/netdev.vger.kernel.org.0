Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BF6CC6E3
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 02:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfJEAV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 20:21:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41451 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJEAV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 20:21:26 -0400
Received: by mail-qt1-f195.google.com with SMTP id d16so10990064qtq.8
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 17:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=3BXMRo7GcHR6jbOQn8vhsjnlmJpeUZMP1yGrNaTGUq4=;
        b=aqkErZ3vSx2SVrxJXsJVZVSziSYPhXGf9l8Z3WaNiIRgPjqlU+ZmGjRTYFi9RKBlTM
         yjgG2UGL0PzUbbGp+j8YSHbz47ZDpTZmFw1tvctzuVWU5/FWNly51hhM/yDrbGcMQugP
         +V88bPkckEjN2VbNQkHC1jFzVRa4VG67y4DEFjvUAZ83CI2yzWyR0xdkeyXqzaa713bm
         lOcIwMTpB9ZdQ89dkq5voKksHTSwtBCuY/49kR+FJaM51SAXwFCkxEf55Kv5nCqU1fvi
         6whIgLVdE5NJEJD4xJPtYaBJdy4iUHukac/oSu2Eb1swUS5At/Dt3NbyXppNX3daVoI9
         8KQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3BXMRo7GcHR6jbOQn8vhsjnlmJpeUZMP1yGrNaTGUq4=;
        b=LZnm81n+qmOif/7kApbYMyIo4HD59pWNlhXFlcvs87p24Hzn/cs8AUMVzU8q60SoLK
         GPJQC9yo8f4d1CyDNikVLJLsAj+t211eXbfTN0ZtYJZ8rhyQ/Wi9MRjrcohGz1rgm8Lw
         Bow3t5qioqOyrQEV4lfXTNg5DV4hRZX4wwV8WQPVw7Upmn4AM6BEZ+P/GYmxR6QrkcM9
         VlysM5opr0sAOuvpghWxjesmnZIRjwJ+AXAnsnfwClPIIjHoFyw8wPzZmyTgsSqVTctZ
         slf88WViwL31DKlQApQMblzPQbApJm0SlmMse8zztdTQ71Ng/7oiR10+rTa8ZOMzRoH0
         GGOg==
X-Gm-Message-State: APjAAAVa1P6FPjXT1azqn2G/CEADChtqZlhTUgnapM47sPo3FkMqOV8Y
        DyP9RIwgroeQm6nrOG4H+4E=
X-Google-Smtp-Source: APXvYqy2FtrRHuE+CNGBrq9aJXvXJ3/7f3v9p/nNEZqjCPBDvxssziK4AhXqbgOwAMouEGvzRrKqRg==
X-Received: by 2002:ac8:3243:: with SMTP id y3mr19365927qta.245.1570234884567;
        Fri, 04 Oct 2019 17:21:24 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o28sm3206545qkk.106.2019.10.04.17.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 17:21:23 -0700 (PDT)
Date:   Fri, 4 Oct 2019 20:21:22 -0400
Message-ID: <20191004202122.GD32368@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: Add support for devlink device
 parameters
In-Reply-To: <20191004210934.12813-2-andrew@lunn.ch>
References: <20191004210934.12813-1-andrew@lunn.ch>
 <20191004210934.12813-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Oct 2019 23:09:33 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> Add plumbing to allow DSA drivers to register parameters with devlink.
> 
> To keep with the abstraction, the DSA drivers pass the ds structure to
> these helpers, and the DSA core then translates that to the devlink
> structure associated to the device.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/dsa.h | 23 +++++++++++++++++++++++
>  net/dsa/dsa.c     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
>  net/dsa/dsa2.c    |  7 ++++++-
>  3 files changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 8c3ea0530f65..6623f4428930 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -541,6 +541,29 @@ struct dsa_switch_ops {
>  	 */
>  	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
>  					  struct sk_buff *skb);
> +	/* Devlink parameters */
> +	int	(*devlink_param_get)(struct dsa_switch *ds, u32 id,
> +				     struct devlink_param_gset_ctx *ctx);
> +	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
> +				     struct devlink_param_gset_ctx *ctx);

Unless that is how devlink is designed, shouldn't ctx be const on _set?


Thanks,

	Vivien

> +};
> +
> +#define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> +	DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes,		\
> +			     dsa_dl_param_get,	dsa_dl_param_set, NULL)
> +
> +int dsa_dl_param_get(struct devlink *dl, u32 id,
> +		     struct devlink_param_gset_ctx *ctx);
> +int dsa_dl_param_set(struct devlink *dl, u32 id,
> +		     struct devlink_param_gset_ctx *ctx);
> +int dsa_devlink_params_register(struct dsa_switch *ds,
> +				const struct devlink_param *params,
> +				size_t params_count);
> +void dsa_devlink_params_unregister(struct dsa_switch *ds,
> +				   const struct devlink_param *params,
> +				   size_t params_count);
> +struct dsa_devlink_priv {
> +	struct dsa_switch *ds;
>  };
>  
>  struct dsa_switch_driver {
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 43120a3fb06f..ea7678650d8c 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -329,6 +329,54 @@ int call_dsa_notifiers(unsigned long val, struct net_device *dev,
>  }
>  EXPORT_SYMBOL_GPL(call_dsa_notifiers);
>  
> +int dsa_dl_param_get(struct devlink *dl, u32 id,
> +		     struct devlink_param_gset_ctx *ctx)
> +{
> +	struct dsa_devlink_priv *dl_priv;
> +	struct dsa_switch *ds;
> +
> +	dl_priv = devlink_priv(dl);
> +	ds = dl_priv->ds;
> +
> +	if (!ds->ops->devlink_param_get)
> +		return -EOPNOTSUPP;
> +
> +	return ds->ops->devlink_param_get(ds, id, ctx);
> +}
> +EXPORT_SYMBOL_GPL(dsa_dl_param_get);
> +
> +int dsa_dl_param_set(struct devlink *dl, u32 id,
> +		     struct devlink_param_gset_ctx *ctx)
> +{
> +	struct dsa_devlink_priv *dl_priv;
> +	struct dsa_switch *ds;
> +
> +	dl_priv = devlink_priv(dl);
> +	ds = dl_priv->ds;
> +
> +	if (!ds->ops->devlink_param_set)
> +		return -EOPNOTSUPP;
> +
> +	return ds->ops->devlink_param_set(ds, id, ctx);
> +}
> +EXPORT_SYMBOL_GPL(dsa_dl_param_set);
> +
> +int dsa_devlink_params_register(struct dsa_switch *ds,
> +				const struct devlink_param *params,
> +				size_t params_count)
> +{
> +	return devlink_params_register(ds->devlink, params, params_count);
> +}
> +EXPORT_SYMBOL_GPL(dsa_devlink_params_register);
> +
> +void dsa_devlink_params_unregister(struct dsa_switch *ds,
> +				   const struct devlink_param *params,
> +				   size_t params_count)
> +{
> +	devlink_params_unregister(ds->devlink, params, params_count);
> +}
> +EXPORT_SYMBOL_GPL(dsa_devlink_params_unregister);
> +
>  static int __init dsa_init_module(void)
>  {
>  	int rc;
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 73002022c9d8..d74cc82fb44a 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -367,6 +367,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
>  
>  static int dsa_switch_setup(struct dsa_switch *ds)
>  {
> +	struct dsa_devlink_priv *dl_priv;
>  	int err = 0;
>  
>  	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
> @@ -379,9 +380,11 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	/* Add the switch to devlink before calling setup, so that setup can
>  	 * add dpipe tables
>  	 */
> -	ds->devlink = devlink_alloc(&dsa_devlink_ops, 0);
> +	ds->devlink = devlink_alloc(&dsa_devlink_ops, sizeof(*devlink_priv));
>  	if (!ds->devlink)
>  		return -ENOMEM;
> +	dl_priv = devlink_priv(ds->devlink);
> +	dl_priv->ds = ds;
>  
>  	err = devlink_register(ds->devlink, ds->dev);
>  	if (err)
> @@ -395,6 +398,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	if (err < 0)
>  		goto unregister_notifier;
>  
> +	devlink_params_publish(ds->devlink);
> +
>  	if (!ds->slave_mii_bus && ds->ops->phy_read) {
>  		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
>  		if (!ds->slave_mii_bus) {
> -- 
> 2.23.0
> 
