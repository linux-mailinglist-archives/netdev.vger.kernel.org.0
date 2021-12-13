Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC651472D70
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbhLMNf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:35:29 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:20137 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbhLMNfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 08:35:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639402516; x=1670938516;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RSFM3Z6HDJUr0fxzj0LErU5vN/FtBT1CCIoA1vLoXBA=;
  b=TNeXgOeZN7rY8BFR9EQr9IRlRoLVJV12OBXIbNoPZcVgfRPcYLosLra8
   MpIc4C4RyuwjsqJ0Vm5+gy+RAK0SExguhdgZAw11e+0doDJIzPNRsC2Kc
   EZmNAidHtrFfMqgulX+dS45G8/nH0I4ZW5A946rGikqTQPcaHkI3eN+L4
   /2L3MYuULnS+nHTGb7nyYmf/3Pw+RBhJ1iKdL8edZ61UI2u2EX07MFWS2
   W9QG5WWzOX/eCRMAHkVn6cZmcHUGWSgBk1QLB0Y2pibCln3pTrpEzBMd6
   bOdGfu0rkE6BYrK8AJw0JNcPqxHZgKEgoGzASiDIaph1YtYXTI6VPSCly
   A==;
IronPort-SDR: GGwYrh/hfgvdY9Tn1kTXmdf+0JaNKbf70Nrz+YrbmDWXS5q9DMNwDTKlDKbhmBSMmiTmob687x
 xCsySKVvNFHMBMn/RqIe+vWvp5+6+0LPwatflFv/c/M8lUzObRWezaoUhEjpzHXmy/a5eDKvfD
 a7Wa6wG7kb7zXsyIgptQwHUd+NOMDS7sXDZcpeh4KcO04/ICoWTyyKkgX4EinbUQb9wHrSewv+
 ZFH4hsSlB8zWoOhXgLFnELkmsAdkuYroV4+a0xUuietpeyf+UbpgFQrduGjEMODyIKVcWrJJXr
 Gr+/p6uQcZ+T2Wi3U85vI9Fm
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="146464261"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 06:35:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 06:35:14 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 13 Dec 2021 06:35:14 -0700
Date:   Mon, 13 Dec 2021 14:37:16 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Message-ID: <20211213133716.sfcgl4zrmynwagbr@soft-dev3-1.localhost>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213114603.jdvv5htw22vd3azj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211213114603.jdvv5htw22vd3azj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/13/2021 11:46, Vladimir Oltean wrote:
> 
> On Thu, Dec 09, 2021 at 05:43:11PM +0100, Horatiu Vultur wrote:
> > > My documentation of CPU_SRC_COPY_ENA says:
> > >
> > > If set, all frames received on this port are
> > > copied to the CPU extraction queue given by
> > > CPUQ_CFG.CPUQ_SRC_COPY.
> > >
> > > I think it was established a while ago that this isn't what promiscuous
> > > mode is about? Instead it is about accepting packets on a port
> > > regardless of whether the MAC DA is in their RX filter or not.
> >
> > Yes, I am aware that this change interprets the things differently and I
> > am totally OK to drop this promisc if it is needed.
> 
> I think we just need to agree on the observable behavior. Promiscuous
> means for an interface to receive packets with unknown destination, and
> while in standalone mode you do support that, in bridge mode you're a
> bit on the edge: the port accepts them but will deliver them anywhere
> except to the CPU. I suppose you could try to make an argument that you
> know better than the bridge, and as long as the use cases for that are
> restricted enough, maybe it could work for most scenarios. I don't know.

I think this requires some proper explanations of the intended
behaviour for both the standalone and bridge mode. I will drop this
promisc for now, as other drivers are doing it and at a later point
send some patch series with all the explanations.

> 
> > > Hence the oddity of your change. I understand what it intends to do:
> > > if this is a standalone port you support IFF_UNICAST_FLT, so you drop
> > > frames with unknown MAC DA. But if IFF_PROMISC is set, then why do you
> > > copy all frames to the CPU? Why don't you just put the CPU in the
> > > unknown flooding mask?
> >
> > Because I don't want the CPU to be in the unknown flooding mask. I want
> > to send frames to the CPU only if it is required.
> 
> What is the strategy through which this driver accepts things like
> pinging the bridge device over IPv6, with the Neighbor Discovery
> protocol having the ICMP6 neighbor solicitation messages delivered to
> (according to my knowledge) an unregistered IPv6 multicast address?
> Whose responsibility is it to notify the driver of that address, and
> does the driver copy those packets to the CPU in the right VLAN?

I think in that case the CPU should be part of the multicast flooding
mask. I will need to look more on this because I don't know much about
the IPv6.

> 
> > > How do you handle migration of an FDB entry pointing towards the CPU,
> > > towards one pointing towards a port?
> >
> > Shouldn't I get 2 calls that the entry is removed from CPU and then
> > added to a port?
> 
> Ok.

-- 
/Horatiu
