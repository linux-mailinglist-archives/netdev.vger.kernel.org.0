Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C767452114B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbiEJJsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239132AbiEJJsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:48:42 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7D429B82A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 02:44:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t6so22992496wra.4
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 02:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MQakJRbtjUI60VUiNCSpnFiq/boSFyE6wnImHchq4jU=;
        b=3iVaYJ2HVmkrM0LEo9td5b0prs9qpnLtLQ5SESZRjN7ogDBOZR3RAWDr9rEEhyjcie
         1mLnlEEtijRW7ZukZvCnTXf1eNu7nMOxGqSqL51saRplZ4pa7Shu1M5nbUvdYNm2vUKz
         nJblolM0jryP0xJxCBSbJ/x+nnVYp/B9MKbJvo6teWa99ChlEZTDZjFFHDg1mBH+BH2B
         4VwchAjJ5r9zd9ItzSnAC9cCO5wtBnvjZUGJgFYPDfQNLAxt2ppZerpsU/nzsYu+pGNT
         QuYxvQt+6xL7yFvZrhtP8beMG0xfHlhMNyhCQezylPad1DCtxilwKKwsh+uqYiX8vZu9
         3/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MQakJRbtjUI60VUiNCSpnFiq/boSFyE6wnImHchq4jU=;
        b=uELBNd5fp70ZvVk6buuEBMVxWce5BiNcBRAG51Y3HKqGzpCTjCiOKt3UOv7NZ+3e3m
         nGn9Iz3t6XLasA8R/nJVtNDEamM3657NUfegekK/+5wXd7BEcGZpzuMMzTPHKFLf4vkb
         Feq2au37kxbf+szLiHCKEidQjaR9vX6TImQI2f5+3DXoVQCt1sfa3eWu19O7ESgTFodJ
         si9JWNiZNQUtHZJsTWAPFB8acsNgNjvGYyDQPTXBdzO/3waG+ieeyGqSz0avSH0MGEIK
         Nc34F040VQS1T9VUUmBFFaXlc3P4VMP1nlVp/xfwkqLUtBZdAF8c2iwNoitZP028quAB
         ZWmw==
X-Gm-Message-State: AOAM5306/Fa21UTVHU25Tl3FOKBiJ8RQislxCHvEvNSLRKmeEt5LFrDh
        Htf8DUArXPIH28Lyr6PSfcCwrj1LD663z9XV5Bs=
X-Google-Smtp-Source: ABdhPJyHEl/1mVp1HywFQ/A/HQZTLsMzlJXeUtltnPewwJ5z6qF0gCjNQcPu0aahc5EVJOrhISvCiQ==
X-Received: by 2002:a5d:5846:0:b0:20c:7407:5fa1 with SMTP id i6-20020a5d5846000000b0020c74075fa1mr17475033wrf.116.1652175883798;
        Tue, 10 May 2022 02:44:43 -0700 (PDT)
Received: from [192.168.17.225] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id a22-20020a1cf016000000b003942a244f4esm1972170wmb.39.2022.05.10.02.44.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 02:44:43 -0700 (PDT)
Message-ID: <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
Date:   Tue, 10 May 2022 12:44:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20220509122938.14651-1-josua@solid-run.com>
 <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Am 09.05.22 um 18:54 schrieb Russell King (Oracle):
