Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E7F33C428
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234455AbhCOR3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbhCOR2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:28:44 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA9DC06174A;
        Mon, 15 Mar 2021 10:28:44 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v14so13937198pgq.2;
        Mon, 15 Mar 2021 10:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9sfleM35ULczd85WBd8Cx0YnaKVA6iaxILaq9323KiE=;
        b=FpoKABG9verE+9MN+ox4CWsAq3zMKjHgPrAYkg7hoFUpQtxND13KgTPsdiF2ISPum3
         i8ZoQMyakoWWLd0VNM9tN4unXr1WI363uZsBkclibcXqqLtfwR1zkAUnuu/gIN7y8/0O
         1DaLupRKTIL/cZstS1ty6RCBQndsgH3VRAJCLQVPor/nX4/Zcw4ddfJTKykyh486Gu7I
         l/DxP3AZZ21akwoSom3qVQsxJ8HwgSRNIRhtyVO/EIZAZM4lKsOSSgtI6PZ3xUGqy+1q
         EojodbuYimMKbrXOFLQExwq0fUQJ9xHCYc+FILEs9T91/yoVwJHcUeyzO1oWEZSy/Cv6
         GyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9sfleM35ULczd85WBd8Cx0YnaKVA6iaxILaq9323KiE=;
        b=E1sNNkRys0LgOy59W+gO8SU6OL/n0lZoDhb7vxGIB6/6N8OmEGpPkTjhuj34036YIK
         ICUtez72iXTDEnBVJ66C5MK3wOcz2x/gtIPngq8yV/kbnylXwWAHdXTH7b5vnQ92qGAf
         1Om4C2t9991Wd/vcuxtIgNJyWtQJ8JMG7a19gmpddDa35TAuTrYlSiv3Wy/kY59WAUNC
         M8QDZOoL/sKCbyAZvm3eaXkSV5rGL+/R3HpRCYTwO6JZzYV+YO1SHKyMJPwWMJmMLyQ6
         oqF3O5GJXHFho7nn/QM5h0fhmlcnQsWQFBR0TP3KXPWe2RN1czuXW19mAviyCgk4XsNt
         ZC0w==
X-Gm-Message-State: AOAM531ahKH8+Pd2ml7xO6s7jsw+l+bqUP1Bnn2z04HlyMMot9NoExGf
        jtq2ul1Nd68nAXup44Dlk2xkRFImZN0=
X-Google-Smtp-Source: ABdhPJxE2PazYkDQKdNWIaCTqNY0ecVrmw3XGv1/V+KGFYMkmRMhNBQn70kjnMuhsr1FWH5E+YuJig==
X-Received: by 2002:a63:1957:: with SMTP id 23mr198001pgz.196.1615829323926;
        Mon, 15 Mar 2021 10:28:43 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a70sm13841806pfa.202.2021.03.15.10.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:28:43 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_brcm: add support for legacy
 tags
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210315142736.7232-1-noltari@gmail.com>
 <20210315142736.7232-2-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5d32b512-f391-9502-ad5b-10f2fd143b1d@gmail.com>
Date:   Mon, 15 Mar 2021 10:28:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315142736.7232-2-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2021 7:27 AM, Álvaro Fernández Rojas wrote:
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

And you could define UNICAST with (0 << 29) just for documentation purposes.

> +#define BRCM_LEG_TAG_EGRESS	(2 << 29)
> +#define BRCM_LEG_TAG_INGRESS	(3 << 29)
> +} __attribute__((packed));

Please define these as relatives within a byte such that only byte
accesses are done, thus eliminating any endian issues, your code for
instance will work fine on a big-endian machine (like the 63xx you have
tested) but not on a little-endian machine.

Other than that, this looks good, thanks!

> +
> +#define BRCM_LEG_TAG_LEN	sizeof(struct bcm_legacy_tag)
> +
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
> +
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
> +
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
> +static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
> +					struct net_device *dev,
> +					struct packet_type *pt)
> +{
> +	int source_port;
> +	struct bcm_legacy_tag *brcm_tag;
> +
> +	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN)))
> +		return NULL;
> +
> +	brcm_tag = (struct bcm_legacy_tag *) (skb->data - 2);
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
> 

-- 
Florian
