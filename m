Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B591DFF59
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 16:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgEXO0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 10:26:16 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:55887 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727985AbgEXO0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 10:26:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 95AC0580BA2;
        Sun, 24 May 2020 10:26:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 May 2020 10:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R4SDD+
        bjUa/gZ0O8DbQdH4slS00ZDkpPJDiIVO8ZjHQ=; b=c62Q2H4jCtciuEZvOJdnnD
        Hty/+7QIH0AlblSJlwa6AMuytNAhlW+bUv2GlPcb0QN6a0jK+XN55RMAOTP19jYm
        3ejIsGmhmoBZLDziVZZvSfuWoNUd7/znGvJTQbyPEHbKDYrPzm6uA+3jaB3TcMTs
        /Fsz+KcIv7jysvyVcAwg/wksUWxSB7p/U5w3D/z0LcYlETjR91fPOdjYRixCDIh5
        AY+aT+mOf5rcTNGfBZMpKe3o4eC0U5Glh6ijUW8xkHY9ZCNSbe/aqbrDeqSy1Mw1
        dMPE9iT6G6mGquGWvFOrl/rwc8AHlE3v1d8Dc+qlXXUp+UI1FlKQ78W4Jo/1JUYQ
        ==
X-ME-Sender: <xms:A4TKXj7ndh8NJlXsTp3GAAk_dsfd7OoMbDj99yHg8_SkT17YbFUKuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddukedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:A4TKXo5FgHJO4jGCDG2_0UYddO5Ro9IqmHPL65tKC2ZS2WYshySwOw>
    <xmx:A4TKXqeJYzk0qs4YCMh_p0mFphcLFXIKU-ed3KUWdi562qPiqS4k0w>
    <xmx:A4TKXkIS5dnAiZc8RCY-ZWCQhNwlaygLQrfKxc1qCZENqV5fLmC_Dw>
    <xmx:B4TKXu8ptJAOCv0ygMyfS_tO_gMsIxTsxYgLSDRBD8ojdlvWKIlzow>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 84930328005A;
        Sun, 24 May 2020 10:26:11 -0400 (EDT)
Date:   Sun, 24 May 2020 17:26:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: Re: [PATCH RFC net-next 10/13] net: bridge: add port flags for host
 flooding
Message-ID: <20200524142609.GB1281067@splinter>
References: <20200521211036.668624-1-olteanv@gmail.com>
 <20200521211036.668624-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521211036.668624-11-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 12:10:33AM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In cases where the bridge is offloaded by a switchdev, there are
> situations where we can optimize RX filtering towards the host. To be
> precise, the host only needs to do termination, which it can do by
> responding at the MAC addresses of the slave ports and of the bridge
> interface itself. But most notably, it doesn't need to do forwarding,
> so there is no need to see packets with unknown destination address.
> 
> But there are, however, cases when a switchdev does need to flood to the
> CPU. Such an example is when the switchdev is bridged with a foreign
> interface, and since there is no offloaded datapath, packets need to
> pass through the CPU. Currently this is the only identified case, but it
> can be extended at any time.
> 
> So far, switchdev implementers made driver-level assumptions, such as:
> this chip is never integrated in SoCs where it can be bridged with a
> foreign interface, so I'll just disable host flooding and save some CPU
> cycles. Or: I can never know what else can be bridged with this
> switchdev port, so I must leave host flooding enabled in any case.
> 
> Let the bridge drive the host flooding decision, and pass it to
> switchdev via the same mechanism as the external flooding flags.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h |  3 +++
>  net/bridge/br_if.c        | 40 +++++++++++++++++++++++++++++++++++++++
>  net/bridge/br_switchdev.c |  4 +++-
>  3 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index b3a8d3054af0..6891a432862d 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -49,6 +49,9 @@ struct br_ip_list {
>  #define BR_ISOLATED		BIT(16)
>  #define BR_MRP_AWARE		BIT(17)
>  #define BR_MRP_LOST_CONT	BIT(18)
> +#define BR_HOST_FLOOD		BIT(19)
> +#define BR_HOST_MCAST_FLOOD	BIT(20)
> +#define BR_HOST_BCAST_FLOOD	BIT(21)
>  
>  #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
>  
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index a0e9a7937412..aae59d1e619b 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -166,6 +166,45 @@ void br_manage_promisc(struct net_bridge *br)
>  	}
>  }
>  
> +static int br_manage_host_flood(struct net_bridge *br)
> +{
> +	const unsigned long mask = BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD |
> +				   BR_HOST_BCAST_FLOOD;
> +	struct net_bridge_port *p, *q;
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		unsigned long flags = p->flags;
> +		bool sw_bridging = false;
> +		int err;
> +
> +		list_for_each_entry(q, &br->port_list, list) {
> +			if (p == q)
> +				continue;
> +
> +			if (!netdev_port_same_parent_id(p->dev, q->dev)) {
> +				sw_bridging = true;

It's not that simple. There are cases where not all bridge slaves have
the same parent ID and still there is no reason to flood traffic to the
CPU. VXLAN, for example.

You could argue that the VXLAN device needs to have the same parent ID
as the physical netdevs member in the bridge, but it will break your
data path. For example, lets assume your hardware decided to flood a
packet in L2. The packet will egress all the local ports, but will also
perform VXLAN encapsulation. The packet continues with the IP of the
remote VTEP(s) to the underlay router and then encounters a neighbour
miss exception, which sends it to the CPU for resolution.

Since this exception was encountered in the router the driver would mark
the packet with 'offload_fwd_mark', as it already performed L2
forwarding. If the VXLAN device has the same parent ID as the physical
netdevs, then the Linux bridge will never let it egress, nothing will
trigger neighbour resolution and the packet will be discarded.

> +				break;
> +			}
> +		}
> +
> +		if (sw_bridging)
> +			flags |= mask;
> +		else
> +			flags &= ~mask;
> +
> +		if (flags == p->flags)
> +			continue;
> +
> +		err = br_switchdev_set_port_flag(p, flags, mask);
> +		if (err)
> +			return err;
> +
> +		p->flags = flags;
> +	}
> +
> +	return 0;
> +}
> +
>  int nbp_backup_change(struct net_bridge_port *p,
>  		      struct net_device *backup_dev)
>  {
> @@ -231,6 +270,7 @@ static void nbp_update_port_count(struct net_bridge *br)
>  		br->auto_cnt = cnt;
>  		br_manage_promisc(br);
>  	}
> +	br_manage_host_flood(br);
>  }
>  
>  static void nbp_delete_promisc(struct net_bridge_port *p)
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 015209bf44aa..360806ac7463 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -56,7 +56,9 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
>  
>  /* Flags that can be offloaded to hardware */
>  #define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
> -				  BR_MCAST_FLOOD | BR_BCAST_FLOOD)
> +				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | \
> +				  BR_HOST_FLOOD | BR_HOST_MCAST_FLOOD | \
> +				  BR_HOST_BCAST_FLOOD)
>  
>  int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  			       unsigned long flags,
> -- 
> 2.25.1
> 
