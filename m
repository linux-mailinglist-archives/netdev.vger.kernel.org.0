Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41A9102DC7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 21:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKSUtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 15:49:00 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:57707 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKSUtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 15:49:00 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: X7jd8EzvsCPsuAOV856YXHRa2df/2Gj7182R5Z9BNEJStllCZnVBuws/W6euGdHY8wG5V7uGa1
 Dnz9bLhlBgz1liUG6NnMhzVKYB1Gw9L1DlVL1y1KNsJWBSPWXLeRPh2EzTuQTb98lnkVgVe402
 bfFbCPeh4n82Zg9Eg7dibKW3Z6R82+NgGHN8gkxCurGVMH8gsTxTUc9rQbnDGh5XQCotp/9DOd
 UttPrgBLVOWWONh2yPTarpbLztbNDhdgejSLh5c6+kk+l9o+D+2pgQdy072xGOcf9NwKvl873P
 bZM=
X-IronPort-AV: E=Sophos;i="5.69,219,1571727600"; 
   d="scan'208";a="54925030"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Nov 2019 13:48:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Nov 2019 13:48:58 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 19 Nov 2019 13:48:58 -0700
Date:   Tue, 19 Nov 2019 21:48:57 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
Message-ID: <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
References: <20191118181030.23921-1-olteanv@gmail.com>
 <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/19/2019 14:42, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, 19 Nov 2019 at 01:13, Horatiu Vultur
