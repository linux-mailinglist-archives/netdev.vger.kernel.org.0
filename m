Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C12434AEB2
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 19:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCZSnQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Mar 2021 14:43:16 -0400
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:44944
        "EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhCZSnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 14:43:13 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id PrQIlmCU9yIwVPrQIlfXZT; Fri, 26 Mar 2021 11:43:07 -0700
X-CMAE-Analysis: v=2.4 cv=NP4QR22g c=1 sm=1 tr=0 ts=605e2b3b
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8 a=PHq6YzTAAAAA:8 a=YAhZTqFywYH_RNNK0y8A:9
 a=4i4o6EG8Y7xmpshJ:21 a=ja3h63SDPCocVfWu:21 a=wPNLvfGTeEIA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=ZKzU8r6zoKMcqsNulkmm:22 a=fCgQI5UlmZDRPDxm0A3o:22
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
References: <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <005e01d71230$ad203be0$0760b3a0$@thebollingers.org> <YEL3ksdKIW7cVRh5@lunn.ch> <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org> <YEvILa9FK8qQs5QK@lunn.ch> <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org> <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001201d719c6$6ac826c0$40587440$@thebollingers.org> <YFJHN+raumcJ5/7M@lunn.ch> <009601d72023$b73dbde0$25b939a0$@thebollingers.org> <YFpr2RyiwX10SNbD@lunn.ch>
In-Reply-To: <YFpr2RyiwX10SNbD@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 26 Mar 2021 11:43:05 -0700
Message-ID: <011301d7226f$dc2426f0$946c74d0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKKUBDlk/ZDe2GSw4EC/Sqa1m6tmAM6jzKkAZTVJ60CU9Q9IAIn9Rn1Ajfd1BUB/Wl5HgIIpANoAg1VxGkCGooDGQJYqoE6qH/b3XA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfIWbqXAorBn40i1i/32DhnJ4EZ3sQOoJtMtpLglAw5RBSvAgTJC39ZKvAhboYZYTIr19/u2zrcgXgRSs2ZFrzgjy+uv4CMG4iIyM8TdX0CZ3dyXblOTW
 o5M/iPbQ59lBkoipREAuSbmaaFr4BbDM+wGTUHcvIVPY6M6LLC7j6KGjqnW8Rlqi1m6wwYmV4ZeGKDJusKdnALK0OQTjd8TD31IpbjNGd6FQAi1U3aSNNdEa
 ouOqir7u9U/TGO/ml8U5qbg+mZCAz4WQEz7Tx3b/FzTb0CPKeXjv95AAKOqN2UHnSDSyAr7UgS04VkmPGNy+56290Cdfz/a5/SzyUwVg6UUXFE1Wn8XuGu1/
 hOiARvUyl5ojObsEi8i8wFFlI735WnxkxCaTgt9miimckO92QbTX+DErRNSp6V3qId24Qi8fn+FzkGWpx1+fJzpuxaZmtmcgnoc1Z79Ui8yWphYn4oxAbKGr
 p95o+ykBiRb5CthmdDi0WCNKMeKHRHFLmguoKozEHVK3PmjBHAXZk2s4wFJ5UUN140RCAoiuxfMiirDRo9HWGSzBfEg0otZLJuqPaDtzpxt6oCb6INFVHUNe
 O8p+m0X8zaCDFVBL0wUFD7S6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Our experience is that a number of SFPs are broken, they don't
> > > follow the standard. Some you cannot perform more than 16 bytes
> > > reads without them locking up. Others will perform a 16 byte read,
> > > but only give you one
> > useful
> > > byte of data. So you have to read enough of the EEPROM a byte at a
> > > time to get the vendor and product strings in order to determine
> > > what quirks need to be applied. optoe has nothing like this. Either
> > > you don't care and only support well behaved SFPs, or you have the
> > > quirk handling in user space,
> > in
> > > the various vendor code blobs, repeated again and again. To make
> > > optoe generically usable, you are going to have to push the quirk
> > > handling into optoe. The brokenness should be hidden from userspace.
> >
> > Interesting.  I would throw away such devices.  That's why switch
> > vendors publish supported parts lists.
> >
> > Can you point me to the code that is handling those quirks?  Since I
> > haven't seen those problems, I don't know what they are and how to
> address them.
> 
> Take a look in drivers/net/phy/sfp.c

