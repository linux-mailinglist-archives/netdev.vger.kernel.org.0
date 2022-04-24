Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5F50D4EC
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 21:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbiDXT6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 15:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiDXT6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 15:58:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F0A814A0
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 12:55:15 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p18so11034341edr.7
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 12:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0EgzoIHWVkAfvNpSWOnmV5LtfT6ZJcYhH7++3XB+glE=;
        b=xQq3liiyVG1TK522MGl5jBLsfT/Uix5DJ3L1iQks/PUiduhaj0NF/URdGJsujPgbam
         hLbi8IT6w9lG9NEFjrvb1UR+ca1mCX4b1Qa0CVbMAeny61wANYKKF9H4J11T+QSnUlBA
         2l8hLqraXLvGyde7o9+APzhMhr3bL33Y+fT0z2fCfZIWjS+jC+OmP1EfZpvczGWyq1Z7
         Q0c4u1b3TdLlzdFuNAllSb77AKFMOjv3sPo5qKywJgVDxQaMebwYqhmm8497vdHoGQfR
         mzs5YY8oyumj/q4pmo14yIiCU20R9SOZBaFVepZFNOAUC0i6Vz0LA50TSIWTJyCFrgON
         8+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0EgzoIHWVkAfvNpSWOnmV5LtfT6ZJcYhH7++3XB+glE=;
        b=nE/n+8rOLH0GcI9Ii4ZSvpyEXcMVAy9R8wHfUw1QL2+wGg7RyV82VPVj4F/1Nb2+id
         n2+Q3L2GCZvzn36commQOt+nJ1lNWm9HMrFovpNIAr8L7M2VRQg093iv2DaaMY/nr+fj
         HvUFsIBjj/KO5tOB2ea4pd/Sv2z1uq26FXarHznQexgvgKX54qPSzIbJFEfInMbRXPrm
         2ne9/w4k4WuJjeBzx9lTiwcHz7WJgoUl+SxBFZjxgeG4bUaIW8kitwXqElTTVQvWYYFJ
         pwcdasU8gfQDupGdhwwkOEF8mBhzSDI8t7P3DfD1REF85GPMZYpd010nGSJ4NRY2EHRx
         RxXA==
X-Gm-Message-State: AOAM530xtXPpv2TIM/UcwbqXGSlwOvvWozlihPPN/2hptpKxtKpW2zfF
        Umf0IZAq0Tjsy7zfaOlHKsfv8A==
X-Google-Smtp-Source: ABdhPJz6ve1Rq1+ti2Su45rUdME4EcceTyNugTL4H+TaGplQOA859Ym6fFwT4XVgVKJqQLv4t58Z/g==
X-Received: by 2002:a50:8d8a:0:b0:423:d77b:a683 with SMTP id r10-20020a508d8a000000b00423d77ba683mr15397163edh.138.1650830113696;
        Sun, 24 Apr 2022 12:55:13 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id e26-20020a50a69a000000b00425c11446fasm3325897edc.3.2022.04.24.12.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 12:55:13 -0700 (PDT)
Message-ID: <4bf69eef-7444-1238-0f4a-fb0fccda080c@blackwall.org>
Date:   Sun, 24 Apr 2022 22:55:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 1/2] rtnetlink: add extack support in fdb del
 handlers
Content-Language: en-US
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com, jdenham@redhat.com,
        sbrivio@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        GR-Linux-NIC-Dev@marvell.com, bridge@lists.linux-foundation.org
References: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <c3a882e4fb6f9228f704ebe3c1fcace14ee6cdf2.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <7c8367b6-95c7-ea39-fafe-72495f343625@blackwall.org>
 <d89eefc2-664f-8537-d10e-6fdfbb6823ed@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <d89eefc2-664f-8537-d10e-6fdfbb6823ed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2022 22:49, Alaa Mohamed wrote:
