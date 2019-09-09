Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 180F3AD91F
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbfIIMgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 08:36:37 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:16943 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbfIIMgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 08:36:37 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Sj2TqHCQV3SJ2CUeozfnllHuARpq2/blLTHA6Cgw5SrOMblNqbzhIOIvHNyi3c448B4fim88zn
 5Iqs0NqV/nk1jISMecKmi1QlKjwUSJNQDnQWk9EbD/dc9gZtSv1OnoGFxI/qjR3TUrE0bbWEsk
 WJalaeShQKeU7byxoIIh3QghSR4ttUurWkMiKgSb6SUmRkZHzwFWEhgYneMzWL+ob1SZacIluv
 KSdyx0V/GNvvcg7e/Q/5Ab6LV181Hws8ebk1GfS/1OfAQrAClEhRjpL447dzrcsvMMIWCRI3JS
 Cqw=
X-IronPort-AV: E=Sophos;i="5.64,484,1559545200"; 
   d="scan'208";a="48369774"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2019 05:36:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Sep 2019 05:36:33 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 9 Sep 2019 05:36:34 -0700
Date:   Mon, 9 Sep 2019 14:36:33 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vinicius.gomes@intel.com>,
        <vedang.patel@intel.com>, <richardcochran@gmail.com>,
        <weifeng.voon@intel.com>, <jiri@mellanox.com>,
        <m-karicheri2@ti.com>, <Jose.Abreu@synopsys.com>,
        <ilias.apalodimas@linaro.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <kurt.kanzenbach@linutronix.de>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
Message-ID: <20190909123632.nvlmfdtw3otyx3xh@soft-dev16>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190906.145403.657322945046640538.davem@davemloft.net>
 <20190907144548.GA21922@lunn.ch>
 <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
 <20190908204224.GA2730@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190908204224.GA2730@lunn.ch>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/08/2019 22:42, Andrew Lunn wrote:
> On Sun, Sep 08, 2019 at 12:07:27PM +0100, Vladimir Oltean wrote:
> > I think Richard has been there when the taprio, etf qdiscs, SO_TXTIME
> > were first defined and developed:
> > https://patchwork.ozlabs.org/cover/808504/
> > I expect he is capable of delivering a competent review of the entire
> > series, possibly way more competent than my patch set itself.
> > 
> > The reason why I'm not splitting it up is because I lose around 10 ns
> > of synchronization offset when using the hardware-corrected PTPCLKVAL
> > clock for timestamping rather than the PTPTSCLK free-running counter.
> 
> Hi Vladimir
> 
> I'm not suggesting anything is wrong with your concept, when i say
> split it up. It is more than when somebody sees 15 patches, they
> decide they don't have the time at the moment, and put it off until
> later. And often later never happens. If however they see a smaller
> number of patches, they think that yes they have time now, and do the
> review.
> 
> So if you are struggling to get something reviewed, make it more
> appealing for the reviewer. Salami tactics.
> 
>     Andrew

I vote for splitting it up.
I don't know enough about PTP and taprio/qdisc to review the entire series
but the interface presented in patch 09/15 fits well with our future TSN
switches.

Joergen Andreasen, Microchip
