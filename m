Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E02D149768
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 20:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgAYTQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 14:16:15 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:4736 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYTQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 14:16:15 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: x4hJIa9iFYOUSnyqOswuEs0+n+ZxsmpfPXpEgiDhuhDL0Gwz6TaW3pQJqhqTRYRY8gh+3zqhda
 4w1HvNB6gKkxBTF/2gIHo9+DBL2gd2zi2Orhow8IJD3v21SpsDEfhDSIDwCC3m1ah7LgXCUQ/O
 NRS+wpWlgnfnKYhumxYyfCRN7yyFCNHRebzFu1l9AUhz63JQ6F4VUv++HJ4ltlqUOfqb1Sjk0O
 nGm/t/9lu1JP+PHCsNE+SicBt2LBUxoWDLOj0dKn0q24PQhb56yAGy51iCca6qNLHM3zbMsXDx
 Zto=
X-IronPort-AV: E=Sophos;i="5.70,362,1574146800"; 
   d="scan'208";a="63745682"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2020 12:16:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 Jan 2020 12:16:11 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 25 Jan 2020 12:16:13 -0700
Date:   Sat, 25 Jan 2020 20:16:12 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 03/10] net: bridge: mrp: Add MRP interface used
 by netlink
Message-ID: <20200125191612.5dlzlvb7g2bucqna@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-4-horatiu.vultur@microchip.com>
 <20200124174315.GC13647@lunn.ch>
 <20200125113726.ousbmm4n3ab4xnqt@soft-dev3.microsemi.net>
 <20200125152023.GA18311@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200125152023.GA18311@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.2020 16:20, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Sat, Jan 25, 2020 at 12:37:26PM +0100, Horatiu Vultur wrote:
>> The 01/24/2020 18:43, Andrew Lunn wrote:
>> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> >
>> > > br_mrp_flush - will flush the FDB.
>> >
>> > How does this differ from a normal bridge flush? I assume there is a
>> > way for user space to flush the bridge FDB.
>>
>> Hi,
>>
>> If I seen corectly the normal bridge flush will clear the entire FDB for
>> all the ports of the bridge. In this case it is require to clear FDB
>> entries only for the ring ports.
>
>Maybe it would be better to extend the current bridge netlink call to
>be able to pass an optional interface to be flushed?  I'm not sure it
>is a good idea to have two APIs doing very similar things.
I agree.

And when looking at this again, I start to think that we should have
extended the existing netlink interface with new commands, instead of
adding a generic netlink.

/Allan

