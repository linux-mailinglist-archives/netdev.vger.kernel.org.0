Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19F3714975F
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 20:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgAYTM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 14:12:59 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:59937 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYTM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 14:12:58 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: ppyGr4ZrbbLxA9FJJpjlT4jyq7JrfUhPuP8l8uVPYjEJDwjLTEidleLsv7UMa+xPh3ldIAd405
 lgIPgQZS54dr1HgBm0nXCX3/McHZdKU5xyW+kubq5dDmjaNuennDaifGt2QxTq2vlrRFbOBCwG
 tt9zxjblPCr92vK/XdEfk+fMCkUd1WL8ZQFY7oNvJ8baQmP5bU+kdpWsg4mXdMvavEU+uYsonm
 v4ocG5uzlp3n5cMQ8cp8eVdiv0I/EkFiFb4EOsYQbdhagLK5OITrcMNCG0BOnD/JYoS2/xiHpH
 t4Q=
X-IronPort-AV: E=Sophos;i="5.70,362,1574146800"; 
   d="scan'208";a="66006820"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2020 12:12:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 Jan 2020 12:12:37 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 25 Jan 2020 12:12:39 -0700
Date:   Sat, 25 Jan 2020 20:12:38 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 00/10]  net: bridge: mrp: Add support for Media
 Redundancy Protocol (MRP)
Message-ID: <20200125191238.qdtd2elypnz6ewhm@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124203406.2ci7w3w6zzj6yibz@lx-anielsen.microsemi.net>
 <87zhecimza.fsf@linux.intel.com>
 <20200125094441.kgbw7rdkuleqn23a@lx-anielsen.microsemi.net>
 <20200125162357.GE18311@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200125162357.GE18311@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.01.2020 17:23, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> Lets say that the link between H1 and H2 goes down:
>>
>>     +------------------------------------------+
>>     |                                          |
>>     +-->|H1|<---  / --->|H2|<---------->|H3|<--+
>>     eth0    eth1    eth0    eth1    eth0    eth1
>>
>> H1 will now observe that the test packets it sends on eth1, is not
>> received in eth0, meaninf that the ring is open
>
>Is H1 the only device sending test packets? It is assumed that H2 and
>H3 will forward them?
Horatiu, please correct me if I'm wrong, you have been spending more
time with the standard.

It is only the manager/MRM (in this case H1) which sends test-frames.
The other nodes (the MRC's) must forward the MRP-test frames, but only
on the ports which is part of the ring.

> Or does each device send test packets, and when it stops hearing these
> packets from a neighbour, it assumes the link is open?
No.

This also means that most non-MRP aware switches can properly act as
MRC with HW offload. It is good to have that in mind when reviewing the
netlink interface.

It is worth mentioning that the client shall send a frame if they see a
link up/down on one of the ring ports. This is to allow the manager to
react faster.

Also, in this first patch we have only defined the MRM and MRC roles. In
future version we would also like to support a MRA (auto manager), where
the clients is monitoring the test frames, and if there are no manager
(it disappear, or they are all MRA) then they can negotiate who should
take the role as manager.

/Allan