Thanks for the pointers, I appreciate the chance to understand exactly what
quirks are under discussion.

It turns out that those quirks are not relevant to my patch.  I don't mean
you are wrong, or that they don't have to be handled for your use cases,
just that my patch does not need to deal with them.

If optoe were adopted into your framework, it would replace the routines
sfp_i2c_read() and sfp_i2c_write().  By the time these two routines are
called, all of the quirk handling has already been applied (there is no
quirk handling in these routines today).  The data requests have been broken
down as necessary into short reads or targeted reads for each device.  Those
calls are then sent to the module EEPROM with no further need for quirk
handling.  So, optoe does not need to handle quirks to fit into your code.
The quirks are handled, without optoe being involved.

In my community, the SFP/QSFP/CMIS devices (32 to 128 of them per switch)
often cost more than the switch itself.  Consumers (both vendors and
customers) extensively test these devices to ensure correct and reliable
operation.  Then they buy them literally by the millions.  Quirks lead to
quick rejection in favor of reliable parts from reliable vendors.  In this
environment, for completely different reasons, optoe does not need to handle
quirks.

> 
> commit f0b4f847673299577c29b71d3f3acd3c313d81b7
> Author: Pali Rohár <pali@kernel.org>
> Date:   Mon Jan 25 16:02:28 2021 +0100
> 
>     net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
> 
>     The Ubiquiti U-Fiber Instant SFP GPON module has nonsensical
information
>     stored in its EEPROM. It claims to support all transceiver types
including
>     10G Ethernet. Clear all claimed modes and set only 1000baseX_Full,
which
> is
>     the only one supported.
> 
>     This module has also phys_id set to SFF, and the SFP subsystem
currently
>     does not allow to use SFP modules detected as SFFs. Add exception for
this
>     module so it can be detected as supported.

In my community, all interpretation of the SFP/QSFP/CMIS content is done in
user space.  So, these issues don't affect optoe.  I know you find that
distasteful, but it is what my community wants and needs.

