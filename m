Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9036A53A271
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244114AbiFAKSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiFAKSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:18:18 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7619552E42
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 03:18:16 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id k19so1653559wrd.8
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 03:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IwWvhtTjYr+ClHbli2v9zYHeb4MlsNpBTNH8t1R848I=;
        b=GtPU/uwQD9b57QEgTl6NokCQd9GvrTQt1sIs8TPk5MeYHbuGQ/1idQzmZ2Yb7IVzLp
         bHF+TLzP44u05K82Wu9Po8riWCIBCjjunOt3hpYjYzdVfzkGASl2MrodRu6cpuCxnQhK
         2odSI3SDSStjxCaGMJF/PkLzEXiK1RRIi532veIgDmJjZVaHSzHcIFEj8Z7fgpmCupmp
         Gp1oxdrvHKCEhfqPguNSn7PwejuntjG6G+vW9TjhRUZfNIzISmeqHwLev0vIBzPLoL9P
         KsmvTtmoE+03QPRFY187ghGlBvV1XJWhfR/l9sl9SKyE48vWi71v461GoUKVwOD2vmF6
         l+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IwWvhtTjYr+ClHbli2v9zYHeb4MlsNpBTNH8t1R848I=;
        b=F8/AXwuJbyzyEHa7HZCDoKNt9ee1AVTmuMz0rVwowbqntnsM7ImfJ9AOI7q3694zpo
         CDld8UKGUlo6MzCcPrjHXjXA8je46rciqt5e7NGUPpZ4OKYx3GXZ2dVa4psrfcCvXeWz
         FFz9KbmJDmOUSRvGgDh/GafbBlalKz1Metst44bc7B3BbZy/zBMM22afbWUBWM30pP8R
         4qihXlllxhGD1Bd7Bx01Wt8QjebDAoR2bsdKnJCRNtRFoDXUt8rZlnsHmnXN9qrSt25b
         7UIfkUViK2UzcQHRqbGjfbm/F/n0FSv9cA3dzkbUs4kiWjVikvM4yVBrR6VQjubsATOz
         xQSQ==
X-Gm-Message-State: AOAM530dlIVZG5m6doNg5xOXghlXSS87UiJwPIY0ebRPrEfvD7Aa8pAl
        rjFevorZANDEKa+6Uq1k4TGXelFsyuheey6H
X-Google-Smtp-Source: ABdhPJwBa+M9aeZv9/Ogg5QJHUpAxgn7hncZ4hePZxAKj5Jc0ssXUSPMGxEAGta4j/iaCiDubg2y+Q==
X-Received: by 2002:a5d:5888:0:b0:20c:d66e:a637 with SMTP id n8-20020a5d5888000000b0020cd66ea637mr54478888wrf.215.1654078694923;
        Wed, 01 Jun 2022 03:18:14 -0700 (PDT)
