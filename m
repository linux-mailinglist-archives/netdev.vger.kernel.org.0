Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD475336893
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhCKA00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCKAZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 19:25:53 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFE4C061574;
        Wed, 10 Mar 2021 16:25:53 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id hs11so42567670ejc.1;
        Wed, 10 Mar 2021 16:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0BJbdaQBPi/OJeQ0WQfINatTsFRiGj2MFvpMtrAP1mY=;
        b=rL3M66RI0pkjP818OaQ1Ej1JShNq8NzqDx5TEkcHfHNWabvSnfanSQy0Etly841Q2D
         seKVguCLfOlIkhtbOvLkynS0/sSGTI2EfaojqDjZZZJXhJXBlgCjfW1qMHtj459RJUbN
         L5bXlU9NrW+I2BXcEjtfmpuL8wIWVJDHL/SdGDk+18npNbOjvaPG6b40qbrnZ6L8P//p
         v8B+UdW6kCaWbEO4Dv0Ug0LWs8EjMMNfI+NcKZLYbXcmD13FouD8vm7J8FO0gfbwFjEe
         6TgFCQvXKsoH3U7zeL+WJb09mU/hTtyP0861ANm+waSzuCijiRP5SbVP9du+agTnISRi
         TObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0BJbdaQBPi/OJeQ0WQfINatTsFRiGj2MFvpMtrAP1mY=;
        b=sQ7J5vq9NuZCzUeIijI3iJ5cKvpGiAsrPEtw1GDVWljXYntKK3P265Ufe7orVo5zTX
         3ET6HucuRBoPgX93TCqhIiw3x+Hs3yDd6HS703D6JxniADS57n2ItkKG3ebgo0ZMinZF
         PFvZgPqDxvM3efVKpgv+lA46Fr9rQuTRb1hAEyoVx3Id+g+08tsEJyyEV8Fq0TLtlWWX
         /TrCqEF90niDXBNljb/iqhpvCnddiJfdjFccsgSCqp797M11Nv883MnL4/X94KWMRl7K
         Qb0S9yqNpgfHzX90Z+kf+WBjv1cF49csqSZw9ML4NBZ6WKlDua4uGn/K1E98MVQ/jMWC
         9Iiw==
X-Gm-Message-State: AOAM531wQhkqIIS459ZTMu8xPz4s2atY6rEO5SFICKF9K1r8IChEhOMs
        rH6EXqVUyvGDSxLb8o+Rxg4=
X-Google-Smtp-Source: ABdhPJwSwD7p2IlwNFbX/A2u9wa6QgX2Eu+hl0DJMmh1yIn9YkQKwbaQ/YE4lOSEdBhMAjBWCtKAqA==
X-Received: by 2002:a17:906:1519:: with SMTP id b25mr495212ejd.254.1615422351665;
        Wed, 10 Mar 2021 16:25:51 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id n25sm404248edq.55.2021.03.10.16.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 16:25:51 -0800 (PST)
Date:   Thu, 11 Mar 2021 02:25:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ocelot: Extend MRP
Message-ID: <20210311002549.4ilz4fw2t6sdxxtv@skbuf>
References: <20210310205140.1428791-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310205140.1428791-1-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 09:51:40PM +0100, Horatiu Vultur wrote:
> This patch extends MRP support for Ocelot.  It allows to have multiple
> rings and when the node has the MRC role it forwards MRP Test frames in
> HW. For MRM there is no change.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c     |   6 -
>  drivers/net/ethernet/mscc/ocelot_mrp.c | 229 +++++++++++++++++--------
>  include/soc/mscc/ocelot.h              |  10 +-
>  3 files changed, 158 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 46e5c9136bac..9b79363db17f 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -772,12 +772,6 @@ int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **nskb)
>  
>  	skb->protocol = eth_type_trans(skb, dev);
>  
> -#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> -	if (skb->protocol == cpu_to_be16(ETH_P_MRP) &&
> -	    cpuq & BIT(OCELOT_MRP_CPUQ))
> -		skb->offload_fwd_mark = 0;
> -#endif
> -

I suppose net/dsa/tag_ocelot.c doesn't need it any longer either?

