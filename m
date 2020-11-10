Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA562AE2B3
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbgKJWLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgKJWLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:11:13 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A3C0613D1;
        Tue, 10 Nov 2020 14:11:13 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so122229pfb.10;
        Tue, 10 Nov 2020 14:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q2OsGc+M8Y5uJFFnZ63LMAaBRTnU7xO8cXD4dBAmRGk=;
        b=pueezq2cOg7RflrYZuRnHnQRX6nIxd8p5nWPlfeChjXVcm/rWBzPudT+bTU9EAoA59
         gm6Zn2WxMLeT3HyXmH4z8c9thxztitdY5itMQ8Nm5B+8ZFWSv4sBq807NlDj/B2xFjyL
         Lhwl2Yq0s9EyVZsgSU6UnGqJiu8tAxUMXXVeemml19VDwiQNm8MqSkaROOuY8ZDyPiGG
         cPHGbCE0kvAiSWYLB3BDQO993jLtJinZjv0gxLK+GUnEeVTEOjTTQ065hp27FYum5wH/
         MRSxBUi3uVI7aon/ELd7XWgX+vzG1bIyskIRexto1LoAyx3XDy4Igym8nDc2xENONpwT
         j50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=q2OsGc+M8Y5uJFFnZ63LMAaBRTnU7xO8cXD4dBAmRGk=;
        b=aB8+DCYIIo/zIIavmNGtk+TcpFkMFMOBXAZ2O3Ut5IhzKAzyReYkuGYkvBqXrGskEO
         gG5z1V5M6nOe5wZJ95FabQ0g0ynVzvc6/9wfHnlUmNh+iPjfqsqFaO8PErOnC0WJ+fI9
         j2zusvpNFon5ja4lwWaOa9FgM6htSKXB4YY9VyxQgq6EOSmQ3l1nbW7qX+mreu58LNGY
         Rpn9O5Q1ss4nc3SxQa12gy470HQMaGYLs5AXNH4Aws1VrsTM3x2jLbJXvr2BHpL7PIC9
         5dl7uz9JHIu5YpAZKhi9/eTNaVjpetBgQm1O0vqxDuzgAFgZ7ItMnYSd0+WEdorf3jSr
         1y2w==
X-Gm-Message-State: AOAM531APjGFn5hKngMcpxE7iTE7lf4sCs4MTJSXx/oTXyNLvEISyqwQ
        /8FGnh2iT7L3lRCk1EZVYLw=
X-Google-Smtp-Source: ABdhPJym7+IFUpjz91iqf3PpeHhEsftOwrU0molmxKQUeab2w7c+NApYPjMe6EqccFm1HugsoRXRcg==
X-Received: by 2002:a62:3:0:b029:160:d92:2680 with SMTP id 3-20020a6200030000b02901600d922680mr20132236pfa.44.1605046273056;
        Tue, 10 Nov 2020 14:11:13 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e7sm122179pfn.180.2020.11.10.14.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 14:11:12 -0800 (PST)
Subject: Re: [PATCH 04/10] ARM: dts: BCM5301X: Add a default compatible for
 switch node
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BROADCOM IPROC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
 <20201110033113.31090-5-f.fainelli@gmail.com>
 <20201110220647.r5ol44etxa7xxql3@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <ecc553e9-ec4a-661e-f6bf-b0314242b5c5@gmail.com>
Date:   Tue, 10 Nov 2020 14:11:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110220647.r5ol44etxa7xxql3@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20 2:06 PM, Vladimir Oltean wrote:
> On Mon, Nov 09, 2020 at 07:31:07PM -0800, Florian Fainelli wrote:
>> Provide a default compatible string which is based on the 53010 SRAB
>> compatible, this allows us to have sane defaults and silences the
>> following warnings:
>>
>> arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml:
>> ethernet-switch@18007000: compatible: 'oneOf' conditional failed, one
>> must be fixed:
>>         ['brcm,bcm5301x-srab'] is too short
>>         'brcm,bcm5325' was expected
>>         'brcm,bcm53115' was expected
>>         'brcm,bcm53125' was expected
>>         'brcm,bcm53128' was expected
>>         'brcm,bcm5365' was expected
>>         'brcm,bcm5395' was expected
>>         'brcm,bcm5389' was expected
>>         'brcm,bcm5397' was expected
>>         'brcm,bcm5398' was expected
>>         'brcm,bcm11360-srab' was expected
>>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm53010-srab',
>> 'brcm,bcm53011-srab', 'brcm,bcm53012-srab', 'brcm,bcm53018-srab',
>> 'brcm,bcm53019-srab']
>>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm11404-srab',
>> 'brcm,bcm11407-srab', 'brcm,bcm11409-srab', 'brcm,bcm58310-srab',
>> 'brcm,bcm58311-srab', 'brcm,bcm58313-srab']
>>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm58522-srab',
>> 'brcm,bcm58523-srab', 'brcm,bcm58525-srab', 'brcm,bcm58622-srab',
>> 'brcm,bcm58623-srab', 'brcm,bcm58625-srab', 'brcm,bcm88312-srab']
>>         'brcm,bcm5301x-srab' is not one of ['brcm,bcm3384-switch',
>> 'brcm,bcm6328-switch', 'brcm,bcm6368-switch']
>>         From schema:
>> Documentation/devicetree/bindings/net/dsa/b53.yaml
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
> 
> Nice, I didn't know DSA supported the switch inside this device. In the
> default AsusWRT, the switch is well hidden from the kernel :)

Yeah right :) The YAML validation works even when the nodes are
disabled, so we somehow need to account for all of these devices' DTS.

> 
> Not that it makes any difference as far as I can see, but how do you
> know this a BCM53010 SRAB specifically?

The 4708 is effectively a 53010 which is why this is valid as a
fallback. Any node that defines switch ports and uses a SoC different
than the 53010 should use an appropriate "compatible" string though.
That's what is done for NSP.
--
Florian
