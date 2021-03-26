Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3D234B113
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 22:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCZVJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 17:09:51 -0400
Received: from p3plsmtpa09-03.prod.phx3.secureserver.net ([173.201.193.232]:35476
        "EHLO p3plsmtpa09-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhCZVJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 17:09:42 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id Pti5lXABrc40iPti6l1OKO; Fri, 26 Mar 2021 14:09:38 -0700
X-CMAE-Analysis: v=2.4 cv=Cot6zl0D c=1 sm=1 tr=0 ts=605e4d92
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=MXRq0mXx-RAhC34I2ScA:9 a=CjuIK1q_8ugA:10
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
References: <YEvILa9FK8qQs5QK@lunn.ch> <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org> <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001201d719c6$6ac826c0$40587440$@thebollingers.org> <YFJHN+raumcJ5/7M@lunn.ch> <009601d72023$b73dbde0$25b939a0$@thebollingers.org> <YFpr2RyiwX10SNbD@lunn.ch> <011301d7226f$dc2426f0$946c74d0$@thebollingers.org> <YF46FI4epRGwlyP8@lunn.ch> <011901d7227c$e00015b0$a0004110$@thebollingers.org> <YF5GA1RbaM1Ht3nl@lunn.ch>
In-Reply-To: <YF5GA1RbaM1Ht3nl@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 26 Mar 2021 14:09:36 -0700
Message-ID: <011c01d72284$544c8f50$fce5adf0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIn9Rn138S2ieljdt1P4rieupeZMgI33dQVAf1peR4CCKQDaAINVcRpAhqKAxkCWKqBOgE8vtiLAcIzA0wBJxcy+QL8fwBAqVYSElA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfLRug2nTtgck3zuB/MqhLW554hPRoikOzK4oHb9MSlI7Lzok5YXIT23Dmvt7Ad92psmBxLRMFTM0fxF70aXfPerCxbv6cWA7REEIwYryp03n7r3ZIocV
 DdAyhyMO2ZcgxeXXBFu6vVfUS6Cka1g7LMtwidJkcGlW4ERipAlpczUptgddznbdZ6ayOGmP/SXvdZiDIKaCH3qnDzJNzDnXzaLvTS4CHjBQNmLzmSBHq2jq
 k2W++/blyeWZ1FC0dWqFQwHRXg6tj0rsnN4AKqGvYDr5OzyIMskAljW/oc7x4Jc1N2rfBGLjgrSX6eg7WzyzDJK1ym0FkVmqfWwYy4Xg3zfn4apfHSyP6FI6
 JBUJmd4rq3iS8z2pYaEeKlBEx7f8A9xZv02bvVYXKf215cGU4DxfdAI/5NnwRqn8HIhtJUIaA92hA0g95OdlGHwZqoGbMM0eUfdZcIueROXjxlAn4wvTxBTg
 5WomIELpXiM4vS48VmZiQJSn11/hAw3Csk7qHFYmj1qmzeDOL5o+PB/fBscAXebZNYFK+/UYxTwn3Gscv8N4+ZgTOeOUY1JVJsoAoJl67+qlTFui09RYXPTp
 EYQj50LTyjsj8c0Nls1HaePf
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 01:37PM -0700, Andrew Lunn wrote:
> On Fri, Mar 26, 2021 at 01:16:14PM -0700, Don Bollinger wrote:
> > > > In my community, the SFP/QSFP/CMIS devices (32 to 128 of them per
> > > > switch) often cost more than the switch itself.  Consumers (both
> > > > vendors and
> > > > customers) extensively test these devices to ensure correct and
> > > > reliable operation.  Then they buy them literally by the millions.
> > > > Quirks lead to quick rejection in favor of reliable parts from
> > > > reliable vendors.  In this environment, for completely different
> > > > reasons, optoe does not need to handle quirks.
> > >
> > > Well, if optoe were to be merged, it would not be just for your
> community.
> > It
> > > has to work for everybody who wants to use the Linux kernel with an
> SFP.
> > > You cannot decide to add a KAPI which just supports a subset of
> > > SFPs. It needs to support as many as possible, warts and all.
> > >
> > > So how would you handle these SFPs with the optoe KAPI?
> >
> > Just like they are handled now.  Folks who use your stack would filter
> > through sfp.c, with all the quirk handling, and eventually call optoe
> > for the actual device access.  Folks who don't use kernel networking
> > would call optoe directly and limit themselves to well behaved SFPs,
> > or would handle quirks in user space.  You think that's dumb, but
> > there is clearly a market for that approach.  It is working, at scale,
today.
> >
> > BTW, why can't we have a driver
> 
> You keep missing the point. I always refer to the KAPI. The driver we can
> rework and rework, throw away and reimplement, as much as we want.
> The KAPI cannot be changed, it is ABI. It is pretty much frozen the day
the
> code is first committed.

Maybe I don't understand what you mean by KAPI.  The KAPI that optoe exposes
is in two parts.

First, it makes the EEPROM accessible via the nvmem() interface, an existing
KAPI that I call from optoe.  at24 implemented it, I made use of it.  This
interface exposes EEPROM data to user space through a defined sysfs() file.
I didn't invent this, nor am I proposing it, it already exists.

Second, it specifies how the data in the EEPROM is accessed.  It says that
low memory is in offset 0-127, and paged memory starts at offset (128 +
(page * 128)).  For SFP devices, memory at i2c address 0x50 is the first 256
bytes, and everything at 0x51 is pushed up 256 bytes.  This is exactly the
behavior of ethtool.  Again, I didn't invent this, I adopted the existing
convention for how to flatten the SFP/QSFP/CMIS address space.

With these two parts, EEPROM data can be accessed by standard open(2),
seek(2), read(2), write(2) calls.  Nothing special there, the actual syntax
is as old school and standard as you can possibly get.

So, what is wrong with that KAPI?

The only thing wrong I can see is that it doesn't use the kernel network
stack.  Here's where "you keep missing the point".  The kernel network stack
is not being used in these systems.  Implementing EEPROM access through
ethtool is of course possible, but it is a lot of work with no benefit on
these systems.  The simple approach works.  Let me use it.

> 
> The optoe KAPI needs to handle these 'interesting' SFP modules. The KAPI
> design needs to be flexible enough that the driver underneath it can be
> extended to support these SFPs. The code does not need to be there, but
> the KAPI design needs to allow it. And i personally cannot see how the
optoe
> KAPI can efficiently support these SFPs.

Help me understand.  Your KAPI specifies ethtool as the KAPI, and the
ethtool/netlink stack as the interface through which the data flows.  As I
see it, your KAPI only specifies i2c address, page, bank, offset and length.
How does your KAPI support interesting SFP modules but mine does not?  optoe
could be reworked ad infinitum to implement support for quirks, just as
yours can.  Neither has any hint of quirks in the KAPI.

Don

