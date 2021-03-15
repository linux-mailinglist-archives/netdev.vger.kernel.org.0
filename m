Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC29A33C868
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhCOV2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhCOV2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:28:25 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4686C06174A;
        Mon, 15 Mar 2021 14:28:24 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w18so19079816edc.0;
        Mon, 15 Mar 2021 14:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oOnSGjeBL3JPl7+bgs5TgOLaTE9jau0iL/CsnAo4j2M=;
        b=C/gUyToor/CgC0Z9phWzJ7VbWBz9tXrSP6MmbLQQ5GbbYvwdck/vKQnbYHhGmQA+w4
         YjupUzeKkc1WtYX8pyp8uLC/7AJzXb57O4zP6yBfaBdVcXS2SX0rd/ZRruGnSQEf9EoX
         rY3N/QbQzbBc4ug+TMw6g3cA0xFx8LvmIlRAhtSSHop+KqQ4XcI9a8DGFsgFQ3C0oFWi
         RDXPWDDE867AWiqZ6nns2B761RuEF0mYIfQyLLs8myNPc27TPG7WV1iLoR+njUmAN3+W
         H7D2opzR+UMfotbHBSToK1Cr9l73P19OxBkvGa8T3pmV8pH6zzzR5WtDO5AsH5cZPukf
         vxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oOnSGjeBL3JPl7+bgs5TgOLaTE9jau0iL/CsnAo4j2M=;
        b=a++7a3wHGdVXJJBJ2b0qwwXqfsxYGR1O7s8zSaoHop9N07o2FEEKSepOAebhQhnmEX
         Vx8PixyMXvibk36cwDghui/TJeeOxPGk75do44hZyeH7bzZlaX8lPaNkiDQzOu8WnF2c
         hlHIVJ/SrbYpHZfWQeR3JDhVCD5neEibxiy1eC8kkXFsdVKjFr35RjCl1/9s8C54JRM2
         8stJl66mlr/cB0LCeJMJ1Yf7kzf7r52pQ7pyxAUTuDLXmoSd2v8VGKznaN6znqQ3vQCq
         kSdrU6ylClpuJXSQgtC0gsypLVsOLLVQp7RJLTmMshFdHsgAoMVWRWhN5qmYWZ1GSMgp
         RzJQ==
X-Gm-Message-State: AOAM531MapE89XH8R5wX7g+itnUYB3wkIvKlHOC51qY6Cklo9IIXBRX7
        eaGcNOZ5P42vbjlODSsQ60I=
X-Google-Smtp-Source: ABdhPJyOn9EYjNtNfb+MmwAZN7y5yA6NOrBpLnXNXbHnoVqpybgV0J1geyjJ+6CVwdPxdZBAmjRpFw==
X-Received: by 2002:a05:6402:3495:: with SMTP id v21mr31982179edc.117.1615843703533;
        Mon, 15 Mar 2021 14:28:23 -0700 (PDT)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id 11sm7951004ejv.101.2021.03.15.14.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:28:23 -0700 (PDT)
Date:   Mon, 15 Mar 2021 23:28:22 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_brcm: add support for legacy
 tags
Message-ID: <20210315212822.dibkci35efm5kgpy@skbuf>
References: <20210315142736.7232-1-noltari@gmail.com>
 <20210315142736.7232-2-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210315142736.7232-2-noltari@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 03:27:35PM +0100, Álvaro Fernández Rojas wrote:
> Add support for legacy Broadcom tags, which are similar to DSA_TAG_PROTO_BRCM.
> These tags are used on BCM5325, BCM5365 and BCM63xx switches.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  include/net/dsa.h  |  2 +
>  net/dsa/Kconfig    |  7 ++++
>  net/dsa/tag_brcm.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 105 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 83a933e563fe..dac303edd33d 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -49,10 +49,12 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_XRS700X_VALUE		19
>  #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
>  #define DSA_TAG_PROTO_SEVILLE_VALUE		21
> +#define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
>  	DSA_TAG_PROTO_BRCM		= DSA_TAG_PROTO_BRCM_VALUE,
> +	DSA_TAG_PROTO_BRCM_LEGACY	= DSA_TAG_PROTO_BRCM_LEGACY_VALUE,

Is there no better qualifier for this tagging protocol name than "legacy"?

>  	DSA_TAG_PROTO_BRCM_PREPEND	= DSA_TAG_PROTO_BRCM_PREPEND_VALUE,
>  	DSA_TAG_PROTO_DSA		= DSA_TAG_PROTO_DSA_VALUE,
>  	DSA_TAG_PROTO_EDSA		= DSA_TAG_PROTO_EDSA_VALUE,
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 58b8fc82cd3c..aaf8a452fd5b 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -48,6 +48,13 @@ config NET_DSA_TAG_BRCM
>  	  Say Y if you want to enable support for tagging frames for the
>  	  Broadcom switches which place the tag after the MAC source address.
>  
> +config NET_DSA_TAG_BRCM_LEGACY
> +	tristate "Tag driver for Broadcom legacy switches using in-frame headers"

Aren't all headers in-frame?

