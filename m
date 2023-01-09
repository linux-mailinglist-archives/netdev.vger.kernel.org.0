Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679326624AA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbjAILwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbjAILvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:51:46 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A96B5F5A
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 03:51:45 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id fy8so19321829ejc.13
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 03:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ozl2+3CNbOGcFgir3rEQ41Ac/ijTRZdlB8u+sHLq/PU=;
        b=q26NSJL3gz3bQkxp9t5GOIbI1B65qBaA4F8ov68W9DczLzoPzO9DY+3slzVvSPMCT/
         nrqt8Go4OQ1zJE9Mv5eBhQLGs8/NRIqim0vDW/cZSkIlarBF8dHxwJ5aGHBjSP7s9Dik
         oTTQ1mrmPQoaFHgycujHEu/he05ymJraISQm5s+yR2koTXX6OCfnWNTipdrhuyBIB1IX
         U7xOtjuoL613xYIITDwipJGCFqnAC3hpJU3XICBkq308qnjSHnyOZ5q9IoERCu06kDu1
         U8LZLFHLxVHBUP7wysgQJpR1Ykbzv5arkJyfI8RXKMIIfdvm/M4m6gi16ArzJUVQR0Tc
         jWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ozl2+3CNbOGcFgir3rEQ41Ac/ijTRZdlB8u+sHLq/PU=;
        b=byN+Z8hl6tlVc88pawqEPfnXsDiDc3XdFepnamRUGs+MF9rkQDzm6W039+uFcFAvbM
         0/7u9XI3qynH6bCiN4Kc8Wed2fJ0Aw5yy6B4ZRXLEXrEED5iU/LpP9VrIeV+lvVjPNZI
         64Bq2tbg0AAvYfdkHfKHRtps9Str6s34ddhkecjGlXyvpb+OG+qDR/Nx2J3g/7AsSyj7
         4XlfFrKjYe+dAV/9mwSVCUEvs4bvwq4voBjI+MtdpJ/MogxFA/h7xGC0UV9Kb29pnW6y
         7VFaGbAo1bKQs2eTTmdVL9vSL89b2r2CxoDsCql7zvWc2soA41Fyv+Vso/Ao8Ls+wGKN
         8UiA==
X-Gm-Message-State: AFqh2kqepWHf/BtWysaqSmK4jmEJeuP1LG84Sm/TstQwMZHFJK+ZKLlP
        GTtIHwAzvvJv+HkBkaeHWMdXpQ==
X-Google-Smtp-Source: AMrXdXtsaeyZlGTv/luap7T8pJe4YCKPzx42PwHQd4av3DZicesWp5D6xfw5sNzQkMLcggymi1JGZw==
X-Received: by 2002:a17:906:9e06:b0:84d:35e1:2781 with SMTP id fp6-20020a1709069e0600b0084d35e12781mr5356332ejc.46.1673265103679;
        Mon, 09 Jan 2023 03:51:43 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id y10-20020a170906070a00b0084ca4277a81sm3722993ejb.95.2023.01.09.03.51.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 03:51:43 -0800 (PST)
Message-ID: <95f8b774-0b00-88dd-b890-2737d8a70592@blackwall.org>
Date:   Mon, 9 Jan 2023 13:51:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 net-next 01/15] net: bridge: mst: Multiple Spanning
 Tree (MST) mode
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-2-tobias@waldekranz.com> <Y7vK4T18pOZ9KAKE@shredder>
 <20230109100236.euq7iaaorqxrun7u@skbuf> <Y7v98s8lC1WUvsSO@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <Y7v98s8lC1WUvsSO@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2023 13:43, Ido Schimmel wrote:
> On Mon, Jan 09, 2023 at 12:02:36PM +0200, Vladimir Oltean wrote:
>> On Mon, Jan 09, 2023 at 10:05:53AM +0200, Ido Schimmel wrote:
>>>> +	if (on)
>>>> +		static_branch_enable(&br_mst_used);
>>>> +	else
>>>> +		static_branch_disable(&br_mst_used);
>>>
>>> Hi,
>>>
>>> I'm not actually using MST, but I ran into this code and was wondering
>>> if the static key usage is correct. The static key is global (not
>>> per-bridge), so what happens when two bridges have MST enabled and then
>>> it is disabled on one? I believe it would be disabled for both. If so,
>>> maybe use static_branch_inc() / static_branch_dec() instead?
>>
>> Sounds about right. FWIW, br_switchdev_tx_fwd_offload does use
>> static_branch_inc() / static_branch_dec().
> 
> OK, thanks for confirming. Will send a patch later this week if Tobias
> won't take care of it by then. First patch will probably be [1] to make
> sure we dump the correct MST state to user space. It will also make it
> easier to show the problem and validate the fix.
> 
> [1]
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 4f5098d33a46..f02a1ad589de 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -286,7 +286,7 @@ int br_boolopt_get(const struct net_bridge *br, enum br_boolopt_id opt)
>  	case BR_BOOLOPT_MCAST_VLAN_SNOOPING:
>  		return br_opt_get(br, BROPT_MCAST_VLAN_SNOOPING_ENABLED);
>  	case BR_BOOLOPT_MST_ENABLE:
> -		return br_opt_get(br, BROPT_MST_ENABLED);
> +		return br_mst_is_enabled(br);
>  	default:
>  		/* shouldn't be called with unsupported options */
>  		WARN_ON(1);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 75aff9bbf17e..7f0475f62d45 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1827,7 +1827,7 @@ static inline bool br_vlan_state_allowed(u8 state, bool learn_allow)
>  /* br_mst.c */
>  #ifdef CONFIG_BRIDGE_VLAN_FILTERING
>  DECLARE_STATIC_KEY_FALSE(br_mst_used);
> -static inline bool br_mst_is_enabled(struct net_bridge *br)
> +static inline bool br_mst_is_enabled(const struct net_bridge *br)
>  {
>  	return static_branch_unlikely(&br_mst_used) &&
>  		br_opt_get(br, BROPT_MST_ENABLED);
> @@ -1845,7 +1845,7 @@ int br_mst_fill_info(struct sk_buff *skb,
>  int br_mst_process(struct net_bridge_port *p, const struct nlattr *mst_attr,
>  		   struct netlink_ext_ack *extack);
>  #else
> -static inline bool br_mst_is_enabled(struct net_bridge *br)
> +static inline bool br_mst_is_enabled(const struct net_bridge *br)
>  {
>  	return false;
>  }

Ack, good catch. This should've been _inc/_dec indeed.

Thanks,
 Nik

