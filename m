Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C181722CC46
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 19:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGXRjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 13:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGXRjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 13:39:19 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF36C0619D3;
        Fri, 24 Jul 2020 10:39:19 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so9045040wrw.1;
        Fri, 24 Jul 2020 10:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dMOTyj1bJjD0JwVcKSaFk5ZhNFNqHamKZ+nmeW0h9/0=;
        b=Fcnk119mUhTpcxAENN8R4EJ54pYrG9iUVXfUZcmbCZOLOvu+ld6sxmq6KeYX2JW88J
         FwI8rgZUicVSt10Mn1JlWjEFcJkFXiqY9a3+VbqGj/xwBAoDCx5o2wfugkbDN8QV8GCa
         4kSM/o0WwQuwvpr87S4QdkkcmtzsYsbh76irq58LxwxxMHW7UtHVg/sPQ2bjy+COBugC
         dqjWZRqJAkFBzIRjlB/G+G7hXcBkzb8JrgM5CQPYgdY+Yp/2V2VRYDWv9cb8Q8uOr/yT
         PqAvG2a3xq8JnHvdIxRYxkyJ0X8wHepgc407iiu7ty4GQj3lpjZThYvPSS3fCRLdsTrk
         QTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dMOTyj1bJjD0JwVcKSaFk5ZhNFNqHamKZ+nmeW0h9/0=;
        b=sQ6uWagpuoYUxq5DC28dosyZGY/01wdtTw5TrBqqDC6akCglB3RvMQK06+jlUEOzfy
         eNsi1Jv4d+h1yD39U4CI/w/YB79Dho0DBk+/fNTSeuNnwCWNWZR7GO373ABqHyQdmuKA
         Mo8rK5r0jw/B0KukhVVUF2PDOmnngzu72qJMhZv+g+UNCxeJhX8W+tAhWe0RsOr7eOqu
         1lv+P9gaSzzT4YDgf+4iZDQe3mn7hgmPQFH4DOp0ClJwOVAjiN9ozJwMsXxZ6/1DpSKq
         4uY3PRIvwawitIwWjoqINhDkVJJIfCEGLiBB5430kQ4b7mflNWH6/fcYNxD697vMveSz
         O1ZQ==
X-Gm-Message-State: AOAM532aFhg8bXpslgP4gtixnxZfSOk/KHn/fuW342G3mwBO4gIWgB+L
        ArFaY5iBwPv16qQ6d0yC3/oYBhaw
X-Google-Smtp-Source: ABdhPJwVIMAIoP7OpthWQQc8NuKMRA3Yez9KlgBBXPDjCeNENvoiu2W935zKsV06p0I2cxNjxpNtXA==
X-Received: by 2002:a5d:550e:: with SMTP id b14mr10283001wrv.392.1595612357673;
        Fri, 24 Jul 2020 10:39:17 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x204sm12408068wmg.2.2020.07.24.10.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 10:39:16 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Jeremy Linton <jeremy.linton@arm.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <a95f8e07-176b-7f22-1217-466205fa22e7@gmail.com>
