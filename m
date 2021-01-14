Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A252F55B8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbhANBJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbhANBGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 20:06:12 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1AEC06179F;
        Wed, 13 Jan 2021 17:05:22 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id e18so5767575ejt.12;
        Wed, 13 Jan 2021 17:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ALcfKJBsmbqqdDqRB4st0llIoEoKfCPT10X6T0zbwkU=;
        b=Pj3aCnTaWbkb53KhA2cV4tY8Fgxju7zHO9hGw1mdBF89UwcVYpKDkkQdeNqTOF/rn7
         ml81BIDwoNkINK3icM/SP3XPRk5Aqbkjl5Vi7ogszqAIzIQit4mYmFzP+5KytL4SWwUW
         R+0yeKE+HqEQIJCG+EnvFyfMhDoskmn1MiTDEkh9AswBTmx5kV6PLhFJj5L6QIbUJd3p
         BKyE5qD92oEtu+xhs+qYfZwvitIIzCOMa7vxFsfft5IiV+qqssvVu9EEPZ5tX46ZtUvC
         uDzr8QWMqIMq+KbWnmefEZPAMw4MzRKdNjz9uo115SK79dkozfxKHigfC6rst6AL8srV
         PzeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ALcfKJBsmbqqdDqRB4st0llIoEoKfCPT10X6T0zbwkU=;
        b=bLUE9vk636ZJI9vZYvew1rIkfiVESXm/4aGL6MrBlY8OhnyPnDABDRDW5I1K7bHhq5
         Wj4tnNTco17DieZhi7KYrrvtLEgkEOouwNPlCAfRKnckEHbbeZj2kflCHmXVcYJCNMMy
         GAJ4S93kvW5uiGvRBaaFbJ+bnbYtx5al9sMxjTxg1TMZ+UJ1njSqD3/LaJnDLpsWA6dK
         +/d/unTbVkMsBI1j47yGLZwalr5RS/Nm6ivZIOyb2jMU/a+NvLkjTNRJ2JL/sEhx5OaT
         +VIvdsXkmhHTE/CQa+5u93iyjzPUPJBTnsXsfXsEEUiijAKq8vtIV5VmHU7lv8cUJqnb
         4szQ==
X-Gm-Message-State: AOAM530txiAXLV9u1fd/FWJ1HgBkbjJVkpjWZ75o3/58LfE8E/728Rxo
        NONnTAdykiwsUgUPzTG8w0g=
X-Google-Smtp-Source: ABdhPJyYOVMn/DEqhlWYi/YpW3YVztwJFTPD4leH4hUZdvnj8anDgZZAco+WEranBa2+QOwO/S20Jw==
X-Received: by 2002:a17:906:4e46:: with SMTP id g6mr3316344ejw.243.1610586321512;
        Wed, 13 Jan 2021 17:05:21 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x5sm558448edi.35.2021.01.13.17.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 17:05:20 -0800 (PST)
Date:   Thu, 14 Jan 2021 03:05:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] dsa: add support for Arrow XRS700x tag
 trailer
Message-ID: <20210114010519.td6q2pzy4mg6viuh@skbuf>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-2-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113145922.92848-2-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 08:59:20AM -0600, George McCollister wrote:
> Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
> is modeled on tag_trailer.c which works in a similar way.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

A few comments below.

> diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
> new file mode 100644
> index 000000000000..4ee7c260a8a9
> --- /dev/null
> +++ b/net/dsa/tag_xrs700x.c
> @@ -0,0 +1,67 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * XRS700x tag format handling
> + * Copyright (c) 2008-2009 Marvell Semiconductor

Why does Marvell get copyright?

> + * Copyright (c) 2020 NovaTech LLC
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>

These 3 includes are not needed. You can probably remove them later
though, if there is no other reason to resend.

> +#include <linux/bitops.h>
> +
> +#include "dsa_priv.h"
> +
> +static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	u8 *trailer;
> +
> +	trailer = skb_put(skb, 1);
> +	trailer[0] = BIT(dp->index);
> +
> +	return skb;
> +}
> +
> +static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
> +				   struct packet_type *pt)
> +{
> +	int source_port;
> +	u8 *trailer;
> +
> +	if (skb_linearize(skb))
> +		return NULL;

We've been through this, there should be no reason to linearize an skb
for a one-byte tail tag..

> +
> +	trailer = skb_tail_pointer(skb) - 1;
> +
> +	source_port = ffs((int)trailer[0]) - 1;
> +
> +	if (source_port < 0)
> +		return NULL;
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, source_port);
> +	if (!skb->dev)
> +		return NULL;
> +
> +	if (pskb_trim_rcsum(skb, skb->len - 1))
> +		return NULL;
> +
> +	/* Frame is forwarded by hardware, don't forward in software. */
> +	skb->offload_fwd_mark = 1;
> +
> +	return skb;
> +}
