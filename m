Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F041E77F5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgE2IMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgE2IML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:12:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B1FC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:12:11 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id n5so2315584wmd.0
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 01:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5+fxliSeoLCLlOvZdamHCOkQy99HBngARsCHQl3OrwI=;
        b=DFlPCHv3OERcdYRzt8Y0QvSIMTMYTjAXEHa5Pk4ML1hZ57oA1ree/pZLBRLmF4mXSA
         tD8I/ABrbVa/F0/5qlkXi2+5QploJYrK2lgA6k1jhy+QE50BKDOHdjcYNPfyExCbFJvn
         EY2zGaqoYgLAQX5xuvR6gPRAwKC+IairWrNWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5+fxliSeoLCLlOvZdamHCOkQy99HBngARsCHQl3OrwI=;
        b=neetU5K6vm6MBIZkEVgpAKo3D3ymxu2q02dXFAkn3fY7TD4d2FMfpz8+r8Cf4rHqAr
         8VkqpyBtE+HxCGOaM9fdiV9htYDQWnFJ0v7pAbgz1VfGzP/zUr/PNIn0/eVfGrhszUSU
         KisiKGmPjSVhPnZGdrDzcf3QnTrc+aJBfdgFMKCe9HY5IeBwfMOBB4XfPhZmcqOJYtqg
         LZAKIH7LMl4gQqnAoGbWNBHa+dsFAJGceSVgLL0LwvCXpRiDi7O4jxHT/QLwW3u1WHDV
         ZEUADEG0niJCV6xzED6gErY7GzjA///QY66VyMoQ1D5D4MV5KuIuMYOxIy6GOuFM3nMP
         bZ7g==
X-Gm-Message-State: AOAM532IUq3NETFIRiIHbBJJbZmm7nXBrb0RnqofuF7eBNUzhKWVCxhO
        UMyNkdWnE2yGKPv3ez5Krk8Fsw==
X-Google-Smtp-Source: ABdhPJwUuvTjfMdWczk9cZjFBRn0F9Epnf3aYuTApUytcC5KC0FSQvQGiVHyGTn05ocQl5zr4I7jfw==
X-Received: by 2002:a1c:3c89:: with SMTP id j131mr7150208wma.59.1590739929838;
        Fri, 29 May 2020 01:12:09 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v2sm9053462wrn.21.2020.05.29.01.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 01:12:09 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] bridge: mrp: Set the priority of MRP
 instance
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, jiri@resnulli.us, ivecera@redhat.com,
        davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20200529100514.920537-1-horatiu.vultur@microchip.com>
 <20200529100514.920537-2-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <fc47aca8-a188-5e57-fe76-8e57c2910920@cumulusnetworks.com>
