Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C715558CFBD
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbiHHVeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiHHVeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:34:25 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4C91AF3B;
        Mon,  8 Aug 2022 14:34:24 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id d10so1729451qvn.8;
        Mon, 08 Aug 2022 14:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=rZ8LBpmofhM8/rZSavis4mS3eKPM4qkFLstQtllSA1U=;
        b=F+P/o/ujMtiLDXPR+XsDB5sWe5fFOQsGqzryK8yu4rtseeSSRdW04AGGXWySCWdYiZ
         x4YMQw7NpPS/8qcJ61IxXjhlyv8B2eepVG2T+qlhcZoY5FJrmwJ4ScqF+jA4sr0iTXt+
         Pe5UXv3FfIVGJphtLvrYVhxDs6G5q4A0nRnkt0IFJeoaOyBeE+X+lefbj4Lpk8Hj1dUz
         mK5LYHNWzITY9A6moyh7yLxvaj9JdNgho02y94rUJDoD5C3nfq1c65X6HEedQn5lEhxt
         BBuAFyKIQ4S826Lk7b0/shA1bKRvfTHNtRTe0e0dLps/ECY6LqjlEH7J3qOzaDKKsatc
         4unQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=rZ8LBpmofhM8/rZSavis4mS3eKPM4qkFLstQtllSA1U=;
        b=S8xVfkVl2PRbV6Oo/RqJsghYOXgyE7xJO7r6JLyIVgdMMSDkW3NSNIXjbHkM7wJTco
         nc7NWxJuFJeqSrV+cfVunZ6EQLGq8YY8JssslgiOHdL6mhpG5MtCyRi78YinaubZDmM/
         aIX5hnBlUMVYNrjy2hHqrp/N9PEvlqcdO7V71aRlrDb2HsS4r+s07w6NaKc1QfdNnzcr
         0X2eOtT6K8J9fPGjIVGmTxAuH+7sdqsPYBmEbYWyY6Pe0HWOg3KcHQvxAS9PlZXG11D4
         P+unc48+DdpF5uRUPXSNFLW9QII3r0887uBwBOw05pH6HaHclRbMe7Q5t6hUUSJB2UiM
         F1fA==
X-Gm-Message-State: ACgBeo1lbDzJzRP+dvcmS8OCdM2YX6eLHHII7Jny53H2skpBWAG9g6zQ
        7k9Bfn7qNdY9tuHZwHGmLKuz9NimpQI=
X-Google-Smtp-Source: AA6agR6uqon5IylcUsqDV6jlhF8zqXelfguXeS9pCM9V+/AodoDct4man1lKe7UqSKdZ5Lg9ZuMRWw==
X-Received: by 2002:a05:6214:d0b:b0:47b:4d2b:fa53 with SMTP id 11-20020a0562140d0b00b0047b4d2bfa53mr4923619qvh.13.1659994463139;
        Mon, 08 Aug 2022 14:34:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h17-20020a05620a245100b006b942f4ffe3sm4609744qkn.18.2022.08.08.14.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 14:34:22 -0700 (PDT)
Message-ID: <60e9e7dd-9642-696b-3c83-43e042392cc9@gmail.com>
Date:   Mon, 8 Aug 2022 14:34:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <4edd83d8-e6d9-ad11-c1b1-078f556ea4f3@gmail.com>
 <CAJ+vNU32nZGvdZLnWfyW2OF4LtS=18v_kqjzN7pJuxjGWgkOmA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJ+vNU32nZGvdZLnWfyW2OF4LtS=18v_kqjzN7pJuxjGWgkOmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/22 14:28, Tim Harvey wrote:
