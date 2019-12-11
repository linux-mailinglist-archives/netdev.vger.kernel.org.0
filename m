Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB36311BAD9
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbfLKR67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:58:59 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40913 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730732AbfLKR67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:58:59 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so1713601plp.7
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fnQZ6DdNVSEWpASJUM58jRJ6TOQ5i42xZasIMHEHPYM=;
        b=XPzp4vSs8NETuTWIrgzZ3gSPdPyGB8U2LV/TCFXibgT8P6Drkc32ZPxrQIOW2VwXI3
         l7OrvnoA10ArdcGlCO5/hWfaAGYRgIqceVti2vdD43GFpd0lwAd/gkajkUiRCckIot5y
         sgXqdpk/G/g8ifGiP/eCSKDSzprnapPJiYdnDrdN9XTK0j6EAsvYoKhSKpR06qF1Uug3
         S8m9ya3uTP5ESoOqB6qwQHl2zxR1qv48MPgchsj2uGLCebU5aBvktLYn4QNEPow3Hri+
         ka5UXNi4tZh7px5SjRrs2RqaK0JY3md6MdsG2iOKBkKSh2dWiZaAoD5cWpI496/sIc+i
         q07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fnQZ6DdNVSEWpASJUM58jRJ6TOQ5i42xZasIMHEHPYM=;
        b=FO4AGPpETc3/Y4egGdZyaCCC6hQ90O0ZB2yR0MW7ZcFGpE96E2On+onyzkWCdZgQQ6
         qqv0gG9SPvGS4VX8S9NuA3WC1gAMzxpW/IoKB043fAeVCa3RJoCDHZ1ndbWlhoohOUlG
         U+DwazxQP9/idGMb0kuXUzIoZwdB7SPjnkq3rDAb7Qv1+j/dY/3ctCDAsqr5cSZOJAj6
         AIn1g7biSf7Im330isVHnicC6iu0rQG6/llD7cK4ZItQAjkSSfYGJkaV6cZNIAz00Nqg
         awqLA5o+4pT5oSNDGIdLO8NZLWdqst0kz+rEawVtUq38PB7d9Oj9OBd56azVi+4/MMyv
         V8jg==
X-Gm-Message-State: APjAAAW6id6l2R+dnaq+BnIGWDW4Mjg6KI7+1Gsoe9MWy/TvBZBWrfad
        otdorWsH939E1m6DIUlQI20kZw==
X-Google-Smtp-Source: APXvYqzLhbjoMtZtLicbTyBB3F6G9WKNvXvn3/8W7xEmT+mWSzXRcXgr0tHgZGXc2OxlJBm8p9qUaw==
X-Received: by 2002:a17:90a:a48a:: with SMTP id z10mr4895586pjp.52.1576087138799;
        Wed, 11 Dec 2019 09:58:58 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id gc1sm3095429pjb.20.2019.12.11.09.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 09:58:58 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:58:54 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     jiri@mellanox.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191211095854.6cd860f1@cakuba.netronome.com>
In-Reply-To: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:
> Currently there is no limit to the number of VFs netdevsim can enable.
> In a real systems this value exist and used by driver.
> Fore example, Some features might need to consider this value when
> allocating memory.

Thanks for the patch!

Can you shed a little bit more light on where it pops up? Just for my
curiosity?

> Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

> diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> index 6aeed0c600f8..f1a0171080cb 100644
> --- a/drivers/net/netdevsim/bus.c
> +++ b/drivers/net/netdevsim/bus.c
> @@ -26,9 +26,9 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
>  static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
>  				   unsigned int num_vfs)
>  {
> -	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
> -					  sizeof(struct nsim_vf_config),
> -					  GFP_KERNEL);

You're changing the semantics of the enable/disable as well now.
The old values used to be wiped when SR-IOV is disabled, now they
will be retained across disable/enable pair.

I think it'd be better if that wasn't the case. Users may expect a
system to be in the same state after they enable SR-IOV, regardless if
someone else used SR-IOV since last reboot.

Could you add a memset(,0,) here?

> +	if (nsim_bus_dev->max_vfs < num_vfs)
> +		return -ENOMEM;
> +
>  	if (!nsim_bus_dev->vfconfigs)
>  		return -ENOMEM;