> 
>     This change finally allows to detect and use SFP GPON module Ubiquiti
>     U-Fiber Instant on Linux system.
> 
>     EEPROM content of this SFP module is (where XX is serial number):
> 
>     00: 02 04 0b ff ff ff ff ff ff ff ff 03 0c 00 14 c8
???........??.??
>     10: 00 00 00 00 55 42 4e 54 20 20 20 20 20 20 20 20    ....UBNT
>     20: 20 20 20 20 00 18 e8 29 55 46 2d 49 4e 53 54 41
.??)UF-INSTA
>     30: 4e 54 20 20 20 20 20 20 34 20 20 20 05 1e 00 36    NT      4
??.6
>     40: 00 06 00 00 55 42 4e 54 XX XX XX XX XX XX XX XX
.?..UBNTXXXXXXXX
>     50: 20 20 20 20 31 34 30 31 32 33 20 20 60 80 02 41        140123
`??A
> 
> 
> commit 426c6cbc409cbda9ab1a9dbf15d3c2ef947eb8c1
> Author: Pali Rohár <pali@kernel.org>
> Date:   Mon Jan 25 16:02:27 2021 +0100
> 
>     net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
> 
>     The workaround for VSOL V2801F brand based GPON SFP modules added
> in commit
>     0d035bed2a4a ("net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0
>     workaround") works only for IDs added explicitly to the list. Since
there
>     are rebranded modules where OEM vendors put different strings into the
>     vendor name field, we cannot base workaround on IDs only.

You might be fighting a losing battle here.  There are companies that buy
cheap SFP devices and reprogram the EEPROM to identify them as higher
quality parts from reliable vendors.  Checking the Vendor ID and part number
may tell you have a high quality part, but the code inside still has the
quirks you are trying to avoid.

I developed optoe while working for a (high quality) vendor of these
modules.  Their support team runs into these counterfeit parts all the time.
(I don't work for them or anyone else any more.)

> 
>     Moreover the issue which the above mentioned commit tried to work
> around is
>     generic not only to VSOL based modules, but rather to all GPON modules
>     based on Realtek RTL8672 and RTL9601C chips.
> 
>     These include at least the following GPON modules:
>     * V-SOL V2801F
>     * C-Data FD511GX-RM0
>     * OPTON GP801R
>     * BAUDCOM BD-1234-SFM
>     * CPGOS03-0490 v2.0
>     * Ubiquiti U-Fiber Instant
>     * EXOT EGS1
> 
>     These Realtek chips have broken EEPROM emulator which for N-byte read
>     operation returns just the first byte of EEPROM data, followed by N-1
>     zeros.
> 
>     Introduce a new function, sfp_id_needs_byte_io(), which detects SFP
> modules
>     with broken EEPROM emulator based on N-1 zeros and switch to 1 byte
> EEPROM
>     reading operation.
> 
>     Function sfp_i2c_read() now always uses single byte reading when it is
>     required and when function sfp_hwmon_probe() detects single byte
> access,
>     it disables registration of hwmon device, because in this case we
cannot
>     reliably and atomically read 2 bytes as is required by the standard
for
>     retrieving values from diagnostic area.
> 
>     (These Realtek chips are broken in a way that violates SFP standards
for
>     diagnostic interface. Kernel in this case simply cannot do anything
less
>     of skipping registration of the hwmon interface.)
> 
>     This patch fixes reading of EEPROM content from SFP modules based on
>     Realtek RTL8672 and RTL9601C chips. Diagnostic interface of EEPROM
stays
>     broken and cannot be fixed.
> 
> commit 624407d2cf14ff58e53bf4b2af9595c4f21d606e
> Author: Russell King <rmk+kernel@armlinux.org.uk>
> Date:   Sun Jan 10 10:58:32 2021 +0000
> 
>     net: sfp: cope with SFPs that set both LOS normal and LOS inverted
> 
>     The SFP MSA defines two option bits in byte 65 to indicate how the
>     Rx_LOS signal on SFP pin 8 behaves:
> 
>     bit 2 - Loss of Signal implemented, signal inverted from standard
>             definition in SFP MSA (often called "Signal Detect").
>     bit 1 - Loss of Signal implemented, signal as defined in SFP MSA
>             (often called "Rx_LOS").
> 
>     Clearly, setting both bits results in a meaningless situation: it
would
>     mean that LOS is implemented in both the normal sense (1 = signal
loss)
>     and inverted sense (0 = signal loss).
> 
>     Unfortunately, there are modules out there which set both bits, which
>     will be initially interpret as "inverted" sense, and then, if the LOS
>     signal changes state, we will toggle between LINK_UP and WAIT_LOS
>     states.
> 
>     Change our LOS handling to give well defined behaviour: only interpret
>     these bits as meaningful if exactly one is set, otherwise treat it as
>     if LOS is not implemented.
> 
> ommit 0d035bed2a4a6c4878518749348be61bf082d12a
> Author: Russell King <rmk+kernel@armlinux.org.uk>
> Date:   Wed Dec 9 11:22:49 2020 +0000
> 
>     net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround
> 
>     Add a workaround for the detection of VSOL V2801F / CarlitoxxPro
>     CPGOS03-0490 v2.0 GPON module which CarlitoxxPro states needs single
>     byte I2C reads to the EEPROM.
> 
>     Pali Rohár reports that he also has a CarlitoxxPro-based V2801F
module,
>     which reports a manufacturer of "OEM". This manufacturer can't be
>     matched as it appears in many different modules, so also match the
part
>     number too.
> 
> etc.
> 
> Now, it could be you only work with TOR switches and their SFP modules.
> And they follow the standard in a better way than others. But the kernel
is
> used in many more environments that just data centers.
> We need to support SFPs in FTTH boxes, in aircraft inflight entertainment
> systems, industrial control etc.

Totally agree.  As a replacement for sfp_i2c_read() and sfp_i2c_write(),
optoe would achieve everything the existing code does, plus it would support
paged devices.  Works the same, but covers more capabilities.

AND, for TOR switches, and their SFP AND QSFP AND CMIS modules, it works
too, even when they don't adopt linux kernel networking.  Unfortunately you
have decided that their architecture, handling networking outside the
kernel, is not allowed.  My community does not get to have the perfectly
good code they use to access these devices accepted into the mainline
kernel.

> 
> 
> 	Andrew

Don