>  	*nskb = skb;
>  
>  	return 0;
> diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
> index 683da320bfd8..86b36e5d2279 100644
> --- a/drivers/net/ethernet/mscc/ocelot_mrp.c
> +++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
> @@ -1,8 +1,5 @@
>  // SPDX-License-Identifier: (GPL-2.0 OR MIT)
>  /* Microsemi Ocelot Switch driver
> - *
> - * This contains glue logic between the switchdev driver operations and the
> - * mscc_ocelot_switch_lib.
>   *
>   * Copyright (c) 2017, 2019 Microsemi Corporation
>   * Copyright 2020-2021 NXP Semiconductors
> @@ -15,13 +12,33 @@
>  #include "ocelot.h"
>  #include "ocelot_vcap.h"
>  
> -static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
> +static const u8 mrp_test_dmac[] = {0x01, 0x15, 0x4e, 0x00, 0x00, 0x01 };
> +static const u8 mrp_control_dmac[] = {0x01, 0x15, 0x4e, 0x00, 0x00, 0x02 };
> +
> +static int ocelot_mrp_find_port(struct ocelot *ocelot, struct ocelot_port *p)

Could this be named:
struct ocelot_port *ocelot_find_mrp_partner_port(struct ocelot_port *ocelot_port)

and return NULL instead of zero on "not found"? Zero is a perfectly
valid port number, definitely not what you want.

> +{
> +	int i;
> +
> +	for (i = 0; i < ocelot->num_phys_ports; ++i) {
> +		struct ocelot_port *ocelot_port = ocelot->ports[i];
> +
> +		if (!ocelot_port || p == ocelot_port)
> +			continue;
> +
> +		if (ocelot_port->mrp_ring_id == p->mrp_ring_id)
> +			return i;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int id)
>  {
>  	struct ocelot_vcap_block *block_vcap_is2;
>  	struct ocelot_vcap_filter *filter;
>  
>  	block_vcap_is2 = &ocelot->block[VCAP_IS2];
> -	filter = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, port,
> +	filter = ocelot_vcap_block_find_filter_by_id(block_vcap_is2, id,
>  						     false);
>  	if (!filter)
>  		return 0;
> @@ -29,6 +46,87 @@ static int ocelot_mrp_del_vcap(struct ocelot *ocelot, int port)
>  	return ocelot_vcap_filter_del(ocelot, filter);
>  }
>  
> +static int ocelot_mrp_redirect_add_vcap(struct ocelot *ocelot, int src_port,
> +					int dst_port)
> +{
> +	const u8 mrp_test_mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff };

OCD, but could you add a space between the opening bracket and the first
0xff? There's one more place where that should be done.

> +	struct ocelot_vcap_filter *filter;
> +	int err;
> +
> +	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
> +	if (!filter)
> +		return -ENOMEM;

Why atomic? Isn't SWITCHDEV_OBJ_ID_RING_ROLE_MRP put on the blocking
notifier call chain?

> +
> +	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
> +	filter->prio = 1;
> +	filter->id.cookie = src_port;
> +	filter->id.tc_offload = false;
> +	filter->block_id = VCAP_IS2;
> +	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
> +	filter->ingress_port_mask = BIT(src_port);
> +	ether_addr_copy(filter->key.etype.dmac.value, mrp_test_dmac);
> +	ether_addr_copy(filter->key.etype.dmac.mask, mrp_test_mask);
> +	filter->action.mask_mode = OCELOT_MASK_MODE_REDIRECT;
> +	filter->action.port_mask = BIT(dst_port);
> +
> +	err = ocelot_vcap_filter_add(ocelot, filter, NULL);
> +	if (err)
> +		kfree(filter);
> +
> +	return err;
> +}
> +
> +static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port,
> +				    int prio, int cookie)

"cookie" should be unsigned long I think?

> +{
> +	const u8 mrp_mask[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0x00 };
> +	struct ocelot_vcap_filter *filter;
> +	int err;
> +
> +	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
> +	if (!filter)
> +		return -ENOMEM;
> +
> +	filter->key_type = OCELOT_VCAP_KEY_ETYPE;
> +	filter->prio = prio;
> +	filter->id.cookie = cookie;
> +	filter->id.tc_offload = false;
> +	filter->block_id = VCAP_IS2;
> +	filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
> +	filter->ingress_port_mask = BIT(port);
> +	/* Here is possible to use control or test dmac because the mask
> +	 * doesn't cover the LSB
> +	 */
> +	ether_addr_copy(filter->key.etype.dmac.value, mrp_test_dmac);
> +	ether_addr_copy(filter->key.etype.dmac.mask, mrp_mask);
> +	filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
> +	filter->action.port_mask = 0x0;
> +	filter->action.cpu_copy_ena = true;
> +	filter->action.cpu_qu_num = OCELOT_MRP_CPUQ;
> +
> +	err = ocelot_vcap_filter_add(ocelot, filter, NULL);
> +	if (err)
> +		kfree(filter);
> +
> +	return err;
> +}
> +
> +static void ocelot_mrp_save_mac(struct ocelot *ocelot,
> +				struct ocelot_port *port)
> +{
> +	ocelot_mact_learn(ocelot, PGID_MRP, mrp_test_dmac,
> +			  port->pvid_vlan.vid, ENTRYTYPE_LOCKED);
> +	ocelot_mact_learn(ocelot, PGID_MRP, mrp_control_dmac,
> +			  port->pvid_vlan.vid, ENTRYTYPE_LOCKED);

Let me make sure I understand.
By learning these multicast addresses, you mark them as 'not unknown' in
the MAC table, because otherwise they will be flooded, including to the
CPU port module, and there's no way you can remove the CPU from the
flood mask, even if the packets get later redirected through VCAP IS2?
I mean that's the reason why we have the policer on the CPU port for the
drop action in ocelot_vcap_init, no?

> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 425ff29d9389..c41696d2e82b 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -51,6 +51,7 @@
>   */
>  
>  /* Reserve some destination PGIDs at the end of the range:
> + * PGID_MRP: used for not flooding MRP frames to CPU

Could this be named PGID_BLACKHOLE or something? It isn't specific to
MRP if I understand correctly. We should also probably initialize it
with zero.

>   * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
>   *           of the switch port net devices, towards the CPU port module.
>   * PGID_UC: the flooding destinations for unknown unicast traffic.
> @@ -59,6 +60,7 @@
>   * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
>   * PGID_BC: the flooding destinations for broadcast traffic.
>   */
> +#define PGID_MRP			57
>  #define PGID_CPU			58
>  #define PGID_UC				59
>  #define PGID_MC				60
> @@ -611,6 +613,8 @@ struct ocelot_port {
>  
>  	struct net_device		*bond;
>  	bool				lag_tx_active;
> +
> +	u16				mrp_ring_id;
>  };
>  
>  struct ocelot {
> @@ -679,12 +683,6 @@ struct ocelot {
>  	/* Protects the PTP clock */
>  	spinlock_t			ptp_clock_lock;
>  	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
> -
> -#if IS_ENABLED(CONFIG_BRIDGE_MRP)
> -	u16				mrp_ring_id;
> -	struct net_device		*mrp_p_port;
> -	struct net_device		*mrp_s_port;
> -#endif
>  };
>  
>  struct ocelot_policer {
> -- 
> 2.30.1
> 
