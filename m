Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF0D4DC3B6
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiCQKND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbiCQKNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:13:01 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F88BD7C1
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:11:45 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w4so5897443edc.7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/soL1IkgVkNlRiiSrGWbcBnUZFuwuGrdnQwwTFiy260=;
        b=PXvDXurEIY9hcjqnvswPho7W9Z+wjmNC9XWH3qBkbU8uar9ygNCW/rsiYzJJQcSyXR
         HQqWEGgwxrDIMFsdQfJmNalp5P6bfT70cR0wEZ97zJ0CGR43qmXAyVxlZuh6G84BWeI7
         JN1QFJ1evEsMHaTDpU2pwrw5CSTrmu+qSdbGn8gwg9i8gwVu52sGb2ZTPK4/1TXTXrSP
         gnOU+YLhhdHcvghe5W255W9OHijxB7hQWxvwrrKUyER+AF3EIHeVcQzAbgdhS17tQLZc
         LOX/gKFs/QcfDROuEa/k2GycR4DMMiFPM7HHpjcxXDjR59P8LJUs8qHWocVbP68nibfd
         6VIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/soL1IkgVkNlRiiSrGWbcBnUZFuwuGrdnQwwTFiy260=;
        b=bz0l0/cs4RsTmpiAc5p4pE706SR4E8wHaa5nWKKGI3B+hAiBt8DAfq6Jbg9Ze8LFoz
         9MFZMVXq1BBaA5f2E5qVk/c0msY4rWpUjhdUVOO71mi/yAr11KFOZstm2d/BrGTpHRrr
         YP8KLJ8rRfQzdQ9KFm+nAYJwjdiO+8SqdEf3HHW0zRv2VuNXQr2FzBSLtmcen05axHq6
         jpdlXhQE8MFQs/5SP0/aXNNQE6Bl4rwgrwvSnC++ZFGrpd6z2fP0qs+2VfAtNz2ZM/Bp
         2ajZmLt5A5IBUuUMMGJGQOk9voOTr+55CV9H6sAB8Lvw1ih9qg8jOaV/QrGrwnTSM0Kh
         3HVg==
X-Gm-Message-State: AOAM533PWNL/Q4TQvJc4xCAeRoF2tRIP6/FghoGj/C+zltpc0q3Il631
        hPqZS89a0PH4602i87dijxfXWQ==
X-Google-Smtp-Source: ABdhPJxp3+iMnzCReFdplblOoIit5ppZQDMdYwYx2nQh0a78lGFs/m8FSWucn5VajY0M5UxA0mlRQw==
X-Received: by 2002:a05:6402:520a:b0:417:f20c:6b5a with SMTP id s10-20020a056402520a00b00417f20c6b5amr3584193edd.11.1647511902662;
        Thu, 17 Mar 2022 03:11:42 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2113747eje.173.2022.03.17.03.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 03:11:42 -0700 (PDT)
Message-ID: <f2104e0e-45f2-1fe6-5cf9-ef3fa0f1475d@blackwall.org>
Date:   Thu, 17 Mar 2022 12:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/5] net: bridge: Implement bridge flood flag
Content-Language: en-US
To:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Joachim Wiberg <troglobit@gmail.com>
References: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
 <20220317065031.3830481-3-mattias.forsblad@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220317065031.3830481-3-mattias.forsblad@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2022 08:50, Mattias Forsblad wrote:
> This patch implements the bridge flood flags. There are three different
> flags matching unicast, multicast and broadcast. When the corresponding
> flag is cleared packets received on bridge ports will not be flooded
> towards the bridge.
> This makes is possible to only forward selected traffic between the
> port members of the bridge.
> 
> Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
> ---
>  include/linux/if_bridge.h      |  6 +++++
>  include/uapi/linux/if_bridge.h |  9 ++++++-
>  net/bridge/br.c                | 45 ++++++++++++++++++++++++++++++++++
>  net/bridge/br_device.c         |  3 +++
>  net/bridge/br_input.c          | 23 ++++++++++++++---
>  net/bridge/br_private.h        |  4 +++
>  6 files changed, 85 insertions(+), 5 deletions(-)
> 
Please always CC bridge maintainers for bridge patches.

I almost missed this one. I'll add my reply to Joachim's notes
which are pretty spot on.

> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 3aae023a9353..fa8e000a6fb9 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -157,6 +157,7 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
>  struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>  				    const unsigned char *addr,
>  				    __u16 vid);
> +bool br_flood_enabled(const struct net_device *dev);
>  void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>  bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>  u8 br_port_get_stp_state(const struct net_device *dev);
> @@ -170,6 +171,11 @@ br_fdb_find_port(const struct net_device *br_dev,
>  	return NULL;
>  }
>  
> +static inline bool br_flood_enabled(const struct net_device *dev)
> +{
> +	return true;
> +}
> +
>  static inline void br_fdb_clear_offload(const struct net_device *dev, u16 vid)
>  {
>  }
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 2711c3522010..765ed70c9b28 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -72,6 +72,7 @@ struct __bridge_info {
>  	__u32 tcn_timer_value;
>  	__u32 topology_change_timer_value;
>  	__u32 gc_timer_value;
> +	__u8 flood;
>  };
>  
>  struct __port_info {
> @@ -752,13 +753,19 @@ struct br_mcast_stats {
>  /* bridge boolean options
>   * BR_BOOLOPT_NO_LL_LEARN - disable learning from link-local packets
>   * BR_BOOLOPT_MCAST_VLAN_SNOOPING - control vlan multicast snooping
> + * BR_BOOLOPT_FLOOD - control bridge flood flag
> + * BR_BOOLOPT_MCAST_FLOOD - control bridge multicast flood flag
> + * BR_BOOLOPT_BCAST_FLOOD - control bridge broadcast flood flag
>   *
>   * IMPORTANT: if adding a new option do not forget to handle
> - *            it in br_boolopt_toggle/get and bridge sysfs
> + *            it in br_boolopt_toggle/get
>   */
>  enum br_boolopt_id {
>  	BR_BOOLOPT_NO_LL_LEARN,
>  	BR_BOOLOPT_MCAST_VLAN_SNOOPING,
> +	BR_BOOLOPT_FLOOD,
> +	BR_BOOLOPT_MCAST_FLOOD,
> +	BR_BOOLOPT_BCAST_FLOOD,
>  	BR_BOOLOPT_MAX
>  };
>  
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index b1dea3febeea..63a17bed6c63 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -265,6 +265,11 @@ int br_boolopt_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on,
>  	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
>  		err = br_multicast_toggle_vlan_snooping(br, on, extack);
>  		break;
> +	case BR_BOOLOPT_FLOOD:
> +	case BR_BOOLOPT_MCAST_FLOOD:
> +	case BR_BOOLOPT_BCAST_FLOOD:
> +		err = br_flood_toggle(br, opt, on);
> +		break;
>  	default:
>  		/* shouldn't be called with unsupported options */
>  		WARN_ON(1);
> @@ -281,6 +286,12 @@ int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
>  		return br_opt_get(br, BROPT_NO_LL_LEARN);
>  	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
>  		return br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED);
> +	case BR_BOOLOPT_FLOOD:
> +		return br_opt_get(br, BROPT_FLOOD);
> +	case BR_BOOLOPT_MCAST_FLOOD:
> +		return br_opt_get(br, BROPT_MCAST_FLOOD);
> +	case BR_BOOLOPT_BCAST_FLOOD:
> +		return br_opt_get(br, BROPT_BCAST_FLOOD);
>  	default:
>  		/* shouldn't be called with unsupported options */
>  		WARN_ON(1);
> @@ -325,6 +336,40 @@ void br_boolopt_multi_get(const struct net_bridge *br,
>  	bm->optmask = GENMASK((BR_BOOLOPT_MAX - 1), 0);
>  }
>  
> +int br_flood_toggle(struct net_bridge *br, enum br_boolopt_id opt,
> +		    bool on)
> +{
> +	struct switchdev_attr attr = {
> +		.orig_dev = br->dev,
> +		.id = SWITCHDEV_ATTR_ID_BRIDGE_FLOOD,
> +		.flags = SWITCHDEV_F_DEFER,
> +	};
> +	enum net_bridge_opts bropt;
> +	int ret;
> +
> +	switch (opt) {
> +	case BR_BOOLOPT_FLOOD:
> +		bropt = BROPT_FLOOD;
> +		break;
> +	case BR_BOOLOPT_MCAST_FLOOD:
> +		bropt = BROPT_MCAST_FLOOD;
> +		break;
> +	case BR_BOOLOPT_BCAST_FLOOD:
> +		bropt = BROPT_BCAST_FLOOD;
> +		break;
> +	default:
> +		WARN_ON(1);
> +		return -EINVAL;
> +	}
> +	br_opt_toggle(br, bropt, on);
> +
> +	attr.u.brport_flags.mask = BIT(bropt);
> +	attr.u.brport_flags.val = on << bropt;
> +	ret = switchdev_port_attr_set(br->dev, &attr, NULL);
> +
> +	return ret;
> +}
> +
>  /* private bridge options, controlled by the kernel */
>  void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on)
>  {
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 8d6bab244c4a..fafaef9d4b3a 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -524,6 +524,9 @@ void br_dev_setup(struct net_device *dev)
>  	br->bridge_hello_time = br->hello_time = 2 * HZ;
>  	br->bridge_forward_delay = br->forward_delay = 15 * HZ;
>  	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
> +	br_opt_toggle(br, BROPT_FLOOD, true);
> +	br_opt_toggle(br, BROPT_MCAST_FLOOD, true);
> +	br_opt_toggle(br, BROPT_BCAST_FLOOD, true);
>  	dev->max_mtu = ETH_MAX_MTU;
>  
>  	br_netfilter_rtable_init(br);
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index e0c13fcc50ed..fcb0757bfdcc 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -109,11 +109,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  		/* by definition the broadcast is also a multicast address */
>  		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
>  			pkt_type = BR_PKT_BROADCAST;
> -			local_rcv = true;
> +			local_rcv = true && br_opt_get(br, BROPT_BCAST_FLOOD);
>  		} else {
>  			pkt_type = BR_PKT_MULTICAST;
> -			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
> -				goto drop;
> +			if (br_opt_get(br, BROPT_MCAST_FLOOD))
> +				if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
> +					goto drop;
>  		}
>  	}
>  
> @@ -155,9 +156,13 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  			local_rcv = true;
>  			br->dev->stats.multicast++;
>  		}
> +		if (!br_opt_get(br, BROPT_MCAST_FLOOD))
> +			local_rcv = false;
>  		break;
>  	case BR_PKT_UNICAST:
>  		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
> +		if (!br_opt_get(br, BROPT_FLOOD))
> +			local_rcv = false;
>  		break;
>  	default:
>  		break;
> @@ -166,7 +171,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  	if (dst) {
>  		unsigned long now = jiffies;
>  
> -		if (test_bit(BR_FDB_LOCAL, &dst->flags))
> +		if (test_bit(BR_FDB_LOCAL, &dst->flags) && local_rcv)
>  			return br_pass_frame_up(skb);
>  
>  		if (now != dst->used)
> @@ -190,6 +195,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  }
>  EXPORT_SYMBOL_GPL(br_handle_frame_finish);
>  
> +bool br_flood_enabled(const struct net_device *dev)
> +{
> +	struct net_bridge *br = netdev_priv(dev);
> +
> +	return !!(br_opt_get(br, BROPT_FLOOD) ||
> +		   br_opt_get(br, BROPT_MCAST_FLOOD) ||
> +		   br_opt_get(br, BROPT_BCAST_FLOOD));
> +}
> +EXPORT_SYMBOL_GPL(br_flood_enabled);
> +
>  static void __br_handle_local_finish(struct sk_buff *skb)
>  {
>  	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 48bc61ebc211..cf88dce0b92b 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -445,6 +445,9 @@ enum net_bridge_opts {
>  	BROPT_NO_LL_LEARN,
>  	BROPT_VLAN_BRIDGE_BINDING,
>  	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
> +	BROPT_FLOOD,
> +	BROPT_MCAST_FLOOD,
> +	BROPT_BCAST_FLOOD,
>  };
>  
>  struct net_bridge {
> @@ -720,6 +723,7 @@ int br_boolopt_multi_toggle(struct net_bridge *br,
>  void br_boolopt_multi_get(const struct net_bridge *br,
>  			  struct br_boolopt_multi *bm);
>  void br_opt_toggle(struct net_bridge *br, enum net_bridge_opts opt, bool on);
> +int br_flood_toggle(struct net_bridge *br, enum br_boolopt_id opt, bool on);
>  
>  /* br_device.c */
>  void br_dev_setup(struct net_device *dev);

