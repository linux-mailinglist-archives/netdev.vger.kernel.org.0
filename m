Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4032317F9
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 05:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgG2DQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 23:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgG2DQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 23:16:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AF6C061794;
        Tue, 28 Jul 2020 20:16:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l63so13486952pge.12;
        Tue, 28 Jul 2020 20:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ywK747JDOEOIO7uLBlkw5scwdQUfUFqa3AkODA0Zy7I=;
        b=OqR3nhqAlefVapMdMLEPIo38g4x1soDoHTqSDtvt9wX2fRNcGgcJVuHdYYPW1Q6Uzl
         IdIzrnaD97UeQvlswkB0GTetOXLz9f8uiJiCE4qhDGHISZJKPwc33F2gdd2yXON2Uor2
         PXSZSpz9rK60hz8a5EtMioV7HWcWC8GiZuI8MR5TlMJctrrtyyHAleGdeTdwdXkjguxj
         4ta0T8NMYJ9YYCQkchggJfv8f26kv5gBxGawgnEbOkF5PkaHw8o3ZpwarDqwa4rrUpV7
         oSnlCc1HwOI3DuHguXFemtTBT7gpOllAvZcQCVlAA2bIxkBCNyMpy2+QJ2Siem5JPmB3
         Tfbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ywK747JDOEOIO7uLBlkw5scwdQUfUFqa3AkODA0Zy7I=;
        b=MCMpRaA7dH4A1LFza8GUr/yrQbi205MKPpBuOctSW10JuEGhDZ+vd534Z2BRqz04fF
         gJkQhtWq8vZdB0nGIVCeZZwmJzmbfnZIKjLXLXJrc/N/O1N+CNpSK4ePzHoxGUg4q3E0
         wLIY90Iq0mp5QBwcfH4qSW8IaU2fCG6UZnt5fhDQeECZwoLaDFN4jThOmDynQi23eSZY
         zSLgewUv6CH1nH1o6TepJlIb2+4KOQVhVI6PCd2hv45yeffoisWYOHdng+bkLkTsGrXM
         HjkmCf3zXsctCwkwd8ssIX9obXL+sIj0or5KXT6eNwhp74N1hKVIDIBQ5oh7fjh7vSt7
         bu7g==
X-Gm-Message-State: AOAM531L2M07yT2+dfl03uOkg7w4zjflaEMlhuCuDecBm2175RQfD+SZ
        mTXbPhHfHUmBJXCAPuJr/pn8dhU5
X-Google-Smtp-Source: ABdhPJw3MgIHY4Y6AWlTAiz3md63IUHfXtaj9eKMHadlITV83MhGEWlRFpJ30dPizLsah5coqB/fQw==
X-Received: by 2002:a63:1d5e:: with SMTP id d30mr26984123pgm.179.1595992594020;
        Tue, 28 Jul 2020 20:16:34 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e9sm435830pfh.151.2020.07.28.20.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 20:16:33 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
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
 <9e63aabf-8993-9ce0-1274-c29d7a5fc267@arm.com>
 <1e4301bf-cbf2-a96b-0b76-611ed08aa39a@gmail.com>
 <f046fa8b-6bac-22c3-0d9f-9afb20877fc9@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f9912ea2-2026-a2b3-3a1f-99cc479f1f9b@gmail.com>
Date:   Tue, 28 Jul 2020 20:16:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f046fa8b-6bac-22c3-0d9f-9afb20877fc9@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 7:53 PM, Jeremy Linton wrote:
> Hi,
> 
> On 7/28/20 7:39 PM, Florian Fainelli wrote:
>> On 7/28/2020 3:30 PM, Jeremy Linton wrote:
>>> Hi,
>>>
>>> On 7/28/20 3:06 AM, Dan Callaghan wrote:
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
>>>
>>> DSA though, the switch is hung off a normal MAC/MDIO, right? (ignoring
>>> whether that NIC/MAC is actually hug off PCIe for the moment).
>>
>> There is no specific bus, we have memory mapped, MDIO, SPI, I2C swiches
>> all supported within the driver framework right now.
>>
>>>
>>> It just has a bunch of phy devices strung out on that single MAC/MDIO.
>>
>> It has a number of built-in PHYs that typically appear on a MDIO bus,
>> whether that bus is the switch's internal MDIO bus, or another MDIO bus
>> (which could be provided with just two GPIOs) depends on how the switch
>> is connected to its management host.
>>
>> When the switch is interfaced via MDIO the switch also typically has a
>> MDIO interface called the pseudo-PHY which is how you can actually tap
>> into the control interface of the switch, as opposed to reading its
>> internal PHYs from the MDIO bus.
>>
>>> So in ACPI land it would still have a relationship similar to the one
>>> Andrew pointed out with his DT example where the eth0->mdio->phy are all
>>> contained in their physical parent. The phy in that case associated with
>>> the parent adapter would be the first direct decedent of the mdio, the
>>> switch itself could then be represented with another device, with a
>>> further string of device/phys representing the devices. (I dislike
>>> drawing acsii art, but if this isn't clear I will, its also worthwhile
>>> to look at the dpaa2 docs for how the mac/phys work on this device for
>>> contrast.).
>>
>> The eth0->mdio->phy relationship you describe is the simple case that
>> you are well aware of which is say what we have on the Raspberry Pi 4
>> with GENET and the external Broadcom PHY.
>>
>> For an Ethernet switch connected to an Ethernet MAC, we have 4 different
>> types of objects:
>>
>> - the Ethernet MAC which sits on its specific bus
>>
>> - the Ethernet switch which also sits on its specific bus
>>
>> - the built-in PHYs of the Ethernet switch which sit on whatever
>> bus/interface the switch provides to make them accessible
>>
>> - the specific bus controller that provides access to the Ethernet switch
>>
>> and this is a simplification that does not take into account Physical
>> Coding Sublayer devices, pure MDIO devices (with no foot in the Ethernet
>> land such as PCIe, USB3 or SATA PHYs), SFP, SFF and other pluggable
>> modules.
> 
> Which is why I've stayed away from much of the switch discussion. There
> are a lot of edge cases to fall into, because for whatever reason
> networking seems to be unique in all this non-enumerable customization
> vs many other areas of the system. Storage, being an example i'm more
> familiar with which has very similar problems yet, somehow has managed
> to avoid much of this, despite having run on fabrics significantly more
> complex than basic ethernet (including running on a wide range of hot
> pluggable GBIC/SFP/QSFP/etc media layers).
> 
> ACPI's "problem" here is that its strongly influenced by the "Plug and
> Play" revolution of the 1990's where the industry went from having
> humans describing hardware using machine readable languages, to hardware
> which was enumerable using standard protocols. ACPI's device
> descriptions are there as a crutch for the remaining non plug an play
> hardware in the system.
> 
> So at a basic level, if your describing hardware in ACPI rather than
> abstracting it, that is a problem.

I suppose that is a good summary, my impression from this patch series
is that we want the description part, not the abstraction, whether it is
on purpose or because there is a misunderstanding of what ACPI is
intended for, or higher powers have decided this must be done otherwise
nothing gets sold, who knows?
-- 
Florian
