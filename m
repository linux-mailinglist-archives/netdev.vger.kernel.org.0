Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A761D6D7E
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 23:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgEQVeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 17:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgEQVeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 17:34:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD78C061A0C;
        Sun, 17 May 2020 14:34:44 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x15so3985185pfa.1;
        Sun, 17 May 2020 14:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kyF8IOQE7W6RaFNrd3A439eTXBlZu7RYxbZN0PdGkwo=;
        b=ujD03q688dopVhWkRTMACVimoFKCFf5BW7fvP2gMiS48iUubk4LFRHVqPvvaWG5Xns
         B9zRnwZ3CepBLaKAeeSmzVoxrmgubGr90And0eag3GBBi6+uWqgyXdtwiqRTjhdrdQdc
         KDsRVzRPbUrz1g8VPcHk1A+Wt8Y9sch9M1fg15IIc8+5iiEvEJeipvK573BLEiwnS57o
         e6kWMxwBMgn/73ef/f7Ym9drOnwoNjDcN8FX6P1IsKud+e8jdAYNoywoCURecCYdr6Jq
         MXja3mzGCq6XXshXRqMkXpl9kt/Fwc12RPmAVpQjWxui2lbutJIatC6RgPtxwYcs6w+P
         ea5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kyF8IOQE7W6RaFNrd3A439eTXBlZu7RYxbZN0PdGkwo=;
        b=I8a2y2TgexyY7g/y4lvg8w1iD/iqb4M9OWvvJUhZUVK/WYMro+xfOfL29JJs0tCDwl
         /QKNGD+J9uwEdYqXdlh7EaktDDx/YJZbgZUwdmJQ3bW2V/oplWnWgma/7GCbwluSyQHI
         xe2j/sA9Efjh7OLv73ngZGnJn261GKZzPMyaVWJXJsKF+HZlL8k+yb8Gu93LotQAQ6d6
         08dDkL0vzE7xIrHtyZxcjMs2+HHfkxRLKU2AzZJ1VOVUtYbEQ2rGJgXIYKc5F8K2Pssa
         JXdN+ysPExv9lKednow4PkyFdwAtE8qkN9eGd/uLgjcKIS9/ZwDdO1QM8C0if6S2eMZk
         74AQ==
X-Gm-Message-State: AOAM532hLFfGlDff2/6fMxumKgKe1P99f/jORO1uNI/3Dg4ltr2rnVil
        /Aixy/TZCIg7zUBBdyDrYAb029oH
X-Google-Smtp-Source: ABdhPJzw0uC1MipBMp1WP30rI9ZwELKqshodGj+wsH87DKA8QNbPoUO35lNQrxBnUy4vYgapB5YS5w==
X-Received: by 2002:a63:1515:: with SMTP id v21mr8681824pgl.229.1589751282997;
        Sun, 17 May 2020 14:34:42 -0700 (PDT)
Received: from [192.168.1.2] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a136sm6984573pfa.99.2020.05.17.14.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 14:34:42 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: sja1105: disable rxvlan offload for
 the DSA master
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, eric.dumazet@gmail.com,
        jiri@mellanox.com, idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200512234921.25460-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fe112570-4f1a-be46-4624-7121a5c82007@gmail.com>
Date:   Sun, 17 May 2020 14:34:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512234921.25460-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/2020 4:49 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> On sja1105 operating in best_effort_vlan_filtering mode (when the TPID
> of the DSA tags is 0x8100), it can be seen that __netif_receive_skb_core
> calls __vlan_hwaccel_clear_tag right before passing the skb to the DSA
> packet_type handler.
> 
> This means that the tagger does not see the VLAN tag in the skb, nor in
> the skb meta data.
> 
> The patch that started zeroing the skb VLAN tag is:
> 
>    commit d4b812dea4a236f729526facf97df1a9d18e191c
>    Author: Eric Dumazet <edumazet@xxxxxxxxxx>
>    Date:   Thu Jul 18 07:19:26 2013 -0700
> 
>        vlan: mask vlan prio bits
> 
>        In commit 48cc32d38a52d0b68f91a171a8d00531edc6a46e
>        ("vlan: don't deliver frames for unknown vlans to protocols")
>        Florian made sure we set pkt_type to PACKET_OTHERHOST
>        if the vlan id is set and we could find a vlan device for this
>        particular id.
> 
>        But we also have a problem if prio bits are set.
> 
>        Steinar reported an issue on a router receiving IPv6 frames with a
>        vlan tag of 4000 (id 0, prio 2), and tunneled into a sit device,
>        because skb->vlan_tci is set.
> 
>        Forwarded frame is completely corrupted : We can see (8100:4000)
>        being inserted in the middle of IPv6 source address :
> 
>        16:48:00.780413 IP6 2001:16d8:8100:4000:ee1c:0:9d9:bc87 >
>        9f94:4d95:2001:67c:29f4::: ICMP6, unknown icmp6 type (0), length 64
>               0x0000:  0000 0029 8000 c7c3 7103 0001 a0ae e651
>               0x0010:  0000 0000 ccce 0b00 0000 0000 1011 1213
>               0x0020:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
>               0x0030:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233
> 
>        It seems we are not really ready to properly cope with this right now.
> 
>        We can probably do better in future kernels :
>        vlan_get_ingress_priority() should be a netdev property instead of
>        a per vlan_dev one.
> 
>        For stable kernels, lets clear vlan_tci to fix the bugs.
> 
>        Reported-by: Steinar H. Gunderson <sesse@xxxxxxxxxx>
>        Signed-off-by: Eric Dumazet <edumazet@xxxxxxxxxx>
>        Signed-off-by: David S. Miller <davem@xxxxxxxxxxxxx>
> 
> The patch doesn't say why "we are not really ready to properly cope with
> this right now", and hence why the best solution is to remove the VLAN
> tag from skb's that don't have a local VLAN sub-interface interested in
> them. And I have no idea either.
> 
> But the above patch has a loophole: if the VLAN tag is not
> hw-accelerated, it isn't removed from the skb if there is no VLAN
> sub-interface interested in it (our case). So we are hooking into the
> .ndo_fix_features callback of the DSA master and clearing the rxvlan
> offload feature, so the DSA tagger will always see the VLAN as part of
> the skb data. This is symmetrical with the ETH_P_DSA_8021Q case and does
> not need special treatment in the tagger.
> 
> If there was an API by which the dsa tag_8021q module would declare its
> interest in servicing VLANs 1024-3071, such that the packets wouldn't be
> classified as PACKET_OTHERHOST, and if that API wasn't as tightly
> integrated with the 8021q module as vlan_find_dev/vlan_group_set_device
> are, I would be interested in using it, but so far I couldn't find it.
> With this patch, even though the frames still are PACKET_OTHERHOST, at
> least the VLAN tag reaches far enough that the DSA packet_type handler
> sees and consumes it.

The approach seems fine to me, I have to admit I am equally confused 
about Eric's patch other than it being a stop gap measure for a problem 
that was observed.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

In case we have a DSA master that does support NETIF_F_HW_VLAN_CTAG_RX 
though we should probably ensure that we install a VLAN filter there 
too, which we do not do currently.
-- 
Florian
