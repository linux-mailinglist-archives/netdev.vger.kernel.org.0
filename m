Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137E014B268
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 11:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgA1KRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 05:17:08 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:26363 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgA1KRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 05:17:07 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 9jdNgCZGuP6bJohSpAGjTFqulzRwrCR6WykVri09mT96SVtGibejsxkw6Y5OJmjLqei5kFDQfK
 aGJN429epJRrfeu6OqgZ+95w6Qyz9XoSqdSZPIS8ekKn4VvXxB5s05bbqaz3Wk0dn5HcYtTdLk
 Hyo6Ldu153cVwziRkmLI81CE9JhadQQO/K6yu076Ec6eeq63okYRQaBEo9sgQafVIT7/ncmYbt
 p3EMGwpsawXo51xKFlWfZ30LCpga72VxRTuWm+AQr0sAHQEikD2ZZNEFCmMp0cppmP+ESzKBH5
 p6M=
X-IronPort-AV: E=Sophos;i="5.70,373,1574146800"; 
   d="scan'208";a="63312956"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jan 2020 03:17:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 Jan 2020 03:17:06 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 28 Jan 2020 03:17:07 -0700
Date:   Tue, 28 Jan 2020 11:17:04 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 09/10] net: bridge: mrp: Integrate MRP into the
 bridge
Message-ID: <20200128101704.kjqok4lvpgo73pzz@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-10-horatiu.vultur@microchip.com>
 <20200125161615.GD18311@lunn.ch>
 <20200126130111.o75gskwe2fmfd4g5@soft-dev3.microsemi.net>
 <20200126171251.GK18311@lunn.ch>
 <20200127105746.i2txggfnql4povje@lx-anielsen.microsemi.net>
 <20200127134053.GG12816@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200127134053.GG12816@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.01.2020 14:40, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> > 'Thinking allowed' here.
>> >
>> >     +------------------------------------------+
>> >     |                                          |
>> >     +-->|H1|<---------->|H2|<---------->|H3|<--+
>> >     eth0    eth1    eth0    eth1    eth0    eth1
>> >      ^
>> >      |
>> >   Blocked
>> >
>> >
>> > There are three major classes of user case here:
>> >
>> > 1) Pure software solution
>> > You need the software bridge in the client to forward these frames
>> > from the left side to the right side.
>
>> As far as I understand it is not the bridge which forward these frames -
>> it is the user-space tool. This was to put as much functionality in
>> user-space and only use the kernel to configure the HW. We can (and
>> should) discuss if this is the right decision.
>
>So i need to flip the point around. How does the software switch know
>not to forward the frames? Are you adding an MDB?
In the current implementation (patch v3) this is done here:
https://github.com/microchip-ung/mrp/blob/patch-v3/kernel-patches/v3-0009-net-bridge-mrp-Integrate-MRP-into-the-bridge.patch#L112

We simply ask the bridge not to forward any MRP frames, on MRP enabled
ports, and let "someone" else do that.

>> We would properly have better performance if we do this in kernel-space.
>
>Yes, that is what i think. And if you can do it without any additional
>code, using the forwarding tables, so much the better.
I understand the motivation of using the existing forwarding mechanism,
but I do not think we have all the hooks needed. But we can certainly
limit the impact on the existing code as much as possible.

>> BTW: It is not only from left to right, it is also from right to left.
>> The MRM will inject packets on both ring ports, and monitor both.
>
>Using the same MAC address in both directions? I need to think what
>that implies for MDB entries. It probably just works, since you never
>flood back out the ingress port.
Seems to work fine :-D

>> Again, I do not know how other HW is designed, but all the SOC's we are
>> working with, does allow us to add a TCAM rule which can redirect these
>> frames to the CPU even on a blocked port.
>
>It is not in scope for what you are doing, but i wonder how we
>describe this in a generic Linux way? And then how we push it down to
>the hardware?
>
>For the Marvell Switches, it might be possible to do this without the
>TCAM. You can add forwarding DB entries marked as Management. It is
>unclear if this overrides the blocked state, but it would be a bit odd
>if it did not.
Based on this, and also on the input from Jürgen, I think there is a
good chnage we can make this work for existing silicon from several
vendors.

>> > You could avoid this by adding MDB entries to the bridge. However,
>> > this does not scale to more then one ring.
>> I would prefer a solution where the individual drivers can do what is
>> best on the given HW.
>The nice thing about adding MDB is that it is making use of the
>software bridge facilities. In general, the software bridge and
>hardware bridges are pretty similar. If you can solve the problem
>using generic software bridge features, not additional special cases
>in code, you have good chance of being able to offload it to a
>hardware bridge which is not MRP aware. The switchdev API for MRP
>specific features should then allow you to make use of any additional
>features the hardware might have.
Yes, but the issues in using the MDB API for this is that it does not
allow to look at source ports, and it does not allow to update the
priority of the frames.

>> Yes, the solution Horatiu has chosen, is not to forward MRP frames,
>> received in MRP ring ports at all. This is done by the user-space tool.
>>
>> Again, not sure if this is the right way to do it, but it is what patch
>> v3 does.
>>
>> The alternative to this would be to learn the bridge how to forward MRP
>> frames when it is a MRC. The user-space tool then never needs to do
>> this, it know that the kernel will take care of this part (either in SW
>> or in HW).
>I think that should be considered. I'm not saying it is the best way,
>just that some thought should be put into it to figure out what it
>actually implies.
Sounds good - I will try to explain and illustrate this a bit better,
such that we all have the same understanding of the problem we need to
solve.

/Allan

