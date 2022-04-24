Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0654350D56A
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 23:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbiDXVzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 17:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiDXVzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 17:55:45 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824883B281
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 14:52:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y21so9491869edo.2
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 14:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HtsX7xXS5KyrSdS4F8RNS0VhDr01GCN2iAGgDFc6qBs=;
        b=Bk78u/NaLlBh/+udP1b42wGjGXL+P807SEn3bt4RGvsZ6lVNKA9vUhLUIDtJu4SHO9
         T9/5Z7yK5+CdL++dKToG8H03+Ijpr644TnAzeuf9hCa+Ky3DfQxmNbQ5argOSQrrIU3U
         GtLq73xG7eQILwhJGkUrnG9H1nHp9VbOLtGWDH+J8duVnfd4noatHsIok+vlhVQxcBwV
         fU1Niw1hMc/3HNwc+i2lL1L6woChrXpSTZvUa1Z58wx1w8zInanQQoj7M88+ZRlDn2Dj
         PAvZYWy4uvkiXgYhKbE7+XzaWRy0A+uRrdNZTwRRDs7joSr1nBCKZ/TZFLMqIaVXcRHo
         le3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HtsX7xXS5KyrSdS4F8RNS0VhDr01GCN2iAGgDFc6qBs=;
        b=8DP6koIOmme8chD0W7HBaWS+x8XK1tju987/8KALEkArVHo6emVZRoKQxy81nHnMhg
         QUThhVgMXnJss/s/mrFqho1e3Rrlms+THRvPGL7SQ1mtY24fLpY5s9gpXTh+kqS1xtGo
         avG45MT/gEUHy6eaQlJd4h2le/d5XUmQwTRSEt8sS1YHnSeyuwhdPuKQw8SDY1Mic3UF
         XVq5HL99D//0fVeW88MVj+8fnC2g8aGbEcyHIAyw4Qlt/IBCcg0NRDXDXqh7kgnQ9I9j
         J2laE2nOm2bvTvkoWMWgf1sd5qhKRXZikhgHbXPR0AdTFM8ki7yMGQH5ywzSr2LninDu
         /ptQ==
X-Gm-Message-State: AOAM531tkmqFRugR8kNV3XueUHMA+lpADfTIC9wdNLIJL+7PnLa2ICFR
        hIj7z3R5fphD9oDaVHpPIDK5bg==
X-Google-Smtp-Source: ABdhPJxA/GkBOyzYFPNHFGGUbgZYaFFMjxcPjHcOGJU9afJPo3NAvQlf/gAy8hcMlADO4H+DYaO7FQ==
X-Received: by 2002:a05:6402:42d4:b0:416:5cac:a9a0 with SMTP id i20-20020a05640242d400b004165caca9a0mr15984539edc.86.1650837161997;
        Sun, 24 Apr 2022 14:52:41 -0700 (PDT)
Received: from [192.168.0.117] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id a94-20020a509ee7000000b00425e7035c4bsm619579edf.61.2022.04.24.14.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 14:52:41 -0700 (PDT)
Message-ID: <0f1e1250-920a-c7d1-900c-98ef3e0456d8@blackwall.org>
Date:   Mon, 25 Apr 2022 00:52:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
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
 <4bf69eef-7444-1238-0f4a-fb0fccda080c@blackwall.org>
 <3bcb2d3d-8b8b-8a8f-1285-7277394b4e6b@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <3bcb2d3d-8b8b-8a8f-1285-7277394b4e6b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/22 00:09, Alaa Mohamed wrote:
> 
> On ٢٤‏/٤‏/٢٠٢٢ ٢١:٥٥, Nikolay Aleksandrov wrote:
>> On 24/04/2022 22:49, Alaa Mohamed wrote:
>>> On ٢٤‏/٤‏/٢٠٢٢ ٢١:٠٢, Nikolay Aleksandrov wrote:
>>>> On 24/04/2022 15:09, Alaa Mohamed wrote:
>>>>> Add extack support to .ndo_fdb_del in netdevice.h and
>>>>> all related methods.
>>>>>
>>>>> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>>>>> ---
>>>>> changes in V3:
>>>>>           fix errors reported by checkpatch.pl
>>>>> ---
>>>>>    drivers/net/ethernet/intel/ice/ice_main.c        | 4 ++--
>>>>>    drivers/net/ethernet/mscc/ocelot_net.c           | 4 ++--
>>>>>    drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
>>>>>    drivers/net/macvlan.c                            | 2 +-
>>>>>    drivers/net/vxlan/vxlan_core.c                   | 2 +-
>>>>>    include/linux/netdevice.h                        | 2 +-
>>>>>    net/bridge/br_fdb.c                              | 2 +-
>>>>>    net/bridge/br_private.h                          | 2 +-
>>>>>    net/core/rtnetlink.c                             | 4 ++--
>>>>>    9 files changed, 12 insertions(+), 12 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c 
>>>>> b/drivers/net/ethernet/intel/ice/ice_main.c
>>>>> index d768925785ca..7b55d8d94803 100644
>>>>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>>>>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>>>> @@ -5678,10 +5678,10 @@ ice_fdb_add(struct ndmsg *ndm, struct 
>>>>> nlattr __always_unused *tb[],
>>>>>    static int
>>>>>    ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
>>>>>            struct net_device *dev, const unsigned char *addr,
>>>>> -        __always_unused u16 vid)
>>>>> +        __always_unused u16 vid, struct netlink_ext_ack *extack)
>>>>>    {
>>>>>        int err;
>>>>> -
>>>>> +
>>>> What's changed here?
>>> In the previous version, I removed the blank line after "int err;" 
>>> and you said I shouldn't so I added blank line.
>>>
>> Yeah, my question is are you fixing a dos ending or something else?
>> The blank line is already there, what's wrong with it?
> No, I didn't.
>>
>> The point is it's not nice to mix style fixes and other changes, more so
>> if nothing is mentioned in the commit message.
> Got it, So, what should I do to fix it?

Don't change that line? I mean I'm even surprised this made it in the 
patch. As I mentioned above, there is already a new line there so I'm 
not sure how you're removing it and adding it again. :)

Cheers,
  Nik
