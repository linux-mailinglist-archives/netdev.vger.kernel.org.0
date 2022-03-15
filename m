Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C53E4D9822
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346851AbiCOJyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346855AbiCOJyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:54:12 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A9ED9F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:52:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id qt6so39901365ejb.11
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nzL1DPOauY6xrdeyfpwRODojKdw/bFm68FMajovYo6g=;
        b=aPQtqBpjqL26lRUuA67dWSdBYZ+P/OnQD5b5DPaPCNVFC8mllI1F5Z4DrykGC7Nm52
         NYVARAcB6EKihQiU3nR7auLh2RMcX5iG4aZzNurSihePLSCDNafmV6aDnPt7iohqmzPT
         i+1RJQbOuQTUsiLaWuynMdfIp2D0pEXMbRgq3gppylA50fxe/er+TcNS8B7LqPy9DwNd
         xK4POQpl6tAPqXHcYYhL9RoWDsmggj0qIBO3em3KQdtOCCzH995aYYhNiMf7y+PmHirW
         gmes5oNZhwRimfcWiHSC/2oYzvBdzMMM04H84ESMBLL84WRaxdlbwsUak7eTTugCNdve
         PEXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nzL1DPOauY6xrdeyfpwRODojKdw/bFm68FMajovYo6g=;
        b=YYb5uJjgMdLiGaBF18Rj4/vLFdqH9qlzAz+QT98/zmhHvvw53xWtdfe+tvny6gaZP0
         37HSemwk+0Hy7J9zy51u3lh0mZZDvoQnLOUbKKLeF40kxkY2sooz/ndywV2tnlf7zSeJ
         9Gerj0El8x8bwr6Jt8pHjPMTkx4p80RL+WzBXoZQs1qWj+GzswqGkobDeS6+TzaskaEn
         WfnFRdGcYF5E2qUAl301NQ5eWhNhSuUG0PNMm/cMhREh/cIqi4d0913C7ftW44a4feXt
         AIuMvX6LXwI04Wg6wOqI6GPdsNahG1qAgd5KhO6IkFOJZtJTX7V0QR3K65/VM8JSZOL+
         0dmg==
X-Gm-Message-State: AOAM530hYRgDMjPxuduY5FySN1JuYiyuvWlwPdhtTXwTtGTY4r5pl5aD
        SJP6J5UNfrUs8NNmzzkBA35MPQ==
X-Google-Smtp-Source: ABdhPJyQkxhiMyLn0VYaZCt9sQO44O40CE85NeRb10VArr61L3n9t7cm6DbwGGYW3nPA3mCgwXjBGg==
X-Received: by 2002:a17:906:d555:b0:6da:ac8c:f66b with SMTP id cr21-20020a170906d55500b006daac8cf66bmr21422702ejc.107.1647337975509;
        Tue, 15 Mar 2022 02:52:55 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id a102-20020a509eef000000b0041614c8f79asm9346624edf.88.2022.03.15.02.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 02:52:55 -0700 (PDT)
Message-ID: <5c05d8b8-9c40-e38d-5c4d-e25526407e51@blackwall.org>
Date:   Tue, 15 Mar 2022 11:52:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 net-next 03/15] net: bridge: mst: Support setting and
 reporting MST port states
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-4-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220315002543.190587-4-tobias@waldekranz.com>
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

On 15/03/2022 02:25, Tobias Waldekranz wrote:
> Make it possible to change the port state in a given MSTI by extending
> the bridge port netlink interface (RTM_SETLINK on PF_BRIDGE).The
> proposed iproute2 interface would be:
> 
>     bridge mst set dev <PORT> msti <MSTI> state <STATE>
> 
> Current states in all applicable MSTIs can also be dumped via a
> corresponding RTM_GETLINK. The proposed iproute interface looks like
> this:
> 
> $ bridge mst
> port              msti
> vb1               0
> 		    state forwarding
> 		  100
> 		    state disabled
> vb2               0
> 		    state forwarding
> 		  100
> 		    state forwarding
> 
> The preexisting per-VLAN states are still valid in the MST
> mode (although they are read-only), and can be queried as usual if one
> is interested in knowing a particular VLAN's state without having to
> care about the VID to MSTI mapping (in this example VLAN 20 and 30 are
> bound to MSTI 100):
> 
> $ bridge -d vlan
> port              vlan-id
> vb1               10
> 		    state forwarding mcast_router 1
> 		  20
> 		    state disabled mcast_router 1
> 		  30
> 		    state disabled mcast_router 1
> 		  40
> 		    state forwarding mcast_router 1
> vb2               10
> 		    state forwarding mcast_router 1
> 		  20
> 		    state forwarding mcast_router 1
> 		  30
> 		    state forwarding mcast_router 1
> 		  40
> 		    state forwarding mcast_router 1
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/uapi/linux/if_bridge.h |  16 +++++
>  include/uapi/linux/rtnetlink.h |   1 +
>  net/bridge/br_mst.c            | 127 +++++++++++++++++++++++++++++++++
>  net/bridge/br_netlink.c        |  44 +++++++++++-
>  net/bridge/br_private.h        |  23 ++++++
>  5 files changed, 210 insertions(+), 1 deletion(-)
> 
[snip]
> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> index 78ef5fea4d2b..355ad102d6b1 100644
> --- a/net/bridge/br_mst.c
> +++ b/net/bridge/br_mst.c
> @@ -124,3 +124,130 @@ int br_mst_set_enabled(struct net_bridge *br, bool on,
>  	br_opt_toggle(br, BROPT_MST_ENABLED, on);
>  	return 0;
>  }
> +
> +size_t br_mst_info_size(const struct net_bridge_vlan_group *vg)
> +{
> +	DECLARE_BITMAP(seen, VLAN_N_VID) = { 0 };
> +	const struct net_bridge_vlan *v;
> +	size_t sz;
> +
> +	/* IFLA_BRIDGE_MST */
> +	sz = nla_total_size(0);
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {

Note that rtnl_calcit() (which ends up indirectly using this function) is called
only with rcu so you need to use list_for_each_entry_rcu() here.

> +		if (test_bit(v->brvlan->msti, seen))
> +			continue;
> +
> +		/* IFLA_BRIDGE_MST_ENTRY */
> +		sz += nla_total_size(0) +
> +			/* IFLA_BRIDGE_MST_ENTRY_MSTI */
> +			nla_total_size(sizeof(u16)) +
> +			/* IFLA_BRIDGE_MST_ENTRY_STATE */
> +			nla_total_size(sizeof(u8));
> +
> +		__set_bit(v->brvlan->msti, seen);
> +	}
> +
> +	return sz;
> +}
> +