This check seems useless now, no? We will always have vfconfigs

>  	nsim_bus_dev->num_vfs = num_vfs;
> @@ -38,8 +38,6 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
>  
>  static void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
>  {
> -	kfree(nsim_bus_dev->vfconfigs);
> -	nsim_bus_dev->vfconfigs = NULL;
>  	nsim_bus_dev->num_vfs = 0;
>  }
>  
> @@ -154,22 +152,29 @@ static struct device_type nsim_bus_dev_type = {
>  };
>  
>  static struct nsim_bus_dev *
> -nsim_bus_dev_new(unsigned int id, unsigned int port_count);
> +nsim_bus_dev_new(unsigned int id, unsigned int port_count,
> +		 unsigned int max_vfs);
> +
> +#define NSIM_BUS_DEV_MAX_VFS 4
>  
>  static ssize_t
>  new_device_store(struct bus_type *bus, const char *buf, size_t count)
>  {
>  	struct nsim_bus_dev *nsim_bus_dev;
>  	unsigned int port_count;
> +	unsigned int max_vfs;
>  	unsigned int id;
>  	int err;
>  
> -	err = sscanf(buf, "%u %u", &id, &port_count);
> +	err = sscanf(buf, "%u %u %u", &id, &port_count, &max_vfs);
>  	switch (err) {
>  	case 1:
>  		port_count = 1;
>  		/* fall through */
>  	case 2:
> +		max_vfs = NSIM_BUS_DEV_MAX_VFS;
> +		/* fall through */
> +	case 3:
>  		if (id > INT_MAX) {
>  			pr_err("Value of \"id\" is too big.\n");
>  			return -EINVAL;

Is 0 VFs okay? will kcalloc(0, size, flags) behave correctly?

> @@ -179,7 +184,7 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
>  		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
>  		return -EINVAL;
>  	}
> -	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
> +	nsim_bus_dev = nsim_bus_dev_new(id, port_count, max_vfs);
>  	if (IS_ERR(nsim_bus_dev))
>  		return PTR_ERR(nsim_bus_dev);
>  
> @@ -267,7 +272,8 @@ static struct bus_type nsim_bus = {
>  };
>  
>  static struct nsim_bus_dev *
> -nsim_bus_dev_new(unsigned int id, unsigned int port_count)
> +nsim_bus_dev_new(unsigned int id, unsigned int port_count,
> +		 unsigned int max_vfs)
>  {
>  	struct nsim_bus_dev *nsim_bus_dev;
>  	int err;
> @@ -284,12 +290,24 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
>  	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
>  	nsim_bus_dev->port_count = port_count;
>  	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
> +	nsim_bus_dev->max_vfs = max_vfs;
> +
> +	nsim_bus_dev->vfconfigs = kcalloc(nsim_bus_dev->max_vfs,
> +					  sizeof(struct nsim_vf_config),
> +					  GFP_KERNEL);
> +	if (!nsim_bus_dev->vfconfigs) {
> +		err = -ENOMEM;
> +		goto err_nsim_bus_dev_id_free;
> +	}
>  
>  	err = device_register(&nsim_bus_dev->dev);
>  	if (err)
> -		goto err_nsim_bus_dev_id_free;
> +		goto err_nsim_vfconfigs_free;
> +
>  	return nsim_bus_dev;
>  
> +err_nsim_vfconfigs_free:
> +	kfree(nsim_bus_dev->vfconfigs);
>  err_nsim_bus_dev_id_free:
>  	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
>  err_nsim_bus_dev_free:
> @@ -301,6 +319,7 @@ static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
>  {
>  	device_unregister(&nsim_bus_dev->dev);
>  	ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
> +	kfree(nsim_bus_dev->vfconfigs);
>  	kfree(nsim_bus_dev);
>  }
>  
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 94df795ef4d3..e2049856add8 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -238,6 +238,7 @@ struct nsim_bus_dev {
>  	struct net *initial_net; /* Purpose of this is to carry net pointer
>  				  * during the probe time only.
>  				  */
> +	unsigned int max_vfs;
>  	unsigned int num_vfs;
>  	struct nsim_vf_config *vfconfigs;
>  };

