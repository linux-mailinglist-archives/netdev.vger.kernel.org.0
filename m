Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2668216A48E
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgBXLD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:03:57 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:48589 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXLD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 06:03:57 -0500
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
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: yIjgW6gckhVxf2hH7puC/m2slZpKqfrqwurH8P1fdvPbbtz3WByCDkSjBYfeylgxBsSgS3EpH6
 KJLSewKjs/u9f7erD8Jd/Bei1ADvWywJy89ktEYnHloYnwI8UeJ0BAthbi5W/EhoFbnG0lAK7K
 nzjDHURrE+HfPSycBDNQIsq5cdBIRio0DyHP1i9kNOMknugU9XLh+J/qVntQzOZ9GiyeSid8Se
 L03S4N47ZOWaVXnxI6DIVMuGyA5H7EhLpRuxeZoYJh2c+rYT5ebzoRiy8ubCrZAgQ5LI2Mav7D
 hCE=
X-IronPort-AV: E=Sophos;i="5.70,479,1574146800"; 
   d="scan'208";a="3379355"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2020 04:03:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Feb 2020 04:03:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 24 Feb 2020 04:04:01 -0700
Date:   Mon, 24 Feb 2020 12:03:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Paul Burton" <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-mips@vger.kernel.org>, <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 1/2] net: mscc: ocelot: Add support for tcam
Message-ID: <20200224110350.7kdzf4kml4iaem4i@soft-dev3.microsemi.net>
References: <1559287017-32397-1-git-send-email-horatiu.vultur@microchip.com>
 <1559287017-32397-2-git-send-email-horatiu.vultur@microchip.com>
 <CA+h21hoSA5DECsA+faJ91n0jBhAR5BZnkMm=Dx4JfNDp8J+xbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hoSA5DECsA+faJ91n0jBhAR5BZnkMm=Dx4JfNDp8J+xbw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

The 02/24/2020 12:38, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Horatiu,
> 
> On Fri, 31 May 2019 at 10:18, Horatiu Vultur
> <horatiu.vultur@microchip.com> wrote:
> >
> > Add ACL support using the TCAM. Using ACL it is possible to create rules
> > in hardware to filter/redirect frames.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> >  arch/mips/boot/dts/mscc/ocelot.dtsi      |   5 +-
> >  drivers/net/ethernet/mscc/Makefile       |   2 +-
> >  drivers/net/ethernet/mscc/ocelot.c       |  13 +
> >  drivers/net/ethernet/mscc/ocelot.h       |   8 +
> >  drivers/net/ethernet/mscc/ocelot_ace.c   | 777 +++++++++++++++++++++++++++++++
> >  drivers/net/ethernet/mscc/ocelot_ace.h   | 227 +++++++++
> >  drivers/net/ethernet/mscc/ocelot_board.c |   1 +
> >  drivers/net/ethernet/mscc/ocelot_regs.c  |  11 +
> >  drivers/net/ethernet/mscc/ocelot_s2.h    |  64 +++
> >  drivers/net/ethernet/mscc/ocelot_vcap.h  | 403 ++++++++++++++++
> >  10 files changed, 1508 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.c
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_ace.h
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
> >  create mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
> >
> 
> I was testing this functionality and it looks like the MAC_ETYPE keys
> (src_mac, dst_mac) only match non-IP frames.
> Example, this rule doesn't drop ping traffic:
> 
> tc qdisc add dev swp0 clsact
> tc filter add dev swp0 ingress flower skip_sw dst_mac
> 96:e1:ef:64:1b:44 action drop
> 
> Would it be possible to do anything about that?

What you could do is to configure each port in such a way, to treat IP
frames as MAC_ETYPE frames. Have a look in ANA:PORT[0-11]:VCAP_S2_CFG.

There might be a problem with this approach. If you configure the port
in such a way, then all your rules with the keys IP6, IP4 will not be
match on that port.

> 
> Thanks,
> -Vladimir

-- 
/Horatiu
