Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9157423144D
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgG1U4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgG1U4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:56:20 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F4EC061794;
        Tue, 28 Jul 2020 13:56:20 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l64so13337284qkb.8;
        Tue, 28 Jul 2020 13:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xTtHy9/c6ZBsZFsSxoQEUXy91p7zwnAUVyWXvNzOO+k=;
        b=r0s22kHNXiDC78C9qXsW/tM5+sD0iBs2+BNRNvnK2CVmW8y+Evx2khFkpLf0sNIxA9
         n0//0TiaYlqezSWKQNfii4zTgk8XNgzIuk/Wxd4y1PwGJkeVXYtTxOkXovhr/OAD83WR
         0Rtl5zmfSrD3JY5EdMBO3gkBDo3Q3B+tzwJygrJCfgPWyiHD8ip8Plf42pUJyLgiVA45
         w8ICodSd8LG6wgksKi0UW1p8m3087zTMKaAtFiZ1RdUrnBHCS6n07mJ11iQFeaMsob7E
         /LVMfQ9ZgfnSykho8Y1EWcSGfFIrC2P0Tu6kAJoeexnr6hC6yOdwYgAUsbdh7gDEIYMU
         EFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xTtHy9/c6ZBsZFsSxoQEUXy91p7zwnAUVyWXvNzOO+k=;
        b=uScQzLIJCe1vX2V/QhsW7SbM8evnkkbqKJUqD+KOsuCG7DxG4xNhBrWaHYmuFNBrU0
         d31OQmC6kZ7kNK3k8oSLUj5Ph14J41Y5u12Ug+hfIhJI0NBqxlUvAL5VMNRUp1xVVwFo
         tO8S69FPfZlMmuIAEQZ1zXtq3omkwT3kjn00m5xbpjLiMcqKNc1CTkV0vGksQP6gEuFE
         AR0NzZpSbFmNs0RxW0bUB9g+gq5PiDDMjikY+hP6lQVzjsWU2TCRCki9kZUj/INWYlcR
         SKQvJj+gxtI05+VV8XolSxGZSW37z+lmmxh7rIrV++32Jv91qTrvvq1MFEXN9dmVaWvC
         wvRA==
X-Gm-Message-State: AOAM532fQ3+UGULBCq0shonfUTKj0R51GKRqYKMOm55kj+QPyNpD7F3s
        uuLogZ5YJOhflAtX/B07YMn47YCI
X-Google-Smtp-Source: ABdhPJzghDw6XbjmAxhs/3QUFzY7PaXJvyqhSbu/ZALMF+9PzGxMWMdFPWNpEbLquOmMtYLaGd+Atg==
X-Received: by 2002:a37:ae03:: with SMTP id x3mr25945186qke.313.1595969779390;
        Tue, 28 Jul 2020 13:56:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x198sm1361969qka.37.2020.07.28.13.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 13:56:18 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Andrew Lunn <andrew@lunn.ch>,
        Dan Callaghan <dan.callaghan@opengear.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <20200728204548.GC1748118@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7d42152a-2df1-a26c-b619-b804001e0eac@gmail.com>
Date:   Tue, 28 Jul 2020 13:56:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728204548.GC1748118@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 1:45 PM, Andrew Lunn wrote:
> On Tue, Jul 28, 2020 at 06:06:26PM +1000, Dan Callaghan wrote:
>> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
>>> Now i could be wrong, but are Ethernet switches something you expect
>>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
>>> escape hatch?
>>
>> As an extra data point: right now I am working on an x86 embedded 
>> appliance (ACPI not Device Tree) with 3x integrated Marvell switches. 
>> I have been watching this patch series with great interest, because 
>> right now there is no way for me to configure a complex switch topology 
>> in DSA without Device Tree.
>>
>> For the device I am working on, we will have units shipping before these 
>> questions about how to represent Ethernet switches in ACPI can be 
>> resolved. So realistically, we will have to actually configure the 
>> switches using software_node structures supplied by an out-of-tree 
>> platform driver, or some hackery like that, rather than configuring them 
>> through ACPI.
> 
> Hi Dan
> 
> I also have an x86 platform, but with a single switch. For that, i
> have a platform driver, which instantiates a bit banging MDIO bus, and
> sets up the switch using platform data. This works, but it is limited
> to internal Copper only PHYs.

At some point I had a dsa2_platform_data implementation which was
intended to describe more complex switch set-ups and trees, the old code
is still there for your entertainment:

https://github.com/ffainelli/linux/commits/dsa-pdata

> 
>> An approach I have been toying with is to port all of DSA to use the 
>> fwnode_handle abstraction instead of Device Tree nodes, but that is 
>> obviously a large task, and frankly I was not sure whether such a patch 
>> series would be welcomed.
> 
> I would actually suggest you look at using DT. We are struggling to
> get ACPI maintainers involved with really simple things, like the ACPI
> equivalent of a phandle from the MAC to the PHY. A full DSA binding
> for Marvell switches is pretty complex, especially if you need SFP
> support. I expect the ACPI maintainers will actively run away
> screaming when you make your proposal.
> 
> DT can be used on x86, and i suspect it is a much easier path of least
> resistance.

And you can easily overlay Device Tree to an existing system by using
either a full Device Tree overlay (dtbo) or using CONFIG_OF_DYNAMIC and
creating nodes on the fly.
-- 
Florian
