Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF2E34B22C
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 23:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCZWau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 18:30:50 -0400
Received: from p3plsmtpa06-04.prod.phx3.secureserver.net ([173.201.192.105]:55572
        "EHLO p3plsmtpa06-04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhCZWae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 18:30:34 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id PuyPlPYLbe8QFPuyPlZ0t6; Fri, 26 Mar 2021 15:30:33 -0700
X-CMAE-Analysis: v=2.4 cv=JLz+D+Gb c=1 sm=1 tr=0 ts=605e608a
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=eUCHAjWJAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=B9N1SL4tAAAA:8 a=ZZ8IlgSgAAAA:8 a=yMhMjlubAAAA:8 a=Ikd4Dj_1AAAA:8
 a=5dq06bJRMOhGB6Ww62IA:9 a=CjuIK1q_8ugA:10 a=e1s5y4BJLze_2YVawdyF:22
 a=AjGcO6oz07-iQ99wixmX:22 a=Yupwre4RP9_Eg_Bd0iYG:22 a=2pORUOBALVJw3eK4Rqq-:22
 a=bnemC1k7u3fE13R9927P:22 a=fCgQI5UlmZDRPDxm0A3o:22
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
References: <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001201d719c6$6ac826c0$40587440$@thebollingers.org> <YFJHN+raumcJ5/7M@lunn.ch> <009601d72023$b73dbde0$25b939a0$@thebollingers.org> <YFpr2RyiwX10SNbD@lunn.ch> <011301d7226f$dc2426f0$946c74d0$@thebollingers.org> <YF46FI4epRGwlyP8@lunn.ch> <011901d7227c$e00015b0$a0004110$@thebollingers.org> <YF5GA1RbaM1Ht3nl@lunn.ch> <011c01d72284$544c8f50$fce5adf0$@thebollingers.org> <YF5YAQvQXCn4QapJ@lunn.ch>
In-Reply-To: <YF5YAQvQXCn4QapJ@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 26 Mar 2021 15:30:32 -0700
Message-ID: <012b01d7228f$a2547270$e6fd5750$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQH9aXkeZ4lqQ1ZQrb2WfCNr9Tv/fAIIpANoAg1VxGkCGooDGQJYqoE6ATy+2IsBwjMDTAEnFzL5Avx/AEACEz9dWwHZN+Nlqa2GGDA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfKG1f3sajmw/3TQ4HBTVzN+gt6W8vBhwPPpNhTdMFowlxM9GrdbeIy34XVm9sMerlgjDVOPhyUjTwROoQ/fguT3zv/RLq6KdcTG2zsZzVCDx7lb+BZ2Z
 rPdJQAmZZ+JjBMDAgIrX1nThBS6WKCbL0BbuIQ+9Hi23lccnH8Y2yiIqxdMpM3TeT94vSqfW+ffh9cK5b9waTaYWGB3N5Djz9f2jPYr8zIHLlTMiqBFbSnka
 MmX3SPNJDkAADFuUm1lAxOS79m3jLroX85aS2ViuvoCj3IFFjlVXnPNB9l+fqxzr47kyVfRl5mLEpiuCZ8oNLdngZoutRoWswW3bhOe2Dmp5uLcPFWJ+MSGy
 rqvJNvUdo3cC2qcf0z9KMnLuqaCSYcc3rInpmDjC4UwSTQz9jf8tjFUiUfCmWoD2zwkHWEW8HA5DMYCss/F2/L/00YG6IhFwq/wJxbMHHnOYcvVceqWraXJd
 cPm6f9N9Sy7ox9CpFBEzL8AqXzT+sKvXfoiL+vStU2e9WzN2nXbnkNy8kdF52YA054pY99V0rV8OWiApBMlldy2+O4F4//Suh4BwaAjc8u58rGNvFbCwY8+S
 6LaZ8OkvsUzi3cKAxCq/bjXK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn [mailto:andrew@lunn.ch]
> Sent: Friday, March 26, 2021 2:54 PM
> To: Don Bollinger <don@thebollingers.org>
> Cc: 'Jakub Kicinski' <kuba@kernel.org>; arndb@arndb.de;
> gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> brandon_chuang@edge-core.com; wally_wang@accton.com;
> aken_liu@edge-core.com; gulv@microsoft.com; jolevequ@microsoft.com;
> xinxliu@microsoft.com; 'netdev' <netdev@vger.kernel.org>; 'Moshe
> Shemesh' <moshe@nvidia.com>
> Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
> EEPROMS
> 
> > The only thing wrong I can see is that it doesn't use the kernel
> > network stack.  Here's where "you keep missing the point".  The kernel
> > network stack is not being used in these systems.  Implementing EEPROM
> > access through ethtool is of course possible, but it is a lot of work
> > with no benefit on these systems.  The simple approach works.  Let me
use
> it.
> >
> > >
> > > The optoe KAPI needs to handle these 'interesting' SFP modules. The
> > > KAPI design needs to be flexible enough that the driver underneath
> > > it can be extended to support these SFPs. The code does not need to
> > > be there, but the KAPI design needs to allow it. And i personally
> > > cannot see how the
> > optoe
> > > KAPI can efficiently support these SFPs.
> >
> > Help me understand.  Your KAPI specifies ethtool as the KAPI, and the
> > ethtool/netlink stack as the interface through which the data flows.
> 
> Nearly. It specifies netlink and the netlink messages definitions.
> They happen to be in the ethtool group, but there is no requirement to use
> ethtool(1).
> 
> But there is a bit more to it.
> 
> Either the MAC driver implements the needed code, or it defers to the
> generic sfp.c code. In both cases, you have access to the GPIO lines.
> 
> If you are using the generic sfp.c, the Device Tree definitions of the
GPIOs
> become part of the KAPI. DT is consider ABI.
> 
> So the low level code knows when there was been a hotplug. It then can
> determine what quirks to apply for all future reads until the module is
> unplugged.

Got it.  All good.  I agree, I would like optoe to have access to the GPIO
lines, but it is a "nice to have", not a requirement...

> 
> Your KAPI is missing how optoe gets access to the GPIOs. Without knowing
if

Right.  It doesn't get access to the GPIOs.  So, that is not part of its
KAPI.

> the module has been hotplugged, in a robust manor, you have problems
> with quirks. For every userspace read, you need to assume the module has
> been changed, read the ID information from the EEPROM a byte at a time,
> figure out what quirks to apply, and then do the user requested read. I
doubt

Again, optoe does not deal with quirks.  Your code filters them out before
calling optoe or sfp_i2c_read.  My stack does not deal with them.  In my
community, quirky devices are not tolerated.  In the 4 years this code has
been in use, nobody has ever asked me to accommodate a weird module.

I inherited a limitation of writing one byte at a time from the ancestor of
optoe, which I have kept.  I don't know if it is needed, but someone once
thought it was required.  I apply it universally, all devices of all types.

I do need one item of state from the EEPROM, the register that tells me
whether pages are supported by the device.  Due to the hotplug risk, I
actually do read that register once for each access to non-zero pages.
(Once per read or write call.)  Access to GPIOs would eliminate that.  It
turns out the vast majority of calls are to page 0 or lower memory, and the
performance penalty is at most 25% since there is also a page write, data
access and page write in the same call.  The penalty goes down as the number
of bytes read increases.  Overall, it has never come up as an issue.  People
don't expect these things to be fast.

> that is good for performance. The design which has been chosen is that
> userspace is monitoring the GPIO lines. So to make it efficient, your KAPI
> need some way to pass down that the module has/has not been hot-
> plugged since the last read.

Nope.  optoe does not need to know, it assumes a new device every time it is
accessed.

> 
> Or do you see some other way to implement these quirks?

What I have works.  Your consumers get quirk handling, mine don't need it.
No compromise.

> 
>        Andrew

Don

