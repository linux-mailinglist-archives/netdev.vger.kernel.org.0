Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F3C15F60
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 10:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEGIaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 04:30:22 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:57965 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfEGIaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 04:30:21 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Joergen.Andreasen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="Joergen.Andreasen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Joergen.Andreasen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Joergen.Andreasen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,441,1549954800"; 
   d="scan'208";a="31898599"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 May 2019 01:30:20 -0700
Received: from localhost (10.10.76.4) by chn-sv-exch07.mchp-main.com
 (10.10.76.108) with Microsoft SMTP Server id 14.3.352.0; Tue, 7 May 2019
 01:30:14 -0700
Date:   Tue, 7 May 2019 10:30:13 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        "James Hogan" <jhogan@kernel.org>, <linux-mips@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 2/3] net: mscc: ocelot: Implement port policers
 via tc command
Message-ID: <20190507083012.4yjd7ok6dhzkrdf7@soft-dev16>
References: <20190502094029.22526-1-joergen.andreasen@microchip.com>
 <20190502094029.22526-3-joergen.andreasen@microchip.com>
 <20190504130726.GA14684@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190504130726.GA14684@nanopsycho.orion>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

The 05/04/2019 15:07, Jiri Pirko wrote:
> External E-Mail
> 
> 
> Thu, May 02, 2019 at 11:40:28AM CEST, joergen.andreasen@microchip.com wrote:
> >Hardware offload of port policers are now supported via the tc command.
> >Supported police parameters are: rate, burst and overhead.
> 
> Joergen, please see:
> [PATCH net-next 00/13] net: act_police offload support
> That patchset is also pushing flow intermediate representation for this,
> so I believe that you should base this patch on top of that.
> 

I will base my patches on top of that.

-- 
Joergen Andreasen, Microchip
