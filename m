Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C83614A30E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbgA0Lbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:31:32 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:22091 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgA0Lbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:31:32 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: CHJf1jjbC+hNXjcALXRPG34+geA7/A0vihzr4yW4wdZ4shNAyUBnNGMpFS+3gJUo1GmhjrEcN5
 1ayIJgz/ZWq+Y6giZQradd5Kb3HdZ0Wj1az65D7HU91WJu5HvixdXl3+aTU5S2k6cQuY8QYZcm
 q+yUeb4C+SZGu0zXaR+aYe5NKT1vfPTv8UfKnlDmWEG7CHA9/rDBx/Kma8JmhAgTgCSxufVU77
 YFpSAo6/7kw6EIr68WpHCd2V9lmKu9HKGAroxpZsXiNTh7yzohuh5mV6U4G5FRKRhGzjEhzuIy
 IgY=
X-IronPort-AV: E=Sophos;i="5.70,369,1574146800"; 
   d="scan'208";a="189991"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2020 04:04:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 27 Jan 2020 04:04:19 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 27 Jan 2020 04:04:19 -0700
Date:   Mon, 27 Jan 2020 12:04:18 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
Message-ID: <20200127110418.f7443ecls6ih2fwt@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-7-horatiu.vultur@microchip.com>
 <20200125163504.GF18311@lunn.ch>
 <20200126132213.fmxl5mgol5qauwym@soft-dev3.microsemi.net>
 <20200126155911.GJ18311@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200126155911.GJ18311@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2020 16:59, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Sun, Jan 26, 2020 at 02:22:13PM +0100, Horatiu Vultur wrote:
>> The 01/25/2020 17:35, Andrew Lunn wrote:
>> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> >
>> > > SWITCHDEV_OBJ_ID_RING_TEST_MRP: This is used when to start/stop sending
>> > >   MRP_Test frames on the mrp ring ports. This is called only on nodes that have
>> > >   the role Media Redundancy Manager.
>> >
>> > How do you handle the 'headless chicken' scenario? User space tells
>> > the port to start sending MRP_Test frames. It then dies. The hardware
>> > continues sending these messages, and the neighbours thinks everything
>> > is O.K, but in reality the state machine is dead, and when the ring
>> > breaks, the daemon is not there to fix it?
I agree, we need to find a solution to this issue.

>> > And it is not just the daemon that could die. The kernel could opps or
>> > deadlock, etc.
>> >
>> > For a robust design, it seems like SWITCHDEV_OBJ_ID_RING_TEST_MRP
>> > should mean: start sending MRP_Test frames for the next X seconds, and
>> > then stop. And the request is repeated every X-1 seconds.
Sounds like a good idea to me.

>> I totally missed this case, I will update this as you suggest.
>
>What does your hardware actually provide?
>
>Given the design of the protocol, if the hardware decides the OS etc
>is dead, it should stop sending MRP_TEST frames and unblock the ports.
>If then becomes a 'dumb switch', and for a short time there will be a
>broadcast storm. Hopefully one of the other nodes will then take over
>the role and block a port.
As far as I know, the only feature HW has to prevent this is a
watch-dog timer. Which will reset the entire system (not a bad idea if
the kernel has dead-locked).

/Allan

