Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829954D0261
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 16:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243638AbiCGPEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 10:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243628AbiCGPEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:04:10 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB081CFFF
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 07:03:06 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qt6so32549491ejb.11
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 07:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1jGYNh9y1jCRU2Ce5sNN/KIt4KeyZCiwBUd3+H3/o08=;
        b=EPe6VKyTN3nTIzc2Xu7I2TzJ81mO0rAjis5e8dPqpR3ke+IxwnOlBfNPx+2ws/yGE3
         6N4/8USZpMXGOwMkBkqaPsVFdpV8/CL4M6KipioCaKru2ps8txN/LvRTjfo3odLRts6j
         fi+KihWJv3uBnoAWDW/kotNPPjMlBie/FtXtowgGvSNW5z1WUt6J+yYac/cEsP5deNzy
         MA/WWVTVHSo3WhWOdvDyX/xgxHTh5EllYSTqr1Fwj2IiAvONMN961PLJ9mcXqr8FOl2c
         GrZBmpYQfZ3YXMy3aolMw9hj5Rniup+pGJVxlRmHJbWomoHnT+ZUyYSJXJ315/KKHgwj
         vM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1jGYNh9y1jCRU2Ce5sNN/KIt4KeyZCiwBUd3+H3/o08=;
        b=pUW2NlqLW77NXHVZzStXkI+W/dvgwV3tQaeOuyGR+VtZydAPXgNfoSPcrJ5J8i6Z5E
         lNegqqhTXkyLSF+xYxsBggwTTbhtTheBBFK9cDtT1XoolwhEjKQMMtt6bBEfJWe6Ey7I
         JyJsf5BtN7rsmvWDgxDUdEeKSYg4MhtZEh7zaj+ixM0rRziGJAxhDSoO1lUCAmvuWyC3
         Yl01+j9Al3TrtRszUZKiezLvAdCpZumYZv4FqPfOB8qHdf/GKQyeif4ONxZmY/1I5OsG
         UHGOzsKqvTJByiWndh0AzkV/6bKItI2ggNH5J6djc6LY6+5BItB7RJqcHZgCgTUE7khF
         33Sw==
X-Gm-Message-State: AOAM530Qr43v4mm/wBXbYaxwnQW78T5p2M7YvfM/cwhJt0wSyvkSq7zy
        gZD6a0+i51GzeglqUiYZE/ooJA==
X-Google-Smtp-Source: ABdhPJxw/ApTPxDn/10PdEkN1SCTAkfYKFxobqWQQuC1vOOuDcHNFUBkcLCxGISX5Csx6MeskjbIMg==
X-Received: by 2002:a17:907:7f03:b0:6d9:acb2:33ac with SMTP id qf3-20020a1709077f0300b006d9acb233acmr9165596ejc.705.1646665384867;
        Mon, 07 Mar 2022 07:03:04 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id jl2-20020a17090775c200b006dabe8887b8sm3535382ejc.21.2022.03.07.07.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 07:03:04 -0800 (PST)
Message-ID: <4fc171ed-98dd-2574-6373-f58b4b9e036a@blackwall.org>
Date:   Mon, 7 Mar 2022 17:03:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 03/10] net: bridge: mst: Support setting and
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
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-4-tobias@waldekranz.com>
 <53EED92D-FEAC-4CC6-AF2A-52E73F839AB5@blackwall.org>
 <874k49olix.fsf@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <874k49olix.fsf@waldekranz.com>
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

