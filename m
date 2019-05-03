Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF2312BCE
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 12:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfECKrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 06:47:24 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:11257 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfECKrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 06:47:24 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,425,1549954800"; 
   d="scan'208";a="31691973"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 03 May 2019 03:47:23 -0700
Received: from localhost (10.10.76.4) by chn-sv-exch02.mchp-main.com
 (10.10.76.38) with Microsoft SMTP Server id 14.3.352.0; Fri, 3 May 2019
 03:47:22 -0700
Date:   Fri, 3 May 2019 12:47:21 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Joergen Andreasen" <joergen.andreasen@microchip.com>
Subject: Re: [PATCH net-next 3/3] MIPS: generic: Add police related options
 to ocelot_defconfig
Message-ID: <20190503104720.v5iltltcfdbyy3it@soft-dev16>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
 <20190502094029.22526-4-joergen.andreasen@microchip.com>
 <20190502162700.GC22550@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190502162700.GC22550@piout.net>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandre,

The 05/02/2019 18:27, Alexandre Belloni wrote:
> External E-Mail
> 
> 
> Hi Joergen,
> 
> On 02/05/2019 11:40:29+0200, Joergen Andreasen wrote:
> > Add default support for ingress qdisc, matchall classification
> > and police action on MSCC Ocelot.
> > 
> 
> This patch should be separated from the series as this doesn't have any
> dependencies and should go through the MIPS tree.
> 

I will create a separate patch for this when the other patches has been
accepted.

> > Signed-off-by: Joergen Andreasen <joergen.andreasen@microchip.com>
> > ---
> >  arch/mips/configs/generic/board-ocelot.config | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/mips/configs/generic/board-ocelot.config b/arch/mips/configs/generic/board-ocelot.config
> > index 5e53b4bc47f1..5c7360dd819c 100644
> > --- a/arch/mips/configs/generic/board-ocelot.config
> > +++ b/arch/mips/configs/generic/board-ocelot.config
> > @@ -25,6 +25,13 @@ CONFIG_SERIAL_OF_PLATFORM=y
> >  CONFIG_NETDEVICES=y
> >  CONFIG_NET_SWITCHDEV=y
> >  CONFIG_NET_DSA=y
> > +CONFIG_NET_SCHED=y
> > +CONFIG_NET_SCH_INGRESS=y
> > +CONFIG_NET_CLS_MATCHALL=y
> > +CONFIG_NET_CLS_ACT=y
> > +CONFIG_NET_ACT_POLICE=y
> > +CONFIG_NET_ACT_GACT=y
> > +
> >  CONFIG_MSCC_OCELOT_SWITCH=y
> >  CONFIG_MSCC_OCELOT_SWITCH_OCELOT=y
> >  CONFIG_MDIO_MSCC_MIIM=y
> > -- 
> > 2.17.1
> > 
> 
> -- 
> Alexandre Belloni, Bootlin
> Embedded Linux and Kernel engineering
> https://bootlin.com
> 

-- 
Joergen Andreasen, Microchip