> +	select NET_DSA_TAG_BRCM_COMMON
> +	help
> +	  Say Y if you want to enable support for tagging frames for the
> +	  Broadcom legacy switches which place the tag after the MAC source
> +	  address.
>  
>  config NET_DSA_TAG_BRCM_PREPEND
>  	tristate "Tag driver for Broadcom switches using prepended headers"
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index e2577a7dcbca..9dbff771c9b3 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -9,9 +9,23 @@
>  #include <linux/etherdevice.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
> +#include <linux/types.h>
>  
>  #include "dsa_priv.h"
>  
> +struct bcm_legacy_tag {
> +	uint16_t type;
> +#define BRCM_LEG_TYPE	0x8874
> +
> +	uint32_t tag;
> +#define BRCM_LEG_TAG_PORT_ID	(0xf)
> +#define BRCM_LEG_TAG_MULTICAST	(1 << 29)
> +#define BRCM_LEG_TAG_EGRESS	(2 << 29)
> +#define BRCM_LEG_TAG_INGRESS	(3 << 29)
> +} __attribute__((packed));
> +
> +#define BRCM_LEG_TAG_LEN	sizeof(struct bcm_legacy_tag)
> +

As Florian pointed out, tagging protocol parsing should be
endian-independent, and mapping a struct over the frame header is pretty
much not that.

>  /* This tag length is 4 bytes, older ones were 6 bytes, we do not
>   * handle them
>   */
> @@ -195,6 +209,85 @@ DSA_TAG_DRIVER(brcm_netdev_ops);
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM);
>  #endif
>  
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
> +static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
> +					 struct net_device *dev)
> +{
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct bcm_legacy_tag *brcm_tag;
> +
> +	if (skb_cow_head(skb, BRCM_LEG_TAG_LEN) < 0)
> +		return NULL;

This is not needed since commit 2f0d030c5ffe ("net: dsa: tag_brcm: let
DSA core deal with TX reallocation").

> +	/* The Ethernet switch we are interfaced with needs packets to be at
> +	 * least 64 bytes (including FCS) otherwise they will be discarded when
> +	 * they enter the switch port logic. When Broadcom tags are enabled, we
> +	 * need to make sure that packets are at least 70 bytes
> +	 * (including FCS and tag) because the length verification is done after
> +	 * the Broadcom tag is stripped off the ingress packet.
> +	 *
> +	 * Let dsa_slave_xmit() free the SKB
> +	 */
> +	if (__skb_put_padto(skb, ETH_ZLEN + BRCM_LEG_TAG_LEN, false))
> +		return NULL;

Are you sure the switches you're working on need this, or is it just
another copy-pasta?

> +	skb_push(skb, BRCM_LEG_TAG_LEN);
> +
> +	memmove(skb->data, skb->data + BRCM_LEG_TAG_LEN, 2 * ETH_ALEN);
> +
> +	brcm_tag = (struct bcm_legacy_tag *) (skb->data + 2 * ETH_ALEN);
> +
> +	brcm_tag->type = BRCM_LEG_TYPE;
> +	brcm_tag->tag = BRCM_LEG_TAG_EGRESS;
> +	brcm_tag->tag |= dp->index & BRCM_LEG_TAG_PORT_ID;
> +
> +	return skb;
> +}
> +
> +

Please remove the extra newline.

> +static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
> +					struct net_device *dev,
> +					struct packet_type *pt)
> +{
> +	int source_port;
> +	struct bcm_legacy_tag *brcm_tag;

Please declare the local variables in the order of decreasing line length.

> +
> +	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN)))
> +		return NULL;
> +
> +	brcm_tag = (struct bcm_legacy_tag *) (skb->data - 2);

Nitpick: the space between the *) and the (skb-> is not needed.

> +
> +	source_port = brcm_tag->tag & BRCM_LEG_TAG_PORT_ID;
> +
> +	skb->dev = dsa_master_find_slave(dev, 0, source_port);
> +	if (!skb->dev)
> +		return NULL;
> +
> +	/* Remove Broadcom tag and update checksum */
> +	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
> +
> +	skb->offload_fwd_mark = 1;
> +
> +	/* Move the Ethernet DA and SA */
> +	memmove(skb->data - ETH_HLEN,
> +		skb->data - ETH_HLEN - BRCM_LEG_TAG_LEN,
> +		2 * ETH_ALEN);
> +
> +	return skb;
> +}
> +
> +static const struct dsa_device_ops brcm_legacy_netdev_ops = {
> +	.name	= "brcm-legacy",
> +	.proto	= DSA_TAG_PROTO_BRCM_LEGACY,
> +	.xmit	= brcm_leg_tag_xmit,
> +	.rcv	= brcm_leg_tag_rcv,
> +	.overhead = BRCM_LEG_TAG_LEN,
> +};
> +
> +DSA_TAG_DRIVER(brcm_legacy_netdev_ops);
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_LEGACY);
> +#endif /* CONFIG_NET_DSA_TAG_BRCM_LEGACY */
> +
>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
>  static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
>  					     struct net_device *dev)
> @@ -227,6 +320,9 @@ static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
>  	&DSA_TAG_DRIVER_NAME(brcm_netdev_ops),
>  #endif
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
> +	&DSA_TAG_DRIVER_NAME(brcm_legacy_netdev_ops),
> +#endif
>  #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
>  	&DSA_TAG_DRIVER_NAME(brcm_prepend_netdev_ops),
>  #endif
> -- 
> 2.20.1
> 
