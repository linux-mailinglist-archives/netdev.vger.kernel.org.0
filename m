Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D92921207E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgGBKB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728097AbgGBKB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 06:01:57 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1C6C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 03:01:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l17so26085118wmj.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zR26Xhy2G+eY0HqU3wMJ0rmUDSZXWCuQzZljZslDQZc=;
        b=YlQ9pF7ADm8jiiTkcapeL+FYckkTO+KJpnPdbVSBoYaiBvOUHfZAx9CodOizdKgsNc
         a2FIWapk4J0D/kJogR20vITg9TwvrDUyZkE2F7pOEHaCg11+3y8dmdFIwZt6EZQfLfV2
         N7AX34BsMO+vxLb2ThbB57hpkMRlEuuzprGrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zR26Xhy2G+eY0HqU3wMJ0rmUDSZXWCuQzZljZslDQZc=;
        b=EzZ5zCBZx/ddcXf7jP8pzpNQvHCH8jlf3q577OOtmtyVn282ll3mpN6YhmfeuFKXBR
         nPO/p0Og7N40G0jO4cfzwkjK9eP5iKV5lHCBwvlYW+4IrsETdomkdH2/iRbwxv5x3cU6
         hSMqyNCBwk7ZXPE7ehddOAeXBRHpqKOzNjJ9lr9pgRKnORAGhFNRGzITbDFG8rOoQIhq
         cI5k+iQemF1Au3aGINGNtoXNXuiAfSNYfJn+4wLgf+75juDkqX1h+z0SdnMEq3jQ+Zvl
         K6DRxS4KQnig4DUbnwYT36IAxwmVlQjnnKPNQLWjKiqBufOjMSMaHFwjgJlV7JkLgvOB
         FFYQ==
X-Gm-Message-State: AOAM532PNIS8+EHHsL9Zpc2dtcFpZMGU+EIj/1znv7qrk6shaPMZV8R/
        JbyvhwxCkwvrKjlevRp5vFO+N5GHcc3aAg==
X-Google-Smtp-Source: ABdhPJxFd4KPobStYvRWnTWiqoQM4UsiF6fqmUXbsmW+fDq6oEBtC8UpFkSOL+liCdPm4paeAmQHWA==
X-Received: by 2002:a7b:cd09:: with SMTP id f9mr32406526wmj.160.1593684115437;
        Thu, 02 Jul 2020 03:01:55 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id z63sm5566702wmb.2.2020.07.02.03.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 03:01:54 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/3] bridge: mrp: Add br_mrp_fill_info
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        UNGLinuxDriver@microchip.com
References: <20200702081307.933471-1-horatiu.vultur@microchip.com>
 <20200702081307.933471-3-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <64dd72f9-2b81-335a-e6ae-85376c72aa47@cumulusnetworks.com>
Date:   Thu, 2 Jul 2020 13:01:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200702081307.933471-3-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2020 11:13, Horatiu Vultur wrote:
> Add the function br_mrp_fill_info which populates the MRP attributes
> regarding the status of each MRP instance.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp_netlink.c | 64 +++++++++++++++++++++++++++++++++++++
>  net/bridge/br_private.h     |  7 ++++
>  2 files changed, 71 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> index 34b3a8776991f..c4f5c356811f3 100644
> --- a/net/bridge/br_mrp_netlink.c
> +++ b/net/bridge/br_mrp_netlink.c
> @@ -304,6 +304,70 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
>  	return 0;
>  }
>  
> +int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
> +{
> +	struct nlattr *tb, *mrp_tb;
> +	struct br_mrp *mrp;
> +
> +	mrp_tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP);
> +	if (!mrp_tb)
> +		return -EMSGSIZE;
> +
> +	list_for_each_entry_rcu(mrp, &br->mrp_list, list) {
> +		struct net_bridge_port *p;
> +
> +		tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_MRP_INFO);
> +		if (!tb)
> +			goto nla_info_failure;
> +
> +		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_ID,
> +				mrp->ring_id))
> +			goto nla_put_failure;
> +
> +		p = rcu_dereference(mrp->p_port);
> +		if (p && nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_P_IFINDEX,
> +				     p->dev->ifindex))
> +			goto nla_put_failure;
> +
> +		p = rcu_dereference(mrp->s_port);
> +		if (p && nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_S_IFINDEX,
> +				     p->dev->ifindex))
> +			goto nla_put_failure;
> +
> +		if (nla_put_u16(skb, IFLA_BRIDGE_MRP_INFO_PRIO,
> +				mrp->prio))
> +			goto nla_put_failure;
> +		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_STATE,
> +				mrp->ring_state))
> +			goto nla_put_failure;
> +		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_RING_ROLE,
> +				mrp->ring_role))
> +			goto nla_put_failure;
> +		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_INTERVAL,
> +				mrp->test_interval))
> +			goto nla_put_failure;
> +		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_MAX_MISS,
> +				mrp->test_max_miss))
> +			goto nla_put_failure;
> +		if (nla_put_u32(skb, IFLA_BRIDGE_MRP_INFO_TEST_MONITOR,
> +				mrp->test_monitor))
> +			goto nla_put_failure;
> +
> +		nla_nest_end(skb, tb);
> +	}
> +	nla_nest_end(skb, mrp_tb);
> +
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, tb);
> +
> +nla_info_failure:
> +	nla_nest_cancel(skb, mrp_tb);
> +
> +	return -EMSGSIZE;
> +}
> +
>  int br_mrp_port_open(struct net_device *dev, u8 loc)
>  {
>  	struct net_bridge_port *p;
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 6a7d8e218ae7e..65d2c163a24ab 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1317,6 +1317,7 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
>  int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
>  bool br_mrp_enabled(struct net_bridge *br);
>  void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
> +int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br);
>  #else
>  static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
>  			       struct nlattr *attr, int cmd,
> @@ -1339,6 +1340,12 @@ static inline void br_mrp_port_del(struct net_bridge *br,
>  				   struct net_bridge_port *p)
>  {
>  }
> +
> +static inline int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
> +{
> +	return 0;
> +}
> +
>  #endif
>  
>  /* br_netlink.c */
> 

