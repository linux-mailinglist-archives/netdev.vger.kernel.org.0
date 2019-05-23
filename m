Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1E12862E
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbfEWS4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:56:52 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45669 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731261AbfEWS4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 14:56:52 -0400
Received: by mail-qk1-f194.google.com with SMTP id j1so4456364qkk.12
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 11:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tpvuJFfMZp6SvK9KDKtENhr68QaXMeztIkCmID+gkbc=;
        b=TpJGQEtdvImqGvhe/eKjEO8QDgPwfoiipVfYsvu8wdLwgtVuQs8kpIoEKSmy0n5AAB
         mmDdZeaG38F886HVHK0E7IZLM15b7j60azRHwJv9MkHjE5Nh2NWaG+wJeuz6JNMsZ0Xv
         642umB9Dyh86aGukWzlCnmdW4YNJ65xUcN/wnwAnt7zF3TZBZBd70jSEXjY6RowpwQea
         F3uOh5s2mo7Q5mTv7secDzKi88+CoKoQEm5gvuwoHDKH3U1sqEFonAVu8tY3/LS8U4fx
         x1Brb8t6+vZ0sxn9c/N8shWB+d1dE7ghsqb8jhpX2ihTcwnJ2iwL1TVB4+OD3Sw4Pq0M
         e3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tpvuJFfMZp6SvK9KDKtENhr68QaXMeztIkCmID+gkbc=;
        b=tS67Nj2BJLxqNa84wwXDG/X3NnyzumQyqZaOFCMhuZGxtslMiLZw5XiaiIw/OtmHsX
         afVi4LGKJhY9GtXlhDoR5QjhQ2YxFqQZYPtFO/gWWeQBJ+UcT0o//a1UWnMK9VuIng3j
         NSo8Aijkz3HSRAh9wcQbDUfQghe15SWs6Kgk407xxW6vFHBxpnqUd4deFEfLuXXmSwlR
         ePBq9J4Z+Btt939ogiYWi4hyw948NgEIRCE+K0h2LTG06quyBVkFeWFqwbGLLrr3NrIi
         IkPzinH/a2DZSajqdT/CfStRSQO6GDA9RxDyz643EfLNglUd6jR2k/uFpcErMP9KKdj1
         OFmA==
X-Gm-Message-State: APjAAAXlkTkbMsmBrJuAIkvOZlXDsqyOHXvQqC0XMowDW4EJFPqWqpN4
        TPczEFDihnqFUBaNG4VARO3/XA==
X-Google-Smtp-Source: APXvYqzkCsMoxGu6ex5VfOPsujiJXvHMJTP9UN3a4hrFq/rsvsUHT12F9+IcJpnaX/OqFYYGhuK/pg==
X-Received: by 2002:a37:de07:: with SMTP id h7mr4343499qkj.41.1558637811222;
        Thu, 23 May 2019 11:56:51 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e133sm127413qkb.76.2019.05.23.11.56.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 11:56:51 -0700 (PDT)
Date:   Thu, 23 May 2019 11:56:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     <netdev@vger.kernel.org>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/1] net: mscc: ocelot: Implement port
 policers via tc command
Message-ID: <20190523115630.7710cc49@cakuba.netronome.com>
In-Reply-To: <20190523104939.2721-2-joergen.andreasen@microchip.com>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
        <20190523104939.2721-1-joergen.andreasen@microchip.com>
        <20190523104939.2721-2-joergen.andreasen@microchip.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 12:49:39 +0200, Joergen Andreasen wrote:
> Hardware offload of matchall classifier and police action are now
> supported via the tc command.
> Supported police parameters are: rate and burst.
> 
> Example:
> 
> Add:
> tc qdisc add dev eth3 handle ffff: ingress
> tc filter add dev eth3 parent ffff: prio 1 handle 2	\
> 	matchall skip_sw				\
> 	action police rate 100Mbit burst 10000
> 
> Show:
> tc -s -d qdisc show dev eth3
> tc -s -d filter show dev eth3 ingress
> 
> Delete:
> tc filter del dev eth3 parent ffff: prio 1
> tc qdisc del dev eth3 handle ffff: ingress
> 
> Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>

> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index d715ef4fc92f..3ec7864d9dc8 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -943,6 +943,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
>  	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
>  	.ndo_set_features		= ocelot_set_features,
>  	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
> +	.ndo_setup_tc			= ocelot_setup_tc,
>  };
>  
>  static void ocelot_get_strings(struct net_device *netdev, u32 sset, u8 *data)
> @@ -1663,8 +1664,9 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
>  	dev->netdev_ops = &ocelot_port_netdev_ops;
>  	dev->ethtool_ops = &ocelot_ethtool_ops;
>  
> -	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS;
> -	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> +	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
> +		NETIF_F_HW_TC;
> +	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
>  
>  	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
>  	dev->dev_addr[ETH_ALEN - 1] += port;

You need to add a check in set_features to make sure nobody clears the
NETIF_F_TC flag while something is offloaded, otherwise you will miss
the REMOVE callback (it will bounce from the
tc_cls_can_offload_and_chain0() check).

> diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
> new file mode 100644
> index 000000000000..2412e0dbc267
> --- /dev/null
> +++ b/drivers/net/ethernet/mscc/ocelot_tc.c
> @@ -0,0 +1,164 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/* Microsemi Ocelot Switch TC driver
> + *
> + * Copyright (c) 2019 Microsemi Corporation
> + */
> +
> +#include "ocelot_tc.h"
> +#include "ocelot_police.h"
> +#include <net/pkt_cls.h>
> +
> +static int ocelot_setup_tc_cls_matchall(struct ocelot_port *port,
> +					struct tc_cls_matchall_offload *f,
> +					bool ingress)
> +{
> +	struct netlink_ext_ack *extack = f->common.extack;
> +	struct ocelot_policer pol = { 0 };
> +	struct flow_action_entry *action;
> +	int err;
> +
> +	netdev_dbg(port->dev, "%s: port %u command %d cookie %lu\n",
> +		   __func__, port->chip_port, f->command, f->cookie);
> +
> +	if (!ingress) {
> +		NL_SET_ERR_MSG_MOD(extack, "Only ingress is supported");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	switch (f->command) {
> +	case TC_CLSMATCHALL_REPLACE:
> +		if (!flow_offload_has_one_action(&f->rule->action)) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Only one action is supported");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		action = &f->rule->action.entries[0];
> +
> +		if (action->id != FLOW_ACTION_POLICE) {
> +			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
> +			return -EOPNOTSUPP;
> +		}

Please also reject the offload if block is shared, as HW policer state
cannot be shared between ports, the way it is in SW.  You have to save
whether the block is shared or not at bind time, see:

d6787147e15d ("net/sched: remove block pointer from common offload structure")

> +		if (port->tc.police_id && port->tc.police_id != f->cookie) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Only one policer per port is supported\n");
> +			return -EEXIST;
> +		}
> +
> +		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
> +		pol.burst = (u32)div_u64(action->police.rate_bytes_ps *
> +					 PSCHED_NS2TICKS(action->police.burst),
> +					 PSCHED_TICKS_PER_SEC);
> +
> +		err = ocelot_port_policer_add(port, &pol);
> +		if (err) {
> +			NL_SET_ERR_MSG_MOD(extack, "Could not add policer\n");
> +			return err;
> +		}
> +
> +		port->tc.police_id = f->cookie;
> +		return 0;
> +	case TC_CLSMATCHALL_DESTROY:
> +		if (port->tc.police_id != f->cookie)
> +			return -ENOENT;
> +
> +		err = ocelot_port_policer_del(port);
> +		if (err) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Could not delete policer\n");
> +			return err;
> +		}
> +		port->tc.police_id = 0;
> +		return 0;
> +	case TC_CLSMATCHALL_STATS: /* fall through */
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
