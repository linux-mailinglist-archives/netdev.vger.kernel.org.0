Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF90714A3D2
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgA0M1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:27:55 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:38937 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbgA0M1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:27:55 -0500
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
IronPort-SDR: 4B1hpSLMfQHQjW00Ezbg18zveEZR30AOexDBQTrvB5wcXMHTG6JUGKbbqK2VG4B7aMcln5BDRQ
 z1zCIT/7uj1LVIBNUhkf0uBt3gky8JPa9uPCcukI7pc+lrO06vOtRimVWYvfK6ePOtn8PWb7c0
 ttssy+xiG10Ydg7BxvYodU6M1Up+ygaHgjln3TZeKeVUlnpusHukiODAS5P9qJO6O9aFRrI+Ko
 6Ng3J6g0aPCnuL1a110EZX46N2OoLQWB1KeaUzXXGVbym1SIPqUbknJqNKe+QhDLoA9V8RcvvC
 QUA=
X-IronPort-AV: E=Sophos;i="5.70,369,1574146800"; 
   d="scan'208";a="63842471"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2020 05:27:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 27 Jan 2020 05:27:53 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 27 Jan 2020 05:27:52 -0700
Date:   Mon, 27 Jan 2020 13:27:52 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     =?utf-8?Q?J=C3=BCrgen?= Lambrecht <j.lambrecht@televic.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
Message-ID: <20200127122752.g4eanjl2naazyfh3@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-7-horatiu.vultur@microchip.com>
 <20200125163504.GF18311@lunn.ch>
 <20200126132213.fmxl5mgol5qauwym@soft-dev3.microsemi.net>
 <20200126155911.GJ18311@lunn.ch>
 <13ac391c-61f5-cb77-69a0-416b0390f50d@televic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13ac391c-61f5-cb77-69a0-416b0390f50d@televic.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jürgen,

On 27.01.2020 12:29, Jürgen Lambrecht wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On 1/26/20 4:59 PM, Andrew Lunn wrote:
>> Given the design of the protocol, if the hardware decides the OS etc
>> is dead, it should stop sending MRP_TEST frames and unblock the ports.
>> If then becomes a 'dumb switch', and for a short time there will be a
>> broadcast storm. Hopefully one of the other nodes will then take over
>> the role and block a port.

>In my experience a closed loop should never happen. It can make
>software crash and give other problems.  An other node should first
>take over before unblocking the ring ports. (If this is possible - I
>only follow this discussion halfly)
>
>What is your opinion?
Having loops in the network is never a good thing - but to be honest, I
think it is more important that we ensure the design can survive and
recover from loops.

With the current design, it will be really hard to void loops when the
network boot. MRP will actually start with the ports blocked, but they
will be unblocked in the period from when the bridge is created and
until MRP is enabled. If we want to change this (which I'm not too keen
on), then we need to be able to block the ports while the bridge is
down.

And even if we do this, then we can not guarantee to avoid loops. Lets
assume we have a small ring with just 2 nodes: a MRM and a MRC. Lets
assume the MRM boots first. It will unblock both ports as the ring is
open. Now the MRC boots, and make the ring closed, and create a loop.
This will take some time (milliseconds) before the MRM notice this and
block one of the ports.

But while we are at this topic, we need to add some functionality to
the user-space application such that it can set the priority of the MRP
frames. We will get that fixed.

>(FYI: I made that mistake once doing a proof-of-concept ring design:
>during testing, when a "broken" Ethernet cable was "fixed" I had for a
>short time a loop, and then it happened often that that port of the
>(Marvell 88E6063) switch was blocked.  (To unblock, only solution was
>to bring that port down and up again, and then all "lost" packets came
>out in a burst.) That problem was caused by flow control (with pause
>frames), and disabling flow control fixed it, but flow-control is
>default on as far as I know.)
I see. It could be fun to see if what we have proposed so far will with
with such a switch.

/Allan