Date:   Fri, 24 Jul 2020 10:39:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 10:26 AM, Jeremy Linton wrote:
> Hi,
> 
> On 7/24/20 8:39 AM, Andrew Lunn wrote:
>>> Otherwise the MDIO bus and its phy should be a
>>> child of the nic/mac using it, with standardized behaviors/etc left
>>> up to
>>> the OSPM when it comes to MDIO bus enumeration/etc.
>>
>> Hi Jeremy
>>
>> Could you be a bit more specific here please.
>>
>> DT allows
>>
>>          macb0: ethernet@fffc4000 {
>>                  compatible = "cdns,at32ap7000-macb";
>>                  reg = <0xfffc4000 0x4000>;
>>                  interrupts = <21>;
>>                  phy-mode = "rmii";
>>                  local-mac-address = [3a 0e 03 04 05 06];
>>                  clock-names = "pclk", "hclk", "tx_clk";
>>                  clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
>>                  ethernet-phy@1 {
>>                          reg = <0x1>;
>>                          reset-gpios = <&pioE 6 1>;
>>                  };
>>          };
>>
>> So the PHY is a direct child of the MAC. The MDIO bus is not modelled
>> at all. Although this is allowed, it is deprecated, because it results
>> > in problems with advanced systems which have multiple different
>> children, and the need to differentiate them. So drivers are slowly
> 
> I don't think i'm suggesting that, because AFAIK in ACPI you would have
> to specify the DEVICE() for mdio, in order to nest a further set of
> phy's via _ADR(). I think in general what I was describing would look
> more like what you have below. But..
> 
>> migrating to always modelling the MDIO bus. In that case, the
>> phy-handle is always used to point to the PHY:
>>
>>          eth0: ethernet@522d0000 {
>>                  compatible = "socionext,synquacer-netsec";
>>                  reg = <0 0x522d0000 0x0 0x10000>, <0 0x10000000 0x0
>> 0x10000>;
>>                  interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
>>                  clocks = <&clk_netsec>;
>>                  clock-names = "phy_ref_clk";
>>                  phy-mode = "rgmii";
>>                  max-speed = <1000>;
>>                  max-frame-size = <9000>;
>>                  phy-handle = <&phy1>;
>>
>>                  mdio {
>>                          #address-cells = <1>;
>>                          #size-cells = <0>;
>>                          phy1: ethernet-phy@1 {
>>                                  compatible =
>> "ethernet-phy-ieee802.3-c22";
>>                                  reg = <1>;
>>                          };
>>                  };
>>
>> "mdio-handle" is just half of phy-handle.
>>
>> What you seem to be say is that although we have defined a generic
>> solution for ACPI which should work in all cases, it is suggested to
>> not use it? What exactly are you suggesting in its place?
> 
> When you put it that way, what i'm saying sounds crazy.
> 
> In this case what are are doing isn't as clean as what you have
> described above, its more like:
> 
> mdio: {
>   phy1: {}
>   phy2: {}
> }
> ...
> // somewhere else
> dmac1: {
>     phy-handle = <&phy1>;
> }
> 
> ... //somewhere else
> eth0: {
>    //another device talking to the mgmt controller
> }
> 
> 
> Which is special in a couple ways.
> 
> Lets rewind for a moment and say for ARM/ACPI, what we are talking about
> are "edge/server class" devices (with RAS statements/etc) where the
> expectation is that they will be running virtualized workloads using LTS
> distros, or non linux OSes. DT/etc remains an option for networking
> devices which are more "embedded", aren't SBSA, etc. So an Arm
> based/ACPI machine should be more regular and share more in the way of
> system architecture with other SBSA/SBBR/ACPI/etc machines than has been
> the case for DT machines.
> 
> A concern is then how we punch networking devices into an arbitrary VM
> in a standardized way using libvirt/whatever. If the networking device
> doesn't look like a simple self contained memory mapped resource with an
> IOMMU domain, I think everything becomes more complicated and you have
> to start going down the path of special caseing the VM firmware beyond
> how its done for self contained PCIe/SRIOV devices. The latter manage to
> pull this all off with a PCIe id, and a couple BARs fed into the VM.
> 
> So, I would hope an ACPI nic representation is closer to just a minimal
> resource list like:
> 
> eth0: {
>       compatible = "cdns,at32ap7000-macb";
>       reg = <0xfffc4000 0x4000>;
>       interrupts = <21>;
> }
> or in ACPI speak:
> Device (ETH0)
> {
>       Name (_HID, "CDNSXXX")
>       Method (_CRS, 0x0, Serialized)
>       {
>         Name (RBUF, ResourceTemplate ()
>         {
>           Memory32Fixed (ReadWrite, 0xfffc4000, 0x4000, )
>           Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive)
>           {
>             21
>           }
>         })
>         Return (RBUF)
>       }
> }
> 
> (Plus methods for pwr mgmt/etc as needed, the iommu info comes from
> another table).
> 
> Returning to the NXP part. They avoid the entirety of the above
> discussion because all this MDIO/PHY mgmt is just feeding the data into
> the mgmt controller, and the bits that are punched into the VM are
> fairly standalone.
> 
> Anyway, I think this set is generally fine, I would like to see this
> part working well with ACPI given its what we have available today. For
> the future, we also need to continue pushing everyone towards common
> hardware standards. One of the ways of doing this is having hardware
> which can be automatically enumerated/configured. Suggesting that the
> kernel has a recommended way of doing this which aids fragmentation
> isn't what we are trying to achieve with ACPI. Hence my previous comment
> that we should consider this an escape hatch rather than the last word
> in how to describe networking on ACPI/SBSA platforms.

We are at v7 of this patch series, and no authoritative ACPI Linux
maintainer appears to have reviewed this, so there is no clear sign of
this converging anywhere. This is looking a lot like busy work for
nothing. Given that the representation appears to be wildly
misunderstood and no one seems to come up with something that reaches
community agreement, what exactly is the plan here?

I am going to suggest something highly unpopular here: how about you
just load Device Tree overlays based on matching a particular board and
ship those overlays somewhere in the kernel that take care of
registering your network devices with the desired network topology?
-- 
Florian
