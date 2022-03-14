Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBE54D8063
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiCNLKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiCNLKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:10:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C87113CF8
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:09:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h13so19274895ede.5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 04:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=6n6ZEPynSftslrkkn67A9oe0ON+g8zOOoRrauuQESMk=;
        b=mdNIalz8h2RDTjPqrlM3K4jz0236U7jn5xSEIBvOEbVYU/XbpiHR159ZScGA4hIDYx
         yuL9nVsFKdhvSzggc/aCQm7MaYAF0quz3ReRJfl3YNaP13vvZulbDJzlv6X7A9O9OTy7
         pI3wSVawVh5TNALp7y/RBVPdu1nsqFXZBbZmkAAA+nyGM/4HGglw7KnHsIj6bsba+0K4
         t2R/sBj7TWigNOI6yHniw5MThsD7e9Pdt3uiptfvGhwjZAJAHGyx2NLiO4qVRIYELhUj
         MH/kDdd+9R31vP59FZ4L2Fwm40x5LTQ+tIjfEjBpmSXbk2Jdz/nfQFpL1+nO3OEyhVzC
         evAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=6n6ZEPynSftslrkkn67A9oe0ON+g8zOOoRrauuQESMk=;
        b=BGgqR4e8sQyVC6EdETW9ZmRAh8hjJX+Yth3tTjgqqQengLVSmQSzU3lIPEJ4gACb/B
         pO1uTadNe4xRmXXkzi3ityfkIJr3x4Ecjf4kYBpaR92pIhXitv9XNAyMy6R95J4MCnf+
         63D8Y9aO26nRTKpC6FjTZLKiSa2vG3w/tIzkGViDy4KvfwvjADfzBrcFfwk0sTal8U2P
         CtTYlOFOn083SZDLzpgKrTIVPiK5kIZm++dV7IekPS+1a181Pvmja1DEP+egrkBHgwl6
         1XkOzimN46m6sWsm0qNDnT5Otx3/rID+aBZv6FVqbkyO+WJcvJkG8yTioiY2YdOi9EHQ
         ilvA==
X-Gm-Message-State: AOAM530dNkAsZ0gEonVAUF8P6jyX/x9486801ynPvm2qe7PXnwNrl1J1
        Dhkz7W4GdYD6SDVnQzLqdTdAbQ==
X-Google-Smtp-Source: ABdhPJytZgYN5TIXtT04/HdwGf3nX+Q2qhLKHYxSegtQ6AUH7F1BwD6kLs3Rx9zAh4zfS9hUnzKQFQ==
X-Received: by 2002:aa7:ce1a:0:b0:416:460:9df5 with SMTP id d26-20020aa7ce1a000000b0041604609df5mr19651936edv.277.1647256147967;
        Mon, 14 Mar 2022 04:09:07 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id er12-20020a056402448c00b00413d03ac4a2sm7419235edb.69.2022.03.14.04.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 04:09:07 -0700 (PDT)
Message-ID: <037a8f48-29c5-ae45-b562-df15dbe6d163@blackwall.org>
Date:   Mon, 14 Mar 2022 13:09:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 01/14] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
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
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220314095231.3486931-1-tobias@waldekranz.com>
 <20220314095231.3486931-2-tobias@waldekranz.com>
 <9c103a85-f0e2-77cd-9fc6-dc19d99b19ec@blackwall.org>
In-Reply-To: <9c103a85-f0e2-77cd-9fc6-dc19d99b19ec@blackwall.org>
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

On 14/03/2022 12:37, Nikolay Aleksandrov wrote:
> On 14/03/2022 11:52, Tobias Waldekranz wrote:
>> Allow the user to switch from the current per-VLAN STP mode to an MST
>> mode.
>>
>> Up to this point, per-VLAN STP states where always isolated from each
>> other. This is in contrast to the MSTP standard (802.1Q-2018, Clause
>> 13.5), where VLANs are grouped into MST instances (MSTIs), and the
>> state is managed on a per-MSTI level, rather that at the per-VLAN
>> level.
>>
>> Perhaps due to the prevalence of the standard, many switching ASICs
>> are built after the same model. Therefore, add a corresponding MST
>> mode to the bridge, which we can later add offloading support for in a
>> straight-forward way.
>>
>> For now, all VLANs are fixed to MSTI 0, also called the Common
>> Spanning Tree (CST). That is, all VLANs will follow the port-global
>> state.
>>
>> Upcoming changes will make this actually useful by allowing VLANs to
>> be mapped to arbitrary MSTIs and allow individual MSTI states to be
>> changed.
>>
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
> [snip]
>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> index 48bc61ebc211..35b47f6b449a 100644
>> --- a/net/bridge/br_private.h
>> +++ b/net/bridge/br_private.h
>> @@ -178,6 +178,7 @@ enum {
>>   * @br_mcast_ctx: if MASTER flag set, this is the global vlan multicast context
>>   * @port_mcast_ctx: if MASTER flag unset, this is the per-port/vlan multicast
>>   *                  context
>> + * @msti: if MASTER flag set, this holds the VLANs MST instance
>>   * @vlist: sorted list of VLAN entries
>>   * @rcu: used for entry destruction
>>   *
>> @@ -210,6 +211,8 @@ struct net_bridge_vlan {
>>  		struct net_bridge_mcast_port	port_mcast_ctx;
>>  	};
>>  
>> +	u16				msti;
>> +
>>  	struct list_head		vlist;
>>  
>>  	struct rcu_head			rcu;
>> @@ -445,6 +448,7 @@ enum net_bridge_opts {
>>  	BROPT_NO_LL_LEARN,
>>  	BROPT_VLAN_BRIDGE_BINDING,
>>  	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
>> +	BROPT_MST_ENABLED,
>>  };
>>  
>>  struct net_bridge {
>> @@ -1765,6 +1769,29 @@ static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
>>  }
>>  #endif
>>  
>> +/* br_mst.c */
>> +#ifdef CONFIG_BRIDGE_VLAN_FILTERING
> 
> There is already such ifdef, you can embed all MST code inside it.
> 

My bad, I somehow confused the function placement. This is good. :)

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

