Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3776034AEB4
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCZSnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 14:43:51 -0400
Received: from p3plsmtpa06-09.prod.phx3.secureserver.net ([173.201.192.110]:38938
        "EHLO p3plsmtpa06-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhCZSnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:43:15 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id PrQNl6AEyJpwyPrQNlR496; Fri, 26 Mar 2021 11:43:12 -0700
X-CMAE-Analysis: v=2.4 cv=O+T8ADxW c=1 sm=1 tr=0 ts=605e2b40
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=8nJEP1OIZ-IA:10 a=ju1L-fJbI1bCFiL-2sIA:9 a=wPNLvfGTeEIA:10
 a=fCgQI5UlmZDRPDxm0A3o:22
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     =?iso-8859-1?Q?'Pali_Roh=E1r'?= <pali@kernel.org>
Cc:     "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <arndb@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <brandon_chuang@edge-core.com>, <wally_wang@accton.com>,
        <aken_liu@edge-core.com>, <gulv@microsoft.com>,
        <jolevequ@microsoft.com>, <xinxliu@microsoft.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>, <don@thebollingers.org>
References: <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org> <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <005e01d71230$ad203be0$0760b3a0$@thebollingers.org> <YEL3ksdKIW7cVRh5@lunn.ch> <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org> <YEvILa9FK8qQs5QK@lunn.ch> <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org> <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001201d719c6$6ac826c0$40587440$@thebollingers.org> <YFJHN+raumcJ5/7M@lunn.ch> <20210320161021.fngdgxvherg4v3lr@pali>
In-Reply-To: <20210320161021.fngdgxvherg4v3lr@pali>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 26 Mar 2021 11:43:10 -0700
Message-ID: <011401d7226f$df50aec0$9df20c40$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHJzBD70eZUtOjpwplvz0EZ7wMKHAKKUBDlAzqPMqQBlNUnrQJT1D0gAif1GfUCN93UFQH9aXkeAgikA2gCDVXEaQGbWhwMqgNar5A=
Content-Language: en-us
X-CMAE-Envelope: MS4xfOwpOQMseSqhfMXaWHSOHlRp8V1rJLOJJzSjUD1wFmcdhK7IHxY52B5gvAQ47I3+bcWki53W9vrFSiP4OW64CIAlFSvJWscSQhb+63TMiQrjzHdkLg92
 4YBs+5zmqcCXCFd1Nq67PtoK2KqN3P8qKkSQJNJ+ZbcnaLLA+8I40rrKOEcf4xuSnJW6MoI4jhC7fb7oCtiSVWml3GG8IsAOcERxsf7TH+pL3+M2RAQDwP0E
 0nTUdEBFWwGqBd8GPC97xJ480Bgwdqf56xry7ekNelaMai8+KQCNPFd324roCVAvQ/1keSt5hxlfmOZ2NLy8FTJgZEnnP8m4Hs4SJvjt1hFIZtpYRoHzo6g2
 3MApiwjImW8gzKKza8cgU8rBV0lKewFIgmN0/TS6m48zyZqtc7MGQSBaulB2w3eKc6WZ4QUNocnSS1FqbJBFHQYPAtxkwHN3aGCWpsPPUhDfeSEHkQC0Szn5
 Poy10x7aTbkUEkfQQN1e82QIwu2yOpKvX4Tsy9aftdLahgUUBUZABZYrFnzxOn+qJSjKypbyw5svjLO5gFVPoXsVr8n6HhF1sW08X58fTBrgbLj6nnyUJ78Z
 ZW5kzH0XvJ/PKCi7aJPmYc6IvBKQw6uzU1wDcFP6OKIWQcaGb+Tg5CbzQ3niXS9tLkM=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello Don!
> 
> I have read whole discussion and your EEPROM patch proposal. But for me it
> looks like some kernel glue code for some old legacy / proprietary access
> method which does not have any usage outside of that old code.

I don't know if 'kernel glue code' is good or bad.  It is a driver.  It
locks access to a device so it can perform multiple accesses without
interference.  It organizes the data on a weird device into a simple linear
address space that can be accessed with open(), seek(), read() and write()
calls.

As for 'old code', this code and variations of it are under active
development by multiple Network OS vendors and multiple switch vendors, and
in production on hundreds of thousands of switches with millions of
SFP/QSFP/CMIS devices.  This stuff is running the biggest clouds in the
world.

> 
> Your code does not contain any quirks which are needed to read different
> EEPROMs in different SFP modules. As Andrew wrote there are lot of broken
> SFPs which needs special handling and this logic is already implemented in
> sfp.c and sfp-bus.c kernel drivers. These drivers then export EEPROM
> content to userspace via ethtool -m API in unified way and userspace does
> not implement any quirks (nor does not have to deal with quirks).

As a technical matter, you handle those quirks in the code that interprets
EEPROM data.  You have figured out what devices have what quirks, then coded
up solutions to make them work.  Then, after all the quirk handling is done,
you call the actual access routines (sfp_i2c_read() and sfp_i2c_write()) to
access the module EEPROMs.  My code works the same way, except in my
community all the interpretation of EEPROM data is done in user space.  You
may not like that, but it is not clear why you should care how my community
chooses to handle the data.  In this architecture, the only thing needed
from the kernel is the equivalent of sfp_i2c_read() and sfp_i2c_write, which
optoe provides.  The key point here is that my community wants the kernel to
just access the data.  No interpretation, no identification, no special
cases.

> 
> If you try to read EEPROM "incorrectly" then SFP module with its EEPROM
> chip (or emulation of chip) locks and is fully unusable after you unplug
it and
> plug it again. Kernel really should not export API to userspace which can
> cause "damage" to SFP modules. And currently it does *not* do it.

In my community, such devices are not tolerated.  Modules which can be
"damaged" should be thrown away.

Please be clear, I am not disagreeing with your implementation.  For your
GPON devices, you handle this in kernel code.  Cool.  Keep it that way.
Just don't make my community implement that where it is not needed and not
wanted.  Optoe just accesses the device.  Other layers handle interpretation
and quirks.  Your handling is in sfp.c, mine is in user space.  Not right or
wrong, just different.  Both work.

> 
> I have contributed code for some GPON SFP modules, so their EEPROM can
> be correctly read and exported to userspace via ethtool -m. So I know that
> this is very fragile area and needs to be properly handled.

My code is in use in cloud datacenters and campus switches around the world.
I know it needs to be properly handled.

> 
> So I do not see any reason why can be a new optoe method in _current_
> form useful. It does not implemented required things for handling
different
> EEPROM modules.

optoe would be useful in your current environment as a replacement for
sfp_i2c_read() and sfp_i2c_write().  Those routines just access the EEPROM.
They don't identify or interpret or implement quirk handling.  Neither does
optoe.

AND, optoe is useful to my community.  An ethtool -m solution could of
course be implemented, and all of the user space code that currently
accesses module EEPROM could be rewritten, but there would be no value in
that to my community.  What they have works just fine.

> 
> I would rather suggest you to use ethtool -m IOCTL API and in case it is
not
> suitable for QSFP (e.g. because of paging system) then extend this API.

optoe already handles QSFP and CMIS just fine.  The API does not need to be
extended for pages.  Indeed, the ethtool API has already implemented the
same linear address space to flatten out the two i2c addresses plus pages in
the various SFP/QSFP/CMIS specs.  optoe flattens the same way.

> 
> There were already proposals for using netlink socket interface which is
> today de-facto standard interface for new code. sysfs API for such thing
> really looks like some legacy code and nowadays we have better access
> methods.

netlink is the de-facto standard interface for kernel networking.  My
community does not have kernel networking (except for a puny management
port).  All of the switch networking is handled by the switch ASIC, and in
user space network management software.  Which is 'better' is complicated,
depending on the needs and requirements of the application.  A large and
vibrant community is using a different architecture.  All I am asking for is
to submit a simple kernel driver that this community has found useful.

> 
> If you want, I can help you with these steps and make patches to be in
> acceptable state; not written in "legacy" style. As I'm working with GPON
SFP
> modules with different EEPROMs in them, I'm really interested in any
> improvements in their EEPROM area.

You will find this odd, but I don't actually have any way to test anything
using the kernel network stack with these devices.  The only hardware I have
treats SFP/QSFP/CMIS devices as i2c addresses.  There is no concept of these
being network devices in the linux kernels I'm running.  So, I'll turn your
offer around...  I can help you improve your EEPROM access code, unless you
already have all the good stuff.  The things optoe does that
sfp_i2c_read/write() don't do are:

Page support:  Check whether pages are supported, then lock the device,
write the page register as needed, and return it to 0 when finished.
Check legal access:  Based on page support, and which spec (SFP, QSFP,
CMIS), figure out if the offset and length are legal.  This is more
interesting when flattening to a linear address space, less interesting in
the new API with i2c_addr, page, bank, offset, len all specified.
Support all 256 architected pages:  There are interesting capabilities that
vendors provide in spec-approved 'proprietary' pages.  Don't ask, don't
interpret, don't deny access.  Just execute the requested read/write.

Don

