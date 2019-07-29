Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756327937B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfG2S7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:59:18 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:39228 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfG2S7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 14:59:17 -0400
Received: by mail-ua1-f67.google.com with SMTP id j8so24409757uan.6
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 11:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AWZOzWNgzcatcBqh2ZMbPE7eLWZd31lPTz7bOJ65UQ8=;
        b=BE1aXWX1W+WfcPkG4aHuFO59cqji1MJZiTRy+2u04+rPvWNxBKELsvut5AmXI1C1N5
         CvTBka/3Etgdo0XJx2hbaUc8TvobUTteicM3YyShKYBjaHEE5OM+tk5yjBdyRUhTn998
         7k22qx5fxQ1tuE/OEZt0vZTJQ/wMwdYjOE4SvkLP7vf6tdkpTNqNEkhTrdayoW3jrLu4
         9icQJs+lmsCpWq1QNlb9FVrNRTvyoT9quPnquBJfOlmgWkm+PaLG0yd3LNq1jOYZZygn
         S4XfSN2cU1+iQBW/8ironA6T+A4FW7iyhjJrPBY5H5Bl5TFBLgDMtD4OAV3m9/XNl3Wu
         7RCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AWZOzWNgzcatcBqh2ZMbPE7eLWZd31lPTz7bOJ65UQ8=;
        b=fslO65G1dk9gTPojAk5XPYsCZ82IVCJpMqkakzuqcREk/6p8BfOz2FptoHaUiIXSa8
         b47K7XrYFDNm0CEV4KOf6J9r0Ef1aKzR4wpG7EdJTbru4eRpL8dhBb85/9AxY5KSiPPb
         cLtXk7PBFOlHbc6qevO3d5FDPFhHmtIoHXcxpRmVxZa27Z0uekqzraMblPQznGUEw3/K
         4RIXFMzWJ7AuUsmri4A8S7UrY7YVbeUjx5CcIepaZUXL0+D7+/NFobBlDh9W8nkupyC/
         STOeaF8eCR3MlxYa+JJjnW4szjNBLAig7nO9ucoTE7OW8Utkk4CVJIFAm76VsSbsqLC5
         ILsg==
X-Gm-Message-State: APjAAAWHBE3DKDAOg0ueh/V+mUV0Z3hi1qF+HLMqqZ6/y8O4guZKxxhu
        SXJp6UJfy//aNvRJ27uZPyVQoQ==
X-Google-Smtp-Source: APXvYqwAcPuxjgS1SNnzmCPWEgsgxEBF8t3m/zz0NXnP7IUFjrQNqGJ1+hVbXVLn4ZqI3FMqkogg6Q==
X-Received: by 2002:ab0:7c3:: with SMTP id d3mr24509884uaf.131.1564426756805;
        Mon, 29 Jul 2019 11:59:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c12sm8886297uao.8.2019.07.29.11.59.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 11:59:16 -0700 (PDT)
Date:   Mon, 29 Jul 2019 11:59:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 3/3] netdevsim: create devlink and netdev
 instances in namespace
Message-ID: <20190729115906.6bc2176d@cakuba.netronome.com>
In-Reply-To: <20190727094459.26345-4-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us>
        <20190727094459.26345-4-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Jul 2019 11:44:59 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> When user does create new netdevsim instance using sysfs bus file,
> create the devlink instance and related netdev instance in the namespace
> of the caller.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

> diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> index 1a0ff3d7747b..6aeed0c600f8 100644
> --- a/drivers/net/netdevsim/bus.c
> +++ b/drivers/net/netdevsim/bus.c
> @@ -283,6 +283,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
>  	nsim_bus_dev->dev.bus = &nsim_bus;
>  	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
>  	nsim_bus_dev->port_count = port_count;
> +	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
>  
>  	err = device_register(&nsim_bus_dev->dev);
>  	if (err)

The saved initial_net is only to carry the net info from the adding
process to the probe callback, because probe can be asynchronous?
I'm not entirely sure netdevsim can probe asynchronously in practice
given we never return EPROBE_DEFER, but would you mind at least adding
a comment stating that next to the definition of the field, otherwise 
I worry someone may mistakenly use this field instead of the up-to-date
devlink's netns.

> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 79c05af2a7c0..cdf53d0e0c49 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -19,6 +19,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/u64_stats_sync.h>
>  #include <net/devlink.h>
> +#include <net/net_namespace.h>

You can just do a forward declaration, no need to pull in the header.

>  #include <net/xdp.h>
>  
>  #define DRV_NAME	"netdevsim"

> @@ -213,6 +215,7 @@ struct nsim_bus_dev {
>  	struct device dev;
>  	struct list_head list;
>  	unsigned int port_count;
> +	struct net *initial_net;
>  	unsigned int num_vfs;
>  	struct nsim_vf_config *vfconfigs;
>  };

Otherwise makes perfect sense, with the above nits addressed feel free
to add:

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
