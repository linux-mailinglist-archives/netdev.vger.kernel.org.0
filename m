Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53048231505
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 23:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbgG1Vks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 17:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgG1Vkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 17:40:47 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631EFC061794;
        Tue, 28 Jul 2020 14:40:47 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s15so1416777pgc.8;
        Tue, 28 Jul 2020 14:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZYxJP0vWSlAnuUF1bVxleGQS1aIZxquOL1EnXMPqQD0=;
        b=arhL3GJvoRnuqRFtzVJzoRF/3QBc1b28EOU1O+IzXl4hSFZx12SLkIEncLuT/qpCvh
         nGJJgyUhD3obbvHQeMH8hr0tqxMm9Yhx/yoRI0Ih+qoV/p3UecIGpnBPC5a9oNzWQyEG
         deeLFe9lGHimCWEAaecTzxB4Unvzma3b7uXUGg2ACrT9mOjXszwTZFNyP5pbUwMHXCpd
         +E2yJDY/tSFbZm5UbcWYg6mvjwjM0kI07o9iQJ68zWULCXCGA8fJSToxKV38xLyNR96S
         aAFOr5EVZACSKWZO9JL1V0bH3qwjrHcv3BMcQ9JJxtO7D2JhvozT1quNdR1F17IJK3gs
         gTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZYxJP0vWSlAnuUF1bVxleGQS1aIZxquOL1EnXMPqQD0=;
        b=RZ+92ALKXP3MXemA0YrB4r6aXlJc/abBkjH7NvsPGgq+iJRO5T7U3utZH+9slLz/55
         CF0QiiyjTrZNdDLMZKGUKRyvDyH4u2zzE5BlXFHE0izzCoHPyOgj6N5a2J+2/nSN3tE/
         r3kNPlNj1IRt7hxc+WxS4RT6inqe1AP9cLS1KgWu4EW9qQHH2+JC3N/wNfiPaJIPNNV1
         Wq2Pl38t4F69svscuQDX/NHOEfZJC9ogKYIbHuW2mOHkOvC5c9+JiApEJKij2RsW+Cij
         EdQ6i4IyUbW0DtWWIoshPijgTl37aYn8CIZLVmdVh6BcC7H4p6tFwnQtGzhESw8jHshk
         OhyA==
X-Gm-Message-State: AOAM532NBMweHlknFD63RslQXFqEMzSqq9esktYyG6IqaVwCqPw5DjNh
        AoLDDDKG+2xeH+Zh6JPe4bmYwNNP
X-Google-Smtp-Source: ABdhPJwLBmKav8fLf4/K5SgjiBNZtbNFWuZbHEwo2tW7zazsLqUDe+3WStqMZbFDz43Klk8DFlYkiw==
X-Received: by 2002:a62:5443:: with SMTP id i64mr13827091pfb.313.1595972446190;
        Tue, 28 Jul 2020 14:40:46 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q83sm33884pfc.31.2020.07.28.14.40.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 14:40:45 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
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
 <7d42152a-2df1-a26c-b619-b804001e0eac@gmail.com>
 <CAHp75VejnW23LEfyEO6Py8=e3_W0YMomk8jQ3JQeHqYcaeDitg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dc2aed0e-e2e0-0229-e97e-cc5ac5957a4d@gmail.com>
Date:   Tue, 28 Jul 2020 14:40:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VejnW23LEfyEO6Py8=e3_W0YMomk8jQ3JQeHqYcaeDitg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 2:28 PM, Andy Shevchenko wrote:
> On Tue, Jul 28, 2020 at 11:56 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>> On 7/28/2020 1:45 PM, Andrew Lunn wrote:
>>> On Tue, Jul 28, 2020 at 06:06:26PM +1000, Dan Callaghan wrote:
>>>> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
>>>>> Now i could be wrong, but are Ethernet switches something you expect
>>>>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
>>>>> escape hatch?
>>>>
>>>> As an extra data point: right now I am working on an x86 embedded
>>>> appliance (ACPI not Device Tree) with 3x integrated Marvell switches.
>>>> I have been watching this patch series with great interest, because
>>>> right now there is no way for me to configure a complex switch topology
>>>> in DSA without Device Tree.
>>>>
>>>> For the device I am working on, we will have units shipping before these
>>>> questions about how to represent Ethernet switches in ACPI can be
>>>> resolved. So realistically, we will have to actually configure the
>>>> switches using software_node structures supplied by an out-of-tree
>>>> platform driver, or some hackery like that, rather than configuring them
>>>> through ACPI.
>>>
>>> Hi Dan
>>>
>>> I also have an x86 platform, but with a single switch. For that, i
>>> have a platform driver, which instantiates a bit banging MDIO bus, and
>>> sets up the switch using platform data. This works, but it is limited
>>> to internal Copper only PHYs.
>>
>> At some point I had a dsa2_platform_data implementation which was
>> intended to describe more complex switch set-ups and trees, the old code
>> is still there for your entertainment:
>>
>> https://github.com/ffainelli/linux/commits/dsa-pdata
> 
> Platform data in the modern kernel is definitely the wrong approach.
> Software nodes of firmware nodes can be much more appreciated.

Yes, yes, thank you. As you can see this was back from 2016 and it was
never submitted. The only viable alternative that I can think of, unless
the ACPI community at large finally decided to get its act together and
invest some serious efforts and time into understanding modern and
complex network topologies is to overlay a Device Tree onto a live system.

> 
>>>> An approach I have been toying with is to port all of DSA to use the
>>>> fwnode_handle abstraction instead of Device Tree nodes, but that is
>>>> obviously a large task, and frankly I was not sure whether such a patch
>>>> series would be welcomed.
>>>
>>> I would actually suggest you look at using DT. We are struggling to
>>> get ACPI maintainers involved with really simple things, like the ACPI
>>> equivalent of a phandle from the MAC to the PHY. A full DSA binding
>>> for Marvell switches is pretty complex, especially if you need SFP
>>> support. I expect the ACPI maintainers will actively run away
>>> screaming when you make your proposal.
>>>
>>> DT can be used on x86, and i suspect it is a much easier path of least
>>> resistance.
>>
>> And you can easily overlay Device Tree to an existing system by using
>> either a full Device Tree overlay (dtbo) or using CONFIG_OF_DYNAMIC and
>> creating nodes on the fly.
> 
> Why do you need DT on a system that runs without it and Linux has all
> means to extend to cover a lot of stuff DT provides for other types of
> firmware nodes?

Because ACPI is beyond useless at providing nearly the same level of
description as what DT can do today?

I am not trying to wage a war of DT is better than ACPI, but when it is
not even capable of describing a simple 1 to 1 mapping between an
Ethernet MAC and a PHY device sitting on an integrated or separate MDIO
bus, describing a full Ethernet switch fabric with 1 to 40 ports, each
with a variety of connectivity options, and you have an pressing need to
get your platform out to customers, then the choice is obvious.
-- 
Florian
