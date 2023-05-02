Return-Path: <netdev+bounces-19-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A64D6F4B9B
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60C911C20981
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8C38A922;
	Tue,  2 May 2023 20:50:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9CA7491
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:50:29 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3B51BC1
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683060627; x=1714596627;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZJYVsn3vXZvhrmw2j6cXAzO6uYh3kmoJnZnFB4a7FTI=;
  b=KtuRvXjeZI03EpM0569BtCUIgSkgp9fwHA4BpJlqomw/6cnpEAL7zNLQ
   047bqHp9V79u8Fazgl7Vmabmd/WRuSlA2KxddAMAHdPCyUXkVIxELPdS3
   mED30J56d8L01aSoNYavYFuSlsOJPvArDP8kRZCUISUf/G8A2uWWoFJas
   CipnAk9z2owutYoAHteFy4+oUUzLabjMOQh5WeGiPA/zEvAYQjDmNS9rv
   RAoMI9mJb9yF5R9+M8VG5pW6bUz3LwivmOSoEdVVjTERG12roRngtUkBa
   DV77E7OcYrqn/S2T285k2gUtJL8f1/VhtGeFR3MYRHVFJhqGUDmLcIJxq
   w==;
X-IronPort-AV: E=Sophos;i="5.99,245,1677567600"; 
   d="scan'208";a="211646285"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2023 13:50:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 2 May 2023 13:50:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 2 May 2023 13:50:27 -0700
Date: Tue, 2 May 2023 22:50:26 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Ron Eggler <ron.eggler@mistywest.com>
CC: <netdev@vger.kernel.org>
Subject: Re: Unable to TX data on VSC8531
Message-ID: <20230502205026.3h6nmwnotlgbfl5o@soft-dev3-1>
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
 <20230501064655.2ovbo3yhkym3zu57@soft-dev3-1>
 <2c2bade5-01d5-7065-13e6-56fcdbf92b5a@mistywest.com>
 <20230502071135.bcxg5nip62m7wndb@soft-dev3-1>
 <0ba220c3-1a89-69ff-4c90-e2777a0dd04e@mistywest.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <0ba220c3-1a89-69ff-4c90-e2777a0dd04e@mistywest.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/02/2023 13:16, Ron Eggler wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Horatiu,
> 
> On 2023-05-02 12:11 a.m., Horatiu Vultur wrote:
> > The 05/01/2023 13:34, Ron Eggler wrote:
> > 
> > [snip greetings]
> > 
> > > > I've posted here previously about the bring up of two network interfaces
> > > > on an embedded platform that is using two the Microsemi VSC8531 PHYs.
> > > > (previous thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner
> > > > Kallweit & Andrew Lunn).
> > > > I'm able to seemingly fully access & operate the network interfaces
> > > > through ifconfig (and the ip commands) and I set the ip address to match
> > > > my /24 network. However, while it looks like I can receive & see traffic
> > > > on the line with tcpdump, it appears like none of my frames can go out
> > > > in TX direction and hence entries in my arp table mostly remain
> > > > incomplete (and if there actually happens to be a complete entry,
> > > > sending anything to it doesn't seem to work and the TX counters in
> > > > ifconfig stay at 0. How can I further troubleshoot this? I have set the
> > > > phy-mode to rgmii-id in the device tree and have experimented with all
> > > > the TX_CLK delay register settings in the PHY but have failed to make
> > > > any progress.
> > > > Some of the VSC phys have this COMA mode, and then you need to pull
> > > > down a GPIO to take it out of this mode. I looked a little bit but I
> > > > didn't find anything like this for VSC8531 but maybe you can double
> > > > check this. But in that case both the RX and TX will not work.
> > > > Are there any errors seen in the registers 16 (0x10) or register 17
> > > > (0x11)?
> > > Good point rewgarding the COMA mode, I have not found anything like it.
> > > The RGMII connectivity should be pretty straight forward per the
> > > datasheet, TX0-TX4, TX_CLK, TX_CTL, RXD0-RXD4, RX_CLK & RX_CTL.
> > > Not sure if you've seen this in the subthread that is  ongoing with
> > > Andrew Lunn but as part of it, I did invoke the mii-tool and got a
> > > pretty printout of the PHY registers, see below:
> > > 
> > > # mii-tool -vv eth0
> > > Using SIOCGMIIPHY=0x8947
> > > eth0: negotiated 100baseTx-FD, link ok
> > >    registers for MII PHY 0:
> > >      1040 796d 0007 0572 01e1 45e1 0005 2801
> > >      0000 0300 4000 0000 0000 0000 0000 3000
> > >      9000 0000 0008 0000 0000 0000 3201 1000
> > >      0000 a020 0000 0000 802d 0021 0400 0000
> > Unfortunetly, I can't see anything obvious wrong with the registers.
> > 
> > >    product info: vendor 00:01:c1, model 23 rev 2
> > >    basic mode:   autonegotiation enabled
> > >    basic status: autonegotiation complete, link ok
> > >    capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> > > 10baseT-FD 10baseT-HD
> > >    advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
> > Are you expecting to run at 100Mbit?
> that's right and expected.
> > >    link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> > > 10baseT-FD 10baseT-HD flow-control
> > > 
> > > Alternartively, the registers can be read with phytool also:
> > > 
> > > # phytool read eth0/0/0x10
> > > 0x9000
> > > # phytool read eth0/0/0x11
> > > 0000
> > Another thing that you can try, is to put a probe and see if you
> > actually see the TXCLK? And if I understand correctly that should be at
> > 25MHz (because the link speed is 100Mbit).
> Ah, that's a problem:
> I did probe and the clock I probe is at 2.5MHz, not 25.

That is one step foward :)

> 
> Just to try out, I also temporarily connected it to 1000baseT:
> 
> # mii-tool -vv eth0
> Using SIOCGMIIPHY=0x8947
> eth0: negotiated 1000baseT-FD flow-control, link ok
>   registers for MII PHY 0:
>     1040 796d 0007 0572 01e1 c1e1 000d 2001
>     4d47 0300 3800 0000 0000 0000 0000 3000
>     0000 9000 0008 0000 0000 0000 3201 1000
>     0000 a020 a000 0000 a035 0021 0400 0000
>   product info: vendor 00:01:c1, model 23 rev 2
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD
>   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD
> 10baseT-HD
>   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
> 10baseT-FD 10baseT-HD
> 
> and even here, the TX_CLK remained at 2.5MHz (mind the scope I'm using
> only goes up to 70MHz but I surely would not expect it to show me a
> clear clock at 2.5MHz for a faster frequency).

Then in theory if you force the speed to be 10Mbit, will it work?

> 
> It appears to be "stuck" at 10MBit speed. Also it is at 2.5V instead of
> 1.8V.
> 
> Would I be able to configure this through device tree setting?

I am not sure, if this is possible, shouldn't be a configuration option
on the MAC side? As if I understand correctly, the MAC should generate
the TX_CLK in RGMII regardless of the speed.
I would prefer to leave this to people who have more knowledge then me
to answer to this.

> 
> Thanks Horatiu,
> 
> this definitely showed clearly where there is a problem.
> 
> --
> 
> Ron
> 

-- 
/Horatiu

