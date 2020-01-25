Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF01496BB
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgAYQzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:55:04 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33018 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgAYQzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 11:55:04 -0500
Received: by mail-pg1-f195.google.com with SMTP id 6so2851496pgk.0;
        Sat, 25 Jan 2020 08:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YMHwBcH6nuvLnfrWjqBHincYqyaNNsKLBvmm2bnAeTE=;
        b=d0MlTgoR6Um3+HbKbo3LWNtnPpOADnlHi+qgXKNMVMl8SpeVEsRmnmlV6HR3G5Wg8V
         6I/2WBvz6emZOMaU8NqSHV4W0H1o+TbmLqfYx5G2cSZzGRUpyiNNVWAL6T9raAyigjgA
         uiAVaq4rWH4DTsmR4HpJJ/RVbC3MASJDBOTr2AfGhDWLvhV1bCZA4azeDNAXMCxAJN14
         +BAomKxJ0xVUVQABkF/cz6C5FAuFeJUVz64bIxK4JvtX47kzI9k5RAzeqF+tiWAuDB8W
         uYaf3DGN7OoAHYEVBy3hTzSNxTn+//awGXAxlfJNknXAIrfftoKPPoIqKAnnbYWYexj9
         mBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=YMHwBcH6nuvLnfrWjqBHincYqyaNNsKLBvmm2bnAeTE=;
        b=EV08J9qyKcX/O8kGnRFuEpxNKh6FYNRkE9Wb4C+u9bSF/UAS2wz24JB66P3p1tQaYv
         PDxQVG+80mh0y6igujHnxIz8nHiNOHNqxwsNQmlyJRAPXa+Vvov5bT4duFpBnSJ4tObK
         LaRQrVa7VABMsl40Sel7Z+eVV5poSupxXUthpjEzISF3E7zLF8kWiV1wwUmenrBVfnrx
         +wjTI4t9iWZHKEI2xsGaE0omAU9910VCjYy4NNGkzESPmgtreNkKWxt2tjexV8t/lIyv
         WjPsTyR2T5gaQcuFQoCidyzO0uVKCh9TcSTEmecjtrqqi95b0TUwdQlECLDN1E3+K7XT
         5Juw==
X-Gm-Message-State: APjAAAVT0RyOG37/mFeWDEMIkx1ISSk2IZvONBNMS4KJY0Yfihyznf5v
        K7VcKEJ0P9qrsx/8/pTeyKH9iQ9t
X-Google-Smtp-Source: APXvYqza4HdD3nyZme78qxA0yEw91gAJ3/H9g8vQtn4Jq2Hacx32W2jghU3Vtd84m51WYuHOkeQADg==
X-Received: by 2002:a65:42ca:: with SMTP id l10mr10667827pgp.121.1579971302961;
        Sat, 25 Jan 2020 08:55:02 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u11sm10226985pjn.2.2020.01.25.08.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 08:55:02 -0800 (PST)
Subject: Re: [PATCH net-next v1] net/core: Replace driver version to be kernel
 version
To:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200125161401.40683-1-leon@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <b0f73391-d7f5-1efe-2927-bed02668f8c5@gmail.com>
Date:   Sat, 25 Jan 2020 08:55:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200125161401.40683-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2020 8:14 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> In order to stop useless driver version bumps and unify output
> presented by ethtool -i, let's overwrite the version string.
> 
> Before this change:
> [leonro@erver ~]$ ethtool -i eth0
> driver: virtio_net
> version: 1.0.0
> After this change:
> [leonro@server ~]$ ethtool -i eth0
> driver: virtio_net
> version: 5.5.0-rc6+
> 
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>> ---
>  Changelog:
>  v1: Resend per-Dave's request
>      https://lore.kernel.org/linux-rdma/20200125.101311.1924780619716720495.davem@davemloft.net
>      No changes at all and applied cleanly on top of "3333e50b64fe Merge branch 'mlxsw-Offload-TBF'"
>  v0: https://lore.kernel.org/linux-rdma/20200123130541.30473-1-leon@kernel.org

There does not appear to be any explanation why we think this is a good
idea for *all* drivers, and not just the ones that are purely virtual?

Are you not concerned that this is ABI and that specific userland may be
relying on a specific info format and we could now be breaking their
version checks? I do not disagree that the version is not particularly
useful for in-tree kernel, but this is ABI, and breaking user-space is
usually a source of support questions.

> ---
>  net/ethtool/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 182bffbffa78..a403decacb6d 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -17,6 +17,7 @@
>  #include <linux/phy.h>
>  #include <linux/bitops.h>
>  #include <linux/uaccess.h>
> +#include <linux/vermagic.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sfp.h>
>  #include <linux/slab.h>
> @@ -666,6 +667,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
>  		return -EOPNOTSUPP;
>  	}
> 
> +	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
> +
>  	/*
>  	 * this method of obtaining string set info is deprecated;
>  	 * Use ETHTOOL_GSSET_INFO instead.
> --
> 2.24.1
> 

-- 
Florian
