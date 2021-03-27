Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E2734B96E
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 22:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhC0VUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 17:20:31 -0400
Received: from p3plsmtpa09-05.prod.phx3.secureserver.net ([173.201.193.234]:60543
        "EHLO p3plsmtpa09-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhC0VUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 17:20:30 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id QGM6lRWhiMmrXQGM6lodpf; Sat, 27 Mar 2021 14:20:27 -0700
X-CMAE-Analysis: v=2.4 cv=A7Opg4aG c=1 sm=1 tr=0 ts=605fa19b
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=PJJbkYOYmc0sqGGVcoMA:9 a=CjuIK1q_8ugA:10
 a=fCgQI5UlmZDRPDxm0A3o:22
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Jakub Kicinski'" <kuba@kernel.org>, <arndb@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <brandon_chuang@edge-core.com>, <wally_wang@accton.com>,
        <aken_liu@edge-core.com>, <gulv@microsoft.com>,
        <jolevequ@microsoft.com>, <xinxliu@microsoft.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>, <don@thebollingers.org>
References: <YFJHN+raumcJ5/7M@lunn.ch> <009601d72023$b73dbde0$25b939a0$@thebollingers.org> <YFpr2RyiwX10SNbD@lunn.ch> <011301d7226f$dc2426f0$946c74d0$@thebollingers.org> <YF46FI4epRGwlyP8@lunn.ch> <011901d7227c$e00015b0$a0004110$@thebollingers.org> <YF5GA1RbaM1Ht3nl@lunn.ch> <011c01d72284$544c8f50$fce5adf0$@thebollingers.org> <YF5YAQvQXCn4QapJ@lunn.ch> <012b01d7228f$a2547270$e6fd5750$@thebollingers.org> <YF9OhSBHnDVqW5JQ@lunn.ch>
In-Reply-To: <YF9OhSBHnDVqW5JQ@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Sat, 27 Mar 2021 14:20:25 -0700
Message-ID: <000a01d7234f$014c86e0$03e594a0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQINVcRpsFmSd8p6ExIoJZuuUEJOmwIaigMZAliqgToBPL7YiwHCMwNMAScXMvkC/H8AQAITP11bAdk342UCViFklAE2Yat3qZN1GUA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfLZF8Aj7h5DLQqWuRn8PQb78lAQEMYpEnRPtqBDGwB0Z9E0qdyd9wYUQr+cB4F8KOftpd+0fv2tTnAUERr7ER/uHY2dEle2klCV5qxT9+S7HTjY8I6NY
 XHglpWKejNzRacfTXHQf/46aAlylO1hXhkDqtND4RXviuxr0aIw7rly2gvOuskbkGfILas5Rez6Qcg4fNhSJwRHwzO8M/dKmnkYpDCztdii+TENGsLOKUWGG
 Z4aK1ChiZHxb09SxKeOKFK/07ph3pDJmOxcjqQeZgShbPhHpLfa+PK2ukDP9LuUyDjheELox32S5bU+7fA7D/ofooxlGCE1CyJnBFk69IqR+jxRNMx3m56tH
 M6Re+kz28RTnAXqzzye9K5his49kugujdyAPkda8IZ66vkA0/1LwIq60O1xft61k+2QEP5F0nMHbEqlIzDtzlL0o3pkRrMGDDLw3ixtcu16RSwbYVmic4e1X
 H8SEp/tYu3fp1XEra3gcLl6ENYfSijO+T8pgqi3N2i0HLOlPPaeR8Q/86lDGvC6IRl5Wcwi60NwbYn3i5cUQSVLdm1B5KHFDSO4AW6rdNQc3sqq4ziysuRCt
 RwX+Z0f8Kj0GECuzgRZ7QTcV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > What I have works.  Your consumers get quirk handling, mine don't need
it.
> > No compromise.
> 
> Hi Don
> 
> All this discussion is now a mute point. GregKH has spoken.

Ack.  I actually checked in with Greg a couple of days ago and got that
answer.  I just thought the discussion was going in an interesting direction
and didn't want to end it yet.  Response below is in the same vein.

> 
> But i'm sure there are some on the side lines, eating popcorn, maybe
> learning from the discussion.

Honestly not sure what they are learning from the discussion.  I think what
I learned is not what you think you taught me.

> 
> Would you think it is O.K. to add a KAPI which works for 3 1/2" SCSI
disks, but
> not 2", because you only make machines with 3 1/2" bays?

No.  Not sure how the analogy works.  QSFP is a larger form factor than SFP,
and the EEPROM layout changed at the same time, but optoe and my community
had no problem accommodating both.  CMIS changed the EEPROM layout again,
but it was easily accommodated.

> 
> This is an extreme, absurd example, but hopefully you get the point. We
> don't design KAPIs with the intention to only work for a subset of
devices. It
> needs to work with as many devices as possible, even if the first
> implementation below the KAPI is limited to just a subset.

Let me run with your example...  Suppose I used those 3 1/2" SCSI disks to
build storage servers.  Let's call them RAID devices.  Innovation follows, I
figure out how to make these devices hot swappable, hot backup, massively
parallel...  Innovation follows and I evolve this into a distributed
architecture with redundant data, encrypted, compressed, distributed across
servers and data centers.  Massively parallel, synchronized, access to the
data anywhere in the world, at bandwidth limited only by the size of your
network pipe.  Let's call it RIDSS (Redundant, Independent, Distributed
Storage Servers).  And I can use 2" disks.  Or non-spinning storage.

My fancy technology thinks the storage is dumb.  I present a
track/sector/length and I get back the bits.  Just for grins, let's say I
can also query the device for a list of bad blocks (sectors, whatever).

Recently, with the addition of 2" devices, YOU figured out that you can
stuff several disks into a small space, and manage them with software and
call it RAID.  You build a nice abstraction for storage, which contains
individual disks, and handles parallelism, redundancy, hot swap.  Very cool,
works well, a genuine innovation.

I've been using Linux for RIDSS for years, I get the memo that my linux
driver to access these SCSI devices should be in the upstream kernel.
Oddly, there are no drivers in the kernel that I can just present
track/sector/length and get back the bits.  So, I offer mine.  The answer is
no, that is a RAID device, you need to access the device through RAID data
structures and APIs.

Sorry, no, that is not a RAID device.  That is a storage device.  You use it
for RAID storage, I use it for RIDSS storage.  We need a layered
architecture with raw data access at the bottom (we both need the same
track/sector/length access).  Beyond that, your RAID stack, while brilliant,
has virtually nothing to do with my RIDSS stack.  They sound superficially
similar, but the technology and architecture are wildly different.  The RAID
stack is unnecessary for my RIDSS architecture, and requires widespread
changes to my software that yield no benefit.

So, no, I don't get your point.  I think there is value in a simple layered
architecture, where access to the module EEPROM is independent of the
consumer of that access.  You can access it for kernel networking, which is
useful, innovative, valuable.  I can access it for TOR switches which do not
use kernel networking but are nonetheless useful, innovative, valuable.
Your decision to reject optoe means the TOR community has to maintain this
simple bit of kernel code outside the mainline tree.  The judges have ruled,
case closed.

> 
> Anyway, i'm gratefull you have looked at the new ethtool netlink KAPI. It
will
> be better for your contributions. And i hope you can make use of it in the

Thanks for the acknowledgement.  

> future. But i think this discussion about optoe in mainline is over.

This discussion is indeed over if you say it is.  I'll be moving on :-(.

> 
>      Andrew

Don