> 
> On ٢٤‏/٤‏/٢٠٢٢ ٢١:٠٢, Nikolay Aleksandrov wrote:
>> On 24/04/2022 15:09, Alaa Mohamed wrote:
>>> Add extack support to .ndo_fdb_del in netdevice.h and
>>> all related methods.
>>>
>>> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>>> ---
>>> changes in V3:
>>>          fix errors reported by checkpatch.pl
>>> ---
>>>   drivers/net/ethernet/intel/ice/ice_main.c        | 4 ++--
>>>   drivers/net/ethernet/mscc/ocelot_net.c           | 4 ++--
>>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
>>>   drivers/net/macvlan.c                            | 2 +-
>>>   drivers/net/vxlan/vxlan_core.c                   | 2 +-
>>>   include/linux/netdevice.h                        | 2 +-
>>>   net/bridge/br_fdb.c                              | 2 +-
>>>   net/bridge/br_private.h                          | 2 +-
>>>   net/core/rtnetlink.c                             | 4 ++--
>>>   9 files changed, 12 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
>>> index d768925785ca..7b55d8d94803 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>> @@ -5678,10 +5678,10 @@ ice_fdb_add(struct ndmsg *ndm, struct nlattr __always_unused *tb[],
>>>   static int
>>>   ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
>>>           struct net_device *dev, const unsigned char *addr,
>>> -        __always_unused u16 vid)
>>> +        __always_unused u16 vid, struct netlink_ext_ack *extack)
>>>   {
>>>       int err;
>>> -
>>> +
>> What's changed here?
> 
> In the previous version, I removed the blank line after "int err;" and you said I shouldn't so I added blank line.
> 

Yeah, my question is are you fixing a dos ending or something else?
The blank line is already there, what's wrong with it?

The point is it's not nice to mix style fixes and other changes, more so
if nothing is mentioned in the commit message.

>>
>>>       if (ndm->ndm_state & NUD_PERMANENT) {
>>>           netdev_err(dev, "FDB only supports static addresses\n");
>>>           return -EINVAL;
>>> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
>>> index 247bc105bdd2..e07c64e3159c 100644
>>> --- a/drivers/net/ethernet/mscc/ocelot_net.c
>>> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
>>> @@ -774,14 +774,14 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
>>>
>>>   static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
>>>                      struct net_device *dev,
>>> -                   const unsigned char *addr, u16 vid)
>>> +                   const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
>>>   {
>>>       struct ocelot_port_private *priv = netdev_priv(dev);
>>>       struct ocelot_port *ocelot_port = &priv->port;
>>>       struct ocelot *ocelot = ocelot_port->ocelot;
>>>       int port = priv->chip_port;
>>>
>>> -    return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge);
>>> +    return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge, extack);
>>>   }
>>>
>>>   static int ocelot_port_fdb_dump(struct sk_buff *skb,
>>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>>> index d320567b2cca..51fa23418f6a 100644
>>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>>> @@ -368,7 +368,7 @@ static int qlcnic_set_mac(struct net_device *netdev, void *p)
>>>
>>>   static int qlcnic_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
>>>               struct net_device *netdev,
>>> -            const unsigned char *addr, u16 vid)
>>> +            const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
>>>   {
>>>       struct qlcnic_adapter *adapter = netdev_priv(netdev);
>>>       int err = -EOPNOTSUPP;
>>> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
>>> index 069e8824c264..ffd34d9f7049 100644
>>> --- a/drivers/net/macvlan.c
>>> +++ b/drivers/net/macvlan.c
>>> @@ -1017,7 +1017,7 @@ static int macvlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
>>>
>>>   static int macvlan_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
>>>                  struct net_device *dev,
>>> -               const unsigned char *addr, u16 vid)
>>> +               const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
>>>   {
>>>       struct macvlan_dev *vlan = netdev_priv(dev);
>>>       int err = -EINVAL;
>>> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
>>> index de97ff98d36e..cf2f60037340 100644
>>> --- a/drivers/net/vxlan/vxlan_core.c
>>> +++ b/drivers/net/vxlan/vxlan_core.c
>>> @@ -1280,7 +1280,7 @@ int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
>>>   /* Delete entry (via netlink) */
>>>   static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>>                   struct net_device *dev,
>>> -                const unsigned char *addr, u16 vid)
>>> +                const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
>>>   {
>>>       struct vxlan_dev *vxlan = netdev_priv(dev);
>>>       union vxlan_addr ip;
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index 28ea4f8269d4..d0d2a8f33c73 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>>> @@ -1509,7 +1509,7 @@ struct net_device_ops {
>>>                              struct nlattr *tb[],
>>>                              struct net_device *dev,
>>>                              const unsigned char *addr,
>>> -                           u16 vid);
>>> +                           u16 vid, struct netlink_ext_ack *extack);
>>>       int            (*ndo_fdb_dump)(struct sk_buff *skb,
>>>                           struct netlink_callback *cb,
>>>                           struct net_device *dev,
>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>> index 6ccda68bd473..5bfce2e9a553 100644
>>> --- a/net/bridge/br_fdb.c
>>> +++ b/net/bridge/br_fdb.c
>>> @@ -1110,7 +1110,7 @@ static int __br_fdb_delete(struct net_bridge *br,
>>>   /* Remove neighbor entry with RTM_DELNEIGH */
>>>   int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>>             struct net_device *dev,
>>> -          const unsigned char *addr, u16 vid)
>>> +          const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack)
>>>   {
>>>       struct net_bridge_vlan_group *vg;
>>>       struct net_bridge_port *p = NULL;
>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>> index 18ccc3d5d296..95348c1c9ce5 100644
>>> --- a/net/bridge/br_private.h
>>> +++ b/net/bridge/br_private.h
>>> @@ -780,7 +780,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>>>              const unsigned char *addr, u16 vid, unsigned long flags);
>>>
>>>   int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>> -          struct net_device *dev, const unsigned char *addr, u16 vid);
>>> +          struct net_device *dev, const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack);
>> This is way too long (111 chars) and checkpatch should've complained about it.
>> WARNING: line length of 111 exceeds 100 columns
>> #234: FILE: net/bridge/br_private.h:782:
>> +          struct net_device *dev, const unsigned char *addr, u16 vid, struct netlink_ext_ack *extack);
> 
> I will fix it.
> 
>>
>>>   int br_fdb_add(struct ndmsg *nlh, struct nlattr *tb[], struct net_device *dev,
>>>              const unsigned char *addr, u16 vid, u16 nlh_flags,
>>>              struct netlink_ext_ack *extack);
>>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>>> index 4041b3e2e8ec..99b30ae58a47 100644
>>> --- a/net/core/rtnetlink.c
>>> +++ b/net/core/rtnetlink.c
>>> @@ -4223,7 +4223,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
>>>           const struct net_device_ops *ops = br_dev->netdev_ops;
>>>
>>>           if (ops->ndo_fdb_del)
>>> -            err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
>>> +            err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid, extack);
>>>
>>>           if (err)
>>>               goto out;
>>> @@ -4235,7 +4235,7 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
>>>       if (ndm->ndm_flags & NTF_SELF) {
>>>           if (dev->netdev_ops->ndo_fdb_del)
>>>               err = dev->netdev_ops->ndo_fdb_del(ndm, tb, dev, addr,
>>> -                               vid);
>>> +                               vid, extack);
>>>           else
>>>               err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
>>>
>>> -- 
>>> 2.36.0
>>>

