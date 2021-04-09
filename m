Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A649E359E98
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 14:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhDIMZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 08:25:46 -0400
Received: from mx.i2x.nl ([5.2.79.48]:59826 "EHLO mx.i2x.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232763AbhDIMZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 08:25:45 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id BC5575FBA8;
        Fri,  9 Apr 2021 14:25:29 +0200 (CEST)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="Tcw1qj2W";
        dkim-atps=neutral
Received: from www (unknown [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 7F273BC6013;
        Fri,  9 Apr 2021 14:25:29 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 7F273BC6013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1617971129;
        bh=8+E8zX/etY3i4LNvV1TwVYoMvMWtXNcy6wJF6uT5dRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tcw1qj2Wfgvbthhz2/picZXahWlFzpEgfAPbgjUST7I4lhUBZYACWjtYtc9Yb+osb
         tp7b/aLxZ6HeRn9PFIz6MgGmZiSRINCL9O3NEeb6Ne9p15n9mqctyN/Lc3W7B9zpdL
         +s5pDcWEID9av23lIspKxpt0d7CRyIzsF77uAxXmFGSmIp9qQ/Tul/N2bSqEEEFkRL
         GfoXTg6TDxCTyq4F+8ARBgGkOIRLJWFiGQ1oNtTmWy/Hb2lwgwqU+mhF1HJE81p6L8
         7Jt2oyMyFQTVHzCBtkGLSDzejUbp2AKemy9j0vclRtwKiWWyZj16cn0kriDnkrqEG2
         xTqkT1/o+fZcg==
Received: from 48.79.2.5.in-addr.arpa (48.79.2.5.in-addr.arpa [5.2.79.48])
 by www.vdorst.com (Horde Framework) with HTTPS; Fri, 09 Apr 2021 12:25:29
 +0000
Date:   Fri, 09 Apr 2021 12:25:29 +0000
Message-ID: <20210409122529.Horde.fb4QbDNxhPNA6ZyDBOjGTct@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v3 net-next 0/4] MT7530 interrupt support
References: <20210408123919.2528516-1-dqfext@gmail.com>
 <20210408140255.Horde.Pl-DXtrqmiH9imsWjDqblfM@www.vdorst.com>
 <CALW65jZujSCk16RX_xgcg+NGrc9yyFQOQ9Y-z3qz-Qv1TvUQLg@mail.gmail.com>
 <YG8zvFKOdnzaJqLa@lunn.ch>
In-Reply-To: <YG8zvFKOdnzaJqLa@lunn.ch>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Lunn <andrew@lunn.ch>:

> On Thu, Apr 08, 2021 at 11:00:08PM +0800, DENG Qingfang wrote:
>> Hi René,
>>
>> On Thu, Apr 8, 2021 at 10:02 PM René van Dorst  
>> <opensource@vdorst.com> wrote:
>> >
>> > Tested on Ubiquiti ER-X-SFP (MT7621) with 1 external phy which  
>> uses irq=POLL.
>> >
>>
>> I wonder if the external PHY's IRQ can be registered in the devicetree.
>> Change MT7530_NUM_PHYS to 6, and add the following to ER-X-SFP dts PHY node:
>
> I don't know this platform. What is the PHYs interrupt pin connected
> to? A SoC GPIO? There is a generic mechanism to describe PHY
> interrupts in DT. That should be used, if it is a GPIO.
>
> 	   Andrew

Quoting Andrew Lunn <andrew@lunn.ch>:

> On Thu, Apr 08, 2021 at 11:00:08PM +0800, DENG Qingfang wrote:
>> Hi René,
>>
>> On Thu, Apr 8, 2021 at 10:02 PM René van Dorst  
>> <opensource@vdorst.com> wrote:
>> >
>> > Tested on Ubiquiti ER-X-SFP (MT7621) with 1 external phy which  
>> uses irq=POLL.
>> >
>>
>> I wonder if the external PHY's IRQ can be registered in the devicetree.
>> Change MT7530_NUM_PHYS to 6, and add the following to ER-X-SFP dts PHY node:
>
> I don't know this platform. What is the PHYs interrupt pin connected
> to? A SoC GPIO? There is a generic mechanism to describe PHY
> interrupts in DT. That should be used, if it is a GPIO.
>
> 	   Andrew


Hi Andrew,

I couldn't find if the external phy IRQ is connected to any gpio of the SOC.
So External PHY IRQ can't be sensed via a gpio.


The patch used the MT7530 link change interrupt and flags.
Maybe the patch is misusing the these flags as an interrupt?
The same MT7530 register also has the interrupt flags for the internal phys.
But in the MT7531 datasheet they don't describe them.

On the other hand I don't have any information about the internal PHY  
or register settings.
So enabling the interrupt on the PHY is currently not possible.

I also forced enabled all the MT7530 PHY interrupts and PHY link  
change interrupts.
I print the interrupt status mt7530.
I don't see any MT7530 interrupt fired when link changing the port  
5/external phy.
Which was of course as expected. We only have 5 internal phy's for the  
port 0 to 4.
Port 5 and 6 is only have a MAC that is connected to the SOC of an  
external PHY.

Greats,

René

