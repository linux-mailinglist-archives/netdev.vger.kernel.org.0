Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2C4AFC39
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbiBIS5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241294AbiBIS4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:56:48 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7742DC050CEE;
        Wed,  9 Feb 2022 10:55:51 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id i21so4385987pfd.13;
        Wed, 09 Feb 2022 10:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H03g3i6GXgjxVbCGTOuoISvy5cVtGUQ/BV218pz6cW0=;
        b=Fqr6pbmQTvsoINaecveOiWLRmDJbIKdkGCN9s/+MsQZmK9DUvPh5fMTH3FJxfiGIsw
         YEcjfXI5seO0643HI4fG0PKFvtHmrQPkM+eiQXY9lzXrsQRwDjJnc9d8cfmZEe8hg5B2
         RuTs8XOny+9J1bm8Lr0vZtoZFKuW9eg9xBg4gzaP1q9dzZRoXvoOqylwF7z055BZSdJm
         ea1qTMl6Xsd2qm4a7C2D95fneNSR1SKXPdjMl7wGAXpIWsUY83MOt1Q9ijyQwJdU2L95
         wc1xAyLsSbdExATzCL1MB+h+LXaQnhRN0/egv7TvdeSMRj/pipaQQ9e4LoAVWwPhP4ix
         HPPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H03g3i6GXgjxVbCGTOuoISvy5cVtGUQ/BV218pz6cW0=;
        b=zkz3w7WNQDBdVYv7d4RZYN/7m/9eo3mZSs/KKo8cGxnxrsDcSAkHioBCqaeQWNyU2C
         nOsVHmeV4MejvdlBcJo8o4nJFBB1k4ZhzC7wDYBaN6sPkgwxbkrkhZ/4DMdx4g6FnqAw
         gWmOkpkzzo+714fJZivwApsm3MUKbL4GTULzz4y5hVLthA3G24OaQhMPlJ9D+styn0so
         /OMFSfQ1uDqSuqUZyrc+6pfTXKwDsAEzXddxs1eTsTXoFQ4HgB6zhNRwTSDNGwWm5K6U
         3OsraTfNX4Gl7bJGSFsxPtWhh1NKfLVhNsUy+Szzraao5CCz5USbMijt4VzYDFYBCeU2
         j0MQ==
X-Gm-Message-State: AOAM530kIU6RDHpr1suyrSVtUfKSNVIvlC7Wzf6a6uOX4ea6VASyhd2e
        Z8KGj3q11IH2JzY/CbiKvfh/L7rNpyA=
X-Google-Smtp-Source: ABdhPJwGSuJpXr2zMm4fXPFriRejO4ChziFxvPVliCkZlXQKNz7V0HOU/iuGtiJ/STDmm8ZVVgAuLA==
X-Received: by 2002:a63:86c8:: with SMTP id x191mr2931827pgd.362.1644432950500;
        Wed, 09 Feb 2022 10:55:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p1sm22045633pfh.98.2022.02.09.10.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 10:55:49 -0800 (PST)
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML
 schema
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Rob Herring <robh@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211228072645.32341-1-luizluca@gmail.com>
 <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
 <CAL_JsqJ4SsEzZz=JfFMDDUMXEDfybMZw4BVDcj1MoapM+8jQwg@mail.gmail.com>
 <87zgn0gf3k.fsf@bang-olufsen.dk> <YgP7jgswRQ+GR4P2@lunn.ch>
 <CAJq09z49EEMxtBTs9q0sg3nn0VrSi0M=DkQTJ_n=QmgTr1aonw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d5bdb281-6968-b80f-bfc0-ae35a12ebfff@gmail.com>
Date:   Wed, 9 Feb 2022 10:55:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAJq09z49EEMxtBTs9q0sg3nn0VrSi0M=DkQTJ_n=QmgTr1aonw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 2/9/22 10:43 AM, Luiz Angelo Daros de Luca wrote:
>>> However, the linux driver today does not care about any of these
>>> interruptions but INT_TYPE_LINK_STATUS. So it simply multiplex only
>>> this the interruption to each port, in a n-cell map (n being number of
>>> ports).
>>> I don't know what to describe here as device-tree should be something
>>> independent of a particular OS or driver.
>>
>> You shouldn't need to know what Linux does to figure this out.
> 
> The Linux driver is masquerading all those interruptions into a single
> "link status changed". If interrupts property is about what the HW
> sends to us, it is a single pin.
> 
>   interrupt-controller:
>    type: object
>    description: |
>      This defines an interrupt controller with an IRQ line (typically
>      a GPIO) that will demultiplex and handle the interrupt from the single
>      interrupt line coming out of one of the Realtek switch chips. It most
>      importantly provides link up/down interrupts to the PHY blocks inside
>      the ASIC.

The de-multiplexing is a software construct/operation, in fact, what the
GPIO line does is multiplex since the line is used as an output to the
next level interrupt controller it connects to.

> 
>    properties:
> 
>      interrupt-controller: true
> 
>      interrupts:
>        maxItems: 1
>        description:
>          A single IRQ line from the switch, either active LOW or HIGH
> 
>      '#address-cells':
>        const: 0
> 
>      '#interrupt-cells':
>        const: 1
> 
>    required:
>      - interrupt-controller
>      - '#address-cells'
>      - '#interrupt-cells'
> 
> Now as it is also an interrupt-controller, shouldn't I document what it emits?

The interrupt controller emits a single output towards the next level,
and you documented that already with these properties. If you want to go
ahead and define what the various interrupt bits map to within the
switch's interrupt controller, you can do that in an
include/dt-bindings/ header file, or you can just open code the numbers.
Up to you.

> I've just sent the new version and we can discuss it there.
> 
>>>  - one interrupt for the switch
>>>  - the switch is an interrupt-controller
>>>  - ... and is the interrupt-parent for the phy nodes.
>>
>> This pattern is pretty common for DSA switches, which have internal
>> PHYs. You can see this in the mv88e6xxx binding for example.
> 
> The issue is that those similar devices are still not in yaml format.

That does not mean we could not update dsa.yaml to list the
'interrupts', 'interrupt-controller' and '#interrupt-cells' properties
and just leave it to the individual YAML bindings to specify the shape
and size of those properties so they don't have to repeat them.
-- 
Florian