On 07/03/2022 17:00, Tobias Waldekranz wrote:
> On Wed, Mar 02, 2022 at 00:19, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 1 March 2022 11:03:14 CET, Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>> Make it possible to change the port state in a given MSTI. This is
>>> done through a new netlink interface, since the MSTIs are objects in
>>> their own right. The proposed iproute2 interface would be:
>>>
>>>    bridge mst set dev <PORT> msti <MSTI> state <STATE>
>>>
>>> Current states in all applicable MSTIs can also be dumped. The
>>> proposed iproute interface looks like this:
>>>
>>> $ bridge mst
>>> port              msti
>>> vb1               0
>>> 		    state forwarding
>>> 		  100
>>> 		    state disabled
>>> vb2               0
>>> 		    state forwarding
>>> 		  100
>>> 		    state forwarding
>>>
>>> The preexisting per-VLAN states are still valid in the MST
>>> mode (although they are read-only), and can be queried as usual if one
>>> is interested in knowing a particular VLAN's state without having to
>>> care about the VID to MSTI mapping (in this example VLAN 20 and 30 are
>>> bound to MSTI 100):
>>>
>>> $ bridge -d vlan
>>> port              vlan-id
>>> vb1               10
>>> 		    state forwarding mcast_router 1
>>> 		  20
>>> 		    state disabled mcast_router 1
>>> 		  30
>>> 		    state disabled mcast_router 1
>>> 		  40
>>> 		    state forwarding mcast_router 1
>>> vb2               10
>>> 		    state forwarding mcast_router 1
>>> 		  20
>>> 		    state forwarding mcast_router 1
>>> 		  30
>>> 		    state forwarding mcast_router 1
>>> 		  40
>>> 		    state forwarding mcast_router 1
>>>
>>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>> ---
>>> include/uapi/linux/if_bridge.h |  16 +++
>>> include/uapi/linux/rtnetlink.h |   5 +
>>> net/bridge/br_mst.c            | 244 +++++++++++++++++++++++++++++++++
>>> net/bridge/br_netlink.c        |   3 +
>>> net/bridge/br_private.h        |   4 +
>>> 5 files changed, 272 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>>> index b68016f625b7..784482527861 100644
>>> --- a/include/uapi/linux/if_bridge.h
>>> +++ b/include/uapi/linux/if_bridge.h
>>> @@ -785,4 +785,20 @@ enum {
>>> 	__BRIDGE_QUERIER_MAX
>>> };
>>> #define BRIDGE_QUERIER_MAX (__BRIDGE_QUERIER_MAX - 1)
>>> +
>>> +enum {
>>> +	BRIDGE_MST_UNSPEC,
>>> +	BRIDGE_MST_ENTRY,
>>> +	__BRIDGE_MST_MAX,
>>> +};
>>> +#define BRIDGE_MST_MAX (__BRIDGE_MST_MAX - 1)
>>> +
>>> +enum {
>>> +	BRIDGE_MST_ENTRY_UNSPEC,
>>> +	BRIDGE_MST_ENTRY_MSTI,
>>> +	BRIDGE_MST_ENTRY_STATE,
>>> +	__BRIDGE_MST_ENTRY_MAX,
>>> +};
>>> +#define BRIDGE_MST_ENTRY_MAX (__BRIDGE_MST_ENTRY_MAX - 1)
>>> +
>>> #endif /* _UAPI_LINUX_IF_BRIDGE_H */
>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>> index 0970cb4b1b88..4a48f3ce862c 100644
>>> --- a/include/uapi/linux/rtnetlink.h
>>> +++ b/include/uapi/linux/rtnetlink.h
>>> @@ -192,6 +192,11 @@ enum {
>>> 	RTM_GETTUNNEL,
>>> #define RTM_GETTUNNEL	RTM_GETTUNNEL
>>>
>>> +	RTM_GETMST = 124 + 2,
>>> +#define RTM_GETMST	RTM_GETMST
>>> +	RTM_SETMST,
>>> +#define RTM_SETMST	RTM_SETMST
>>> +
>>
>> I think you should also update selinux  (see nlmsgtab.c)
>> I'll think about this one, if there is some nice way to avoid the new rtm types.
>>
>>> 	__RTM_MAX,
>>> #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
>>> };
>>> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
>>> index f3b8e279b85c..8dea8e7257fd 100644
>>> --- a/net/bridge/br_mst.c
>>> +++ b/net/bridge/br_mst.c
>>> @@ -120,3 +120,247 @@ int br_mst_set_enabled(struct net_bridge *br, unsigned long val)
>>> 	br_opt_toggle(br, BROPT_MST_ENABLED, !!val);
>>> 	return 0;
>>> }
>>> +
>>> +static int br_mst_nl_get_one(struct net_bridge_port *p, struct sk_buff *skb,
>>> +			     struct netlink_callback *cb)
>>> +{
>>> +	struct net_bridge_vlan_group *vg = nbp_vlan_group(p);
>>> +	int err = 0, idx = 0, s_idx = cb->args[1];
>>> +	struct net_bridge_vlan *v;
>>> +	struct br_port_msg *bpm;
>>> +	struct nlmsghdr *nlh;
>>> +	struct nlattr *nest;
>>> +	unsigned long *seen;
>>> +
>>
>> Reverse xmas tree
> 
> Both of these lines end at the 28th column. Is there some other
> tiebreaking mechanism that forces the reverse ordering of nest and seen?
> 
> In a variable-width font, the nest declaration does appear shorter. I
> remember that you did not have your laptop with you, could that be it?

Ah yes, you're right. :) Sorry for the noise.