Date:   Fri, 29 May 2020 11:12:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200529100514.920537-2-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/05/2020 13:05, Horatiu Vultur wrote:
> Each MRP instance has a priority, a lower value means a higher priority.
> The priority of MRP instance is stored in MRP_Test frame in this way
> all the MRP nodes in the ring can see other nodes priority.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/net/switchdev.h        | 1 +
>  include/uapi/linux/if_bridge.h | 2 ++
>  net/bridge/br_mrp.c            | 3 ++-
>  net/bridge/br_mrp_netlink.c    | 5 +++++
>  net/bridge/br_mrp_switchdev.c  | 1 +
>  net/bridge/br_private_mrp.h    | 1 +
>  6 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index db519957e134b..f82ef4c45f5ed 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -116,6 +116,7 @@ struct switchdev_obj_mrp {
>  	struct net_device *p_port;
>  	struct net_device *s_port;
>  	u32 ring_id;
> +	u16 prio;
>  };
>  
>  #define SWITCHDEV_OBJ_MRP(OBJ) \
> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
> index 5a43eb86c93bf..0162c1370ecb6 100644
> --- a/include/uapi/linux/if_bridge.h
> +++ b/include/uapi/linux/if_bridge.h
> @@ -176,6 +176,7 @@ enum {
>  	IFLA_BRIDGE_MRP_INSTANCE_RING_ID,
>  	IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX,
>  	IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX,
> +	IFLA_BRIDGE_MRP_INSTANCE_PRIO,
>  	__IFLA_BRIDGE_MRP_INSTANCE_MAX,
>  };
>  
> @@ -230,6 +231,7 @@ struct br_mrp_instance {
>  	__u32 ring_id;
>  	__u32 p_ifindex;
>  	__u32 s_ifindex;
> +	__u16 prio;
>  };
>  
>  struct br_mrp_ring_state {
> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> index 8ea59504ef47a..f8fd037219fe9 100644
> --- a/net/bridge/br_mrp.c
> +++ b/net/bridge/br_mrp.c
> @@ -147,7 +147,7 @@ static struct sk_buff *br_mrp_alloc_test_skb(struct br_mrp *mrp,
>  	br_mrp_skb_tlv(skb, BR_MRP_TLV_HEADER_RING_TEST, sizeof(*hdr));
>  	hdr = skb_put(skb, sizeof(*hdr));
>  
> -	hdr->prio = cpu_to_be16(MRP_DEFAULT_PRIO);
> +	hdr->prio = cpu_to_be16(mrp->prio);
>  	ether_addr_copy(hdr->sa, p->br->dev->dev_addr);
>  	hdr->port_role = cpu_to_be16(port_role);
>  	hdr->state = cpu_to_be16(mrp->ring_state);
> @@ -290,6 +290,7 @@ int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
>  		return -ENOMEM;
>  
>  	mrp->ring_id = instance->ring_id;
> +	mrp->prio = instance->prio;
>  
>  	p = br_mrp_get_port(br, instance->p_ifindex);
>  	spin_lock_bh(&br->lock);
> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> index d9de780d2ce06..332d9894a9485 100644
> --- a/net/bridge/br_mrp_netlink.c
> +++ b/net/bridge/br_mrp_netlink.c
> @@ -22,6 +22,7 @@ br_mrp_instance_policy[IFLA_BRIDGE_MRP_INSTANCE_MAX + 1] = {
>  	[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]	= { .type = NLA_U32 },
>  	[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]	= { .type = NLA_U32 },
>  	[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]	= { .type = NLA_U32 },
> +	[IFLA_BRIDGE_MRP_INSTANCE_PRIO]		= { .type = NLA_U16 },
>  };
>  
>  static int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
> @@ -49,6 +50,10 @@ static int br_mrp_instance_parse(struct net_bridge *br, struct nlattr *attr,
>  	inst.ring_id = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_RING_ID]);
>  	inst.p_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_P_IFINDEX]);
>  	inst.s_ifindex = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_S_IFINDEX]);
> +	inst.prio = MRP_DEFAULT_PRIO;
> +
> +	if (tb[IFLA_BRIDGE_MRP_INSTANCE_PRIO])
> +		inst.prio = nla_get_u32(tb[IFLA_BRIDGE_MRP_INSTANCE_PRIO]);

	[IFLA_BRIDGE_MRP_INSTANCE_PRIO]		= { .type = NLA_U16 },

it seems you should be using nla_get_u16 above

>  
>  	if (cmd == RTM_SETLINK)
>  		return br_mrp_add(br, &inst);
> diff --git a/net/bridge/br_mrp_switchdev.c b/net/bridge/br_mrp_switchdev.c
> index 51cb1d5a24b4f..3a776043bf80d 100644
> --- a/net/bridge/br_mrp_switchdev.c
> +++ b/net/bridge/br_mrp_switchdev.c
> @@ -12,6 +12,7 @@ int br_mrp_switchdev_add(struct net_bridge *br, struct br_mrp *mrp)
>  		.p_port = rtnl_dereference(mrp->p_port)->dev,
>  		.s_port = rtnl_dereference(mrp->s_port)->dev,
>  		.ring_id = mrp->ring_id,
> +		.prio = mrp->prio,
>  	};
>  	int err;
>  
> diff --git a/net/bridge/br_private_mrp.h b/net/bridge/br_private_mrp.h
> index a0f53cc3ab85c..558941ce23669 100644
> --- a/net/bridge/br_private_mrp.h
> +++ b/net/bridge/br_private_mrp.h
> @@ -14,6 +14,7 @@ struct br_mrp {
>  	struct net_bridge_port __rcu	*s_port;
>  
>  	u32				ring_id;
> +	u16				prio;
>  
>  	enum br_mrp_ring_role_type	ring_role;
>  	u8				ring_role_offloaded;
> 