> On Mon, May 09, 2022 at 03:29:38PM +0300, Josua Mayer wrote:
>> Dear Maintainers,
>>
>> I am working on a new device based on the LX2160A platform, that exposes
>> 16 sfp connectors, each with its own led controlled by gpios intended
>> to show link status.
>> This patch intends to illustrate in code what we want to achieve,
>> so that I can better ask you all:
>> How can this work with the generic led framework, and how was it meant to work?
>>
>> The paragraphs below are a discussion of paths I have explored without success.
>> Please let me know if you have any opinions and ideas.
>>
>> Describing in device-tree that an led node belongs to a particular network
>> device (dpmac) however seems impossible. Instead the standard appears to work
>> through triggers, where in device-tree one only annotates that the led should
>> show a trigger "netdev" or "phy". Both of these make no sense when multiple
>> network interfaces exist - raising the first question:
>> How can device-tree indicate that an individual led should show the events of
>> a particular network interface?
>>
>> We have found that there is a way in sysfs to echo the name of the network
>> device to the api of the led driver, and it will start showing link status.
>> However this has to be done at runtime by the user.
>> But network interface names are unstable. They depend on probe order and
>> can be changed at will. Further they can be moved to different namespaces,
>> which will allow e.g. two instances of "eth0" to coexist.
>> On the Layerscape platform in particular these devices are created dynamically
>> by the networkign coprocessor, which supports complex functions such as
>> creating one network interface that spans multiple ports.
>> It seems to me that the netdev trigger therefore can not properly reflect
>> the relation between an LED (which is hard-wired to an sfp cage), and the
>> link state reported by e.g. a phy inside an sfp module.
>>
>> There exists also a phy trigger for leds.
>> When invoking the phy_attach or phy_connect functions from the generic phy
>> framework to connect an instance of net_device with an instance of phy_device,
>> a trigger providing the link and speed events is registered.
>> You may notice that again leds are tied to existence of a particular logical
>> network interface, which may or may not exist, and may span multiple
>> physical interfaces in case of layerscape.
>> This is a dead end though, simply because the dpaa2 driver does not even use
>> objects of phy_device, so this registering of triggers never happens.
>>
>> In addition the dpmac nodes in device-tree don't really have a phy modeled.
>> One end are the serdes which are managed by the networking coprocessor.
>> The other end has removable sfp modules, which may or may not contain a phy.
>>
>> The serdes are modeled as phy in device-tree though, perhaps the dpaa2 driver
>> could be extended to instantiate phy_device objects for the serdes?
>> However I feel like this would especially not solve when mutliple physical
>> ports are used as one logical interface.
>>
>> It seems to me that there should be a way to explicitly link gpio-driven LEDs to
>> either specific phy nodes, or specific sfp connectors - and have them receive
>> link events from the respective phy, fully independent even from whether there
>> is a logical network interface.
>>
>> If you got here, thank you very much for reading!
>> Ay comments?
> You really don't need any of this.
>
> We already have the "netdev" trigger - you just need to assign the LED
> to the appropriate netdev link.
Yes, that is what we are doing at runtime now:
echo eth12 > /sys/class/leds/led_c1_at/device_name

I feared though (without testing) that this might break when interfaces 
are moved between namespaces, or renamed.
And it seemed wrong requiring the user to do explicitly make this 
assignment, when the purpose is very much fixed once you put a case 
around it and add some labels.

> I do this on the SolidSense platform with the two LEDs when using it as
> my internet gateway on the boat - one LED gives wlan status, the other
> LED gives wwan status, both of them green for link and red for tx/rx
> activity.
Ah. And do you put the assignment of the LEDs into an init script?
> Exactly the same can be done with SFPs if the net device is exclusive
> to the SFP socket.
One issue is that the interfaces don't have stable names. It purely 
depends on probe order,
which is controlled by sending commands to the networking coprocessor.

We actually get asked this question sometimes how to have stable device 
names, and so far the answer has been systemd services with explicit 
sleep to force the order.
But this is a different topic.

> Doing it this way also tells you that the netdev
> link is up, not just that a SFP has decided to deassert the RXLOS
> signals, which on some SFPs is tied inactive.
Good point, I have already noticed inconsistencies in this regard.
The information provided by the netdev trigger does seem superior.

We will try to adopt a solution based on what Andrew pointed me to, as 
that one appears to be a good way to describe this relationship between 
LEDs and MACs (by extension eth[0-9]+ interfaces).

> Thanks.

Thank you for your comments!

sincerely
Josua Mayer