> <horatiu.vultur@microchip.com> wrote:
> >
> > The 11/18/2019 20:10, Vladimir Oltean wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > >
> > > This series is needed on NXP LS1028A to support the CPU port which runs
> > > at 2500Mbps fixed-link, a setting which PHYLIB can't hold in its swphy
> > > design.
> > >
> > > In DSA, PHYLINK comes "for free". I added the PHYLINK ops to the Ocelot
> > > driver, integrated them to the VSC7514 ocelot_board module, then tested
> > > them via the Felix front-end. The VSC7514 integration is only
> > > compile-tested.
> > >
> > > Vladimir Oltean (2):
> > >   net: mscc: ocelot: treat SPEED_UNKNOWN as SPEED_10
> > >   net: mscc: ocelot: convert to PHYLINK
> > >
> > >  drivers/net/dsa/ocelot/felix.c           |  65 +++++++---
> > >  drivers/net/ethernet/mscc/Kconfig        |   2 +-
> > >  drivers/net/ethernet/mscc/ocelot.c       | 153 ++++++++++++-----------
> > >  drivers/net/ethernet/mscc/ocelot.h       |  13 +-
> > >  drivers/net/ethernet/mscc/ocelot_board.c | 151 +++++++++++++++++++---
> > >  include/soc/mscc/ocelot.h                |  21 +++-
> > >  6 files changed, 285 insertions(+), 120 deletions(-)
> > >
> > > --
> > >
> > > Horatiu, I am sorry for abusing your goodwill. Could you please test
> > > this series and confirm it causes no regression on VSC7514?
> >
> > Hi Vladimir,
> >
> > Sorry for late reply, I have tried your patches but unfortunetly I get
> > a segmentation fault when I try to set the link up.
> > Here is the stack trace:
> >
> > # ip link set dev eth0 up
> > [  259.978564] CPU 0 Unable to handle kernel paging request at virtual address 00000008, epc == 805aa7a4, ra == 805aa79c
> > [  259.989679] Oops[#1]:
> > [  259.992007] CPU: 0 PID: 98 Comm: ip Not tainted
> > 5.4.0-rc7-01844-g0d53d4ce24f5 #2
> > [  259.999428] $ 0   : 00000000 00000001 80910000 fffffff8
> > [  260.004687] $ 4   : 8090838c 0000000e 9e51589c 9e515cbc
> > [  260.009940] $ 8   : 00000000 807bea44 00000000 00000000
> > [  260.015193] $12   : 00000000 00000020 00402f1c 00000002
> > [  260.020445] $16   : 00000000 808e0000 808074f4 9f8a4828
> > [  260.025699] $20   : 00000000 9e515cbc 9e515ba0 9e54fc10
> > [  260.030952] $24   : 00000000 9e515dac
> > [  260.036206] $28   : 9e514000 9e515840 00000000 805aa79c
> > [  260.041460] Hi    : 00000129
> > [  260.044351] Lo    : 00001a94
> > [  260.047311] epc   : 805aa7a4 phylink_start+0x20/0x2e0
> > [  260.052387] ra    : 805aa79c phylink_start+0x18/0x2e0
> > [  260.057454] Status: 11008403 KERNEL EXL IE
> > [  260.061661] Cause : 00800008 (ExcCode 02)
> > [  260.065683] BadVA : 00000008
> > [  260.068575] PrId  : 02019654 (MIPS 24KEc)
> > [  260.072596] Modules linked in:
> > [  260.075673] Process ip (pid: 98, threadinfo=(ptrval), task=(ptrval), tls=77e564a0)
> > [  260.083263] Stack : 00000000 00000000 9f8a4800 808e0000 808074f4 9e515cbc 00000000 9f8a4800
> > [  260.091662]         808e0000 805b7898 00000000 00000000 00000000 808e0000 808074f4 8062cf20
> > [  260.100058]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 9f8a4800
> > [  260.108453]         9e515cbc 0295ff75 00000000 9f8a4800 00001003 808e0000 00000000 8062d39c
> > [  260.116850]         00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> > [  260.125245]         ...
> > [  260.127706] Call Trace:
> > [  260.130176] [<805aa7a4>] phylink_start+0x20/0x2e0
> > [  260.134955] [<805b7898>] ocelot_port_open+0x10/0x20
> > [  260.139897] [<8062cf20>] __dev_open+0x10c/0x194
> > [  260.144457] [<8062d39c>] __dev_change_flags+0x1b0/0x210
> > [  260.149712] [<8062d420>] dev_change_flags+0x24/0x68
> > [  260.154625] [<806482d4>] do_setlink+0x340/0xaec
> > [  260.159182] [<8064978c>] __rtnl_newlink+0x484/0x7d8
> > [  260.164086] [<80649b30>] rtnl_newlink+0x50/0x84
> > [  260.168676] [<80643484>] rtnetlink_rcv_msg+0x2e8/0x3b8
> > [  260.173859] [<8067c9c0>] netlink_rcv_skb+0xa0/0x150
> > [  260.178766] [<8067abdc>] netlink_unicast+0x1c4/0x26c
> > [  260.183760] [<8067b478>] netlink_sendmsg+0x2cc/0x3e0
> > [  260.188758] [<80601df8>] ___sys_sendmsg+0xec/0x280
> > [  260.193584] [<80603b9c>] __sys_sendmsg+0x60/0xac
> > [  260.198246] [<80115e98>] syscall_common+0x34/0x58
> > [  260.202979] Code: afb10020  10400055  3c028091 <8e020008> 8c420004 10400086  24030001  1043006d  00000000
> > [  260.212788]
> > [  260.214696] ---[ end trace 42880f8a413b404b ]---
> > Segmentation fault
> > #
> >
> > The reason of this segmentation is that, before it was fine to use the
> > phy PHY_INTERFACE_MODE_NA. Now if the phy interface is
> > PHY_INTERFACE_MODE_NA it would not create the phylink. I think this can
> > be fixed in the device tree.
> >
> 
> Oops, that does not sound good. But what crashes in phylink_start,
> exactly, and why? I see there is a print right at the beginning of the
> function, and it isn't visible in your log. Does it crash at the
> print?

Yes it crashes at the print because in the function 'ocelot_port_open'
the priv->phylink is NULL. In the function mscc_ocelot_probe the phylink
is not created because the function 'of_get_phy_mode' sets phy_mode to
PHY_INTERFACE_MODE_NA because there is no 'phy-mode' attribut in the DT.
And after that it checks the phy_mode and if it is PHY_INTERFACE_MODE_NA
it would just continue to create the next interface so the phylink is
always NULL.

Before this commit it was ok to use PHY_INTERFACE_MODE_NA but now that
is not true anymore. In this case we have 4 ports that have phy and
then 6 sfp ports. So I was looking to describe this in DT but without
any success. If you have any advice that would be great.

> 
> > Apparently there is another issue: mscc mdio bus driver fails to be
> > probed. So first I need to see this issue and then I will try your
> > patches.
> >
> > >
> > > 2.17.1
> > >
> >
> > --
> > /Horatiu
> 
> Thanks,
> -Vladimir

-- 
/Horatiu