> On Mon, Aug 8, 2022 at 2:19 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 8/8/22 12:57, Sean Anderson wrote:
>>> Hi Tim,
>>>
>>> On 8/8/22 3:18 PM, Tim Harvey wrote:
>>>> Greetings,
>>>>
>>>> I'm trying to understand if there is any implication of 'ethernet<n>'
>>>> aliases in Linux such as:
>>>>           aliases {
>>>>                   ethernet0 = &eqos;
>>>>                   ethernet1 = &fec;
>>>>                   ethernet2 = &lan1;
>>>>                   ethernet3 = &lan2;
>>>>                   ethernet4 = &lan3;
>>>>                   ethernet5 = &lan4;
>>>>                   ethernet6 = &lan5;
>>>>           };
>>>>
>>>> I know U-Boot boards that use device-tree will use these aliases to
>>>> name the devices in U-Boot such that the device with alias 'ethernet0'
>>>> becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
>>>> appears that the naming of network devices that are embedded (ie SoC)
>>>> vs enumerated (ie pci/usb) are always based on device registration
>>>> order which for static drivers depends on Makefile linking order and
>>>> has nothing to do with device-tree.
>>>>
>>>> Is there currently any way to control network device naming in Linux
>>>> other than udev?
>>>
>>> You can also use systemd-networkd et al. (but that is the same kind of mechanism)
>>>
>>>> Does Linux use the ethernet<n> aliases for anything at all?
>>>
>>> No :l
>>
>> It is actually used, but by individual drivers, not by the networking
>> stack AFAICT:
>>
>> git grep -E "of_alias_get_id\((.*), \"(eth|ethernet)\"\)" *
>> drivers/net/ethernet/broadcom/genet/bcmmii.c:           id =
>> of_alias_get_id(dn, "eth");
>> drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c:    plat->bus_id =
>> of_alias_get_id(np, "ethernet");
>> drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c:   plat->bus_id =
>> of_alias_get_id(np, "ethernet");
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:  plat->bus_id =
>> of_alias_get_id(np, "ethernet");
>>
>> There were discussions about using that alias to name ethernet network
>> devices in the past (cannot quite point to the thread), the current
>> consensus appears to be that if you use the "label" property (which was
>> primed by DSA) then your network device will follow that name, still not
>> something the networking stack does for you within the guts of
>> register_netdev().
> 
> Right, I recall several discussions and debates about this.
> 
> I did find a few references:
> - failed attempt at using dt for naming:
> https://patchwork.kernel.org/project/linux-arm-kernel/patch/1399390594-1409-1-git-send-email-boris.brezillon@free-electrons.com/
> - systemd predicatable interface names:
> https://systemd.io/PREDICTABLE_INTERFACE_NAMES/
> 
> I do find it odd that for DSA devices the port names are defined in dt
> yet the cpu uplink port can not be.

There is no network interface created for the CPU port on the switch 
side, and the other network device (named the DSA conduit) is just a 
conduit, so its name does not matter so much except for making sure that 
it is brought up before the DSA ports that are dependent upon it and 
that can be resolved via "ip link show (the interface after the '@'). It 
matter even less nowadays that it gets brought up automatically by any 
of the user facing ports of the DSA switch:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9d5ef190e5615a7b63af89f88c4106a5bc127974

> 
> The issue I was trying to work through is an IMX8MP board which has
> IMX8MP FEC as the cpu uplink port to a GbE switch and IMX8MP EQOS as
> an additional GbE. In this case the FEC enumerates first becoming eth0
> and the EQOS second becoming eth1. I wanted to make the EQOS eth0 as
> it is the first RJ45 on the board physically followed by
> lan1/lan2/lan3/lan4/lan5. While I can do this in U-Boot by controlling
> the aliases for fec/eqos the same doesn't work for Linux so it's not
> worth doing as that would add user confusion.

None of that should matter in Linux anymore however, the names of the 
Ethernet controller(s) connected to your switch have no significance, 
see above.

> 
> I have never liked the idea of using systemd to deal with network
> interface re-naming as that's just another dependency where embedded
> Linux users typically want to strip things down to the bare minimum.

Fair enough.
-- 
Florian
