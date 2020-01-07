Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F84131EB6
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 05:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgAGE4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 23:56:20 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35534 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727605AbgAGE4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 23:56:19 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so27912076pgk.2
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 20:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T5ucd51yqPKjz5sQvY9YFKaCT/lonhO4bfI0C0aTcKc=;
        b=jdw1dKNaG/5lZakj2qmYhAk1Ex+fxweW5f3s+v+5jA+LvY2jE6i+RrKWAPBcEtJ1AE
         Jj0E4miQv/0UEm/U4LvnN3wH27AOZY+uzoHL8nIQDWZT5wmLhkvihHjTgenpzWHTiqqW
         lCKCsUfGkSxOsJO8HddOjyf9xsLCSun9WtPNAm2RY+keByH9LE5KU9ZosNVrcxilbuXC
         qxbgrWAFl4X0zN0cxojfH9SspOxgDKr+7OF7UIpiVxbq8MmecVs4yMB5i4po9oSft4J/
         xcMnStd/8CJr2YlzhIOFvpNskkI0HwE59oBsRa4uNkcogiqlKIBPEtf13SFqbe9Od+jE
         54tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=T5ucd51yqPKjz5sQvY9YFKaCT/lonhO4bfI0C0aTcKc=;
        b=c0ZgNBbKHok0Xtus49m68gxuTQYXgXG01oWMnyfEMWlpP31hndWHvGTO++Ri7+yHGU
         H+H0CeiI7fYOlklMunwJ0EVxvWw5hBlkKMMp77cniYvsNNUDRFGDmq5UOtoCEDda04tR
         vpORqYW8u+vQi4GOTl6epdc37n3JVvB9Q9iJlCiOST56nf4uTNEgePn6fxn9DrnCTqnY
         Q3sZX7UBF90EXnPIXo+MsSdXQtNIq0UuwI63T/zbeIFKRsKz9VsHem0r/50DZmV/NAXE
         FsEamdWjPGsEprLMtJQvQWFIKlOD9YaVnvmL7na+QHX8ZqGkD8Vh9x6ohfBFSAvkb1D1
         LCoQ==
X-Gm-Message-State: APjAAAV3IHJhgPi+YcCGKmZO2SKlubcI6aIP5P1VM5R49GjGr7RznCSx
        bsAGgQd1pp/ifxl2y7z7pA8=
X-Google-Smtp-Source: APXvYqwjyiOdd1cexeha/hjiHBdU3fABVPjPqsniTkL6/aFgkBXg3/+1xLHVI03Rh4SSCNY02Hfr6A==
X-Received: by 2002:a63:dc41:: with SMTP id f1mr117806862pgj.119.1578372978989;
        Mon, 06 Jan 2020 20:56:18 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id f8sm79440825pfn.2.2020.01.06.20.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2020 20:56:18 -0800 (PST)
Subject: Re: [PATCH v5 net-next 5/9] enetc: Make MDIO accessors more generic
 and export to include/linux/fsl
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20200106013417.12154-1-olteanv@gmail.com>
 <20200106013417.12154-6-olteanv@gmail.com>
 <8718ea22-d1aa-fe58-bd69-521eeee5190a@gmail.com>
 <CA+h21hotFQ9UbxbsQRk2TvTb4H27hfqYK+mX=3urqOoTnaLMDg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <86c9b320-bed5-a00b-24aa-494a1d7f91d0@gmail.com>