Received: from [192.168.15.233] (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id y6-20020adfee06000000b0021004d7d75asm1223974wrn.84.2022.06.01.03.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 03:18:14 -0700 (PDT)
Message-ID: <7c70ab93-6d35-52f5-ab11-e3b4ecd622f2@solid-run.com>
Date:   Wed, 1 Jun 2022 13:18:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, rafal@milecki.pl
References: <20220509122938.14651-1-josua@solid-run.com>
 <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
 <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
 <20220511132221.pkvi3g7agjm2xuph@skbuf>
 <Ynu8ixB5cm3zy6Yx@shell.armlinux.org.uk>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <Ynu8ixB5cm3zy6Yx@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thank you for the examples below!
Stable names do help in some cases, but not in all.

I did some testing the other day with renaming network interfaces 
through the ip command:
ip link set dev eth8 down
ip link set dev eth12 down
ip link set eth12 name eth20
ip link set eth8 name eth12
ip link set eth20 name eth8
ip link set eth8 up
ip link set dev eth12 up

Swapping interface names like this seems a perfectly legal thing for 
userspace to do. I personally would in such case expect the previous LED 
assignment to move along with the name change, however this does not happen.
Instead after the interface rename, the LEDs are effectively swapped.

Further the netdev trigger implementation seems incorrect when you add 
network namespaces.
Two namespaces can each contain a device named eth0, but the netdev 
trigger does not look at the namespace id when matching events to 
triggers, just the name.

Is it intended for userspace to track interface renames and reassign LEDs?
Or should the trigger driver watch for name changes and adapt accordingly?

Finally I also noticed that the netdev trigger by default does not 
propagate any information to the LED.
All properties - link, rx, tx are 0.
Attempts at setting this by default through udev were widely unsuccessful:
E.g. before setting the trigger property to netdev, the device_name or 
link properties do not exist.
Therefore a rule that sets trigger and link and device at the same time 
does not function:
SUBSYSTEM=="leds", ACTION=="add|change", 
ENV{OF_FULLNAME}=="/leds/led_c1_at", ATTR{trigger}="netdev", 
ATTR{link}="1", ATTR{device_name}="eth0"

It appears necessary to use 2 rules, one that selects netdev, another 
one that chooses what property to show, e.g. link;
and finally some rule that tracks the netdev name and updates 
device_name property accordingly.
All while watching out for infinite loops because the property changes 
appear to trigger more change events, and e.g. setting trigger to netdev 
again causes another change event and resets the properties ...

I get the impression that this is very complex and might be described 
much better in device-tree, at least when a vendor makes explicit 
decisions to the purpose of each led.

Thee has been a recent patchset floating this list by Rafał Miłecki,
which I very much liked:
[PATCH RESEND PoC] leds: trigger: netdev: support DT "trigger-sources" 
property

It does allow declaring the relation from dpmac to led in dts as I would 
have expected.

In addition I believe there should be a way in dts to also set a default 
for what information to show, e.g.
default-function = "link";

And finally dynamic tracking of the interface name.

I would be willing to work on the last two ideas, if this is an 
acceptable approach.

Am 11.05.22 um 16:39 schrieb Russell King (Oracle):
> On Wed, May 11, 2022 at 01:22:22PM +0000, Ioana Ciornei wrote:
>> On Tue, May 10, 2022 at 12:44:41PM +0300, Josua Mayer wrote:
>>
>>> One issue is that the interfaces don't have stable names. It purely depends
>>> on probe order,
>>> which is controlled by sending commands to the networking coprocessor.
>>>
>>> We actually get asked this question sometimes how to have stable device
>>> names, and so far the answer has been systemd services with explicit sleep
>>> to force the order.
>>> But this is a different topic.
>>>
>>
>> Stable names can be achieved using some udev rules based on the OF node.
>> For example, I am using the following rules on a Clearfog CX LX2:
>>
>> [root@clearfog-cx-lx2 ~] # cat /etc/udev/rules.d/70-persistent-net.rules
>> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@7", NAME="eth7"
>> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@8", NAME="eth8"
>> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@9", NAME="eth9"
>> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@a", NAME="eth10"
>> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="fsl_dpaa2_eth", ENV{OF_FULLNAME}=="/soc/fsl-mc@80c000000/dpmacs/ethernet@11", NAME="eth17"
Yes this seems to work okay.
I feel that it is wrong for userspace to recognize particular dts nodes, 
but it *does* work.

> 
> Or by using systemd - for example, on the Armada 38x Clearfog platform,
> I use:
> 
> /etc/systemd/network/01-ded.link:
> [Match]
> Path=platform-f1070000.ethernet
> [Link]
> MACAddressPolicy=none
> Name=eno0
> 
> /etc/systemd/network/02-sw.link:
> [Match]
> Path=platform-f1030000.ethernet
> [Link]
> MACAddressPolicy=none
> Name=eno1
> 
> /etc/systemd/network/03-sfp.link:
> [Match]
> Path=platform-f1034000.ethernet
> [Link]
> MACAddressPolicy=none
> Name=eno2
> 

sincerely
Josua Mayer