Date:   Mon, 6 Jan 2020 20:56:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hotFQ9UbxbsQRk2TvTb4H27hfqYK+mX=3urqOoTnaLMDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/2020 3:00 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Mon, 6 Jan 2020 at 21:35, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 1/5/20 5:34 PM, Vladimir Oltean wrote:
>>> From: Claudiu Manoil <claudiu.manoil@nxp.com>
>>>
>>> Within the LS1028A SoC, the register map for the ENETC MDIO controller
>>> is instantiated a few times: for the central (external) MDIO controller,
>>> for the internal bus of each standalone ENETC port, and for the internal
>>> bus of the Felix switch.
>>>
>>> Refactoring is needed to support multiple MDIO buses from multiple
>>> drivers. The enetc_hw structure is made an opaque type and a smaller
>>> enetc_mdio_priv is created.
>>>
>>> 'mdio_base' - MDIO registers base address - is being parameterized, to
>>> be able to work with different MDIO register bases.
>>>
>>> The ENETC MDIO bus operations are exported from the fsl-enetc-mdio
>>> kernel object, the same that registers the central MDIO controller (the
>>> dedicated PF). The ENETC main driver has been changed to select it, and
>>> use its exported helpers to further register its private MDIO bus. The
>>> DSA Felix driver will do the same.
>>
>> This series has already been applied so this may be food for thought at
>> this point, but why was not the solution to create a standalone mii_bus
>> driver and have all consumers be pointed it?
>>
> 
> I have no real opinion on this.
> 
> To be honest, the reason is that the existing "culture" of Freescale
> MDIO drivers wasn't to put them in drivers/net/phy/mdio-*.c, and I
> just didn't look past the fence.
> 
> But what is the benefit? What gets passed between bcmgenet and
> mdio-bcm-unimac with struct bcmgenet_platform_data is equivalent with
> what gets passed between vsc9959 and enetc_mdio with the manual
> population of struct mii_bus and struct enetc_mdio_priv, no? I'm not
> even sure there is a net reduction in code size. And I am not really
> sure that I want an of_node for the MDIO bus platform device anyway.
> Whereas genet seems to be instantiating a port-private MDIO bus for
> the _real_ (but nonetheless embedded) PHY, the MDIO bus we have here
> is for the MAC PCS, which is more akin to the custom device tree
> binding "pcsphy-handle" that the DPAA1 driver is using (see
> arch/arm64/boot/dts/qoriq-fman3-0-10g-0.dtsi for example). So there is
> no requirement to run the PHY state machine on it, it's just locally
> driven, so I don't want to add a dependency on device tree where it's
> really not needed. (By the way I am further confused by the
> undocumented/unused "brcm,40nm-ephy" compatible string that these
> device tree bindings for genet have).

That compatibility string should not have been defined, but the DTS were
imported from our Device Tree auto-generation tool that did produce
those, when my TODO list empty, I might send an update to remove those,
unless someone thinks it's ABI and it would break something (which I can
swear won't).

> 
>> It is not uncommon for MDIO controllers to be re-used and integrated
>> within a larger block and when that happens whoever owns the largest
>> address space, say the Ethernet MAC can request the large resource
>> region and the MDIO bus controler can work on that premise, that's what
>> we did with genet/bcmmii.c and mdio-bcm-unimac.c for instance (so we
>> only do an ioremap, not request_mem_region + ioremap).
>>
> 
> I don't really understand this. In arch/mips/boot/dts, for all of
> bcm73xx and bcm74xx SoCs, you have a single Ethernet port DT node, and
> a single MDIO bus as a child beneath it, where is this reuse that you
> mention?
> And because I don't really understand what you've said, my following
> comment maybe makes no sense, but I think what you mean by "MDIO
> controller reuse" is that there are multiple instantiations of the
> register map, but ultimately every transaction ends up on the same
> MDIO/MDC pair of wires and the same electrical bus.
> We do have some of that with the ENETC, but not with the switch, whose
> internal MDIO bus has no connection to the outside world, it just
> holds the PCS front-ends for the SerDes.
> I also don't understand the reference to request_mem_region, perhaps
> it would help if you could show some code.

What I forgot telling you about is that the same MDIO bus controller is
used internally by each GENET instance to "talk" to both external and
internal PHYs, but also by the bcm_sf2.c driver which is why it made
sense to have a standalone MDIO bus driver that could either be
instantiated on its own (as is the case with bcm_sf2) or as part of a
larger block within GENET. The request_mem_region() + ioremap() comment
is because you cannot have two resources that overlap be used with
request_mem_region(), since the MDIO bus driver is embedded into a
larger block, it simply does an ioremap. If that confused you, then you
can just discard that comment, is it not particularly relevant.

> 
>> Your commit message does not provide a justification for why this
>> abstraction (mii_bus) was not suitable or considered here. Do you think
>> that could be changed?
>>
> 
> I'm sorry, was the mii_bus abstraction really not considered here?
> Based on the stuff exported in this patch, an mii_bus is exactly what
> I'm registering in 9/9, no?

I meat in the commit message, there is no justification why this was not
considered or used, by asking you ended up providing one, that is
typically what one would expect to find to explain why something was/was
not considered. It's fine, the code is merge, I won't object or require
you to use a mii_bus abstraction.
-- 
Florian
