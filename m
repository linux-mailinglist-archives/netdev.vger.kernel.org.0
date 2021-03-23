Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933253469E2
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 21:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhCWUdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 16:33:25 -0400
Received: from p3plsmtpa07-03.prod.phx3.secureserver.net ([173.201.192.232]:36597
        "EHLO p3plsmtpa07-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233378AbhCWUdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 16:33:01 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id OnhzlTcHTKQk4OnhzlH5cY; Tue, 23 Mar 2021 13:33:00 -0700
X-CMAE-Analysis: v=2.4 cv=W6D96Tak c=1 sm=1 tr=0 ts=605a507c
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=cR5ugqiJw0_SYd6LBy0A:9 a=CjuIK1q_8ugA:10
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
References: <YD1ScQ+w8+1H//Y+@lunn.ch> <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org> <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <005e01d71230$ad203be0$0760b3a0$@thebollingers.org> <YEL3ksdKIW7cVRh5@lunn.ch> <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org> <YEvILa9FK8qQs5QK@lunn.ch> <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org> <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001201d719c6$6ac826c0$40587440$@thebollingers.org> <YFJHN+raumcJ5/7M@lunn.ch>
In-Reply-To: <YFJHN+raumcJ5/7M@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Tue, 23 Mar 2021 13:32:59 -0700
Message-ID: <009601d72023$b73dbde0$25b939a0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQD1wSRROFm+pfi0LxH9mVlD+9L7SgHJzBD7AopQEOUDOo8ypAGU1SetAlPUPSACJ/UZ9QI33dQVAf1peR4CCKQDaAINVcRpq6Vr/PA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfJIBAaH3F7AJSZAd+ZLEFUXgT+ZEGtO5iikfJf7m00SE+/yRB+kjCgbKImese4nXhErx8z6PS8EYRMM9OyDwnjukgoygonEYPwehDc5Kf73/3TemuZiQ
 i3tcfxDyohE6IpeYcHzKHX94jQEO57I/TgSAISPjAOOwy4XSAG17M4ZT5yp7F1vmeGAO2yFfb5FBal9zp3g/lk+mrXELe5APX0/OOs2f6sY9YY8hRIujAgxV
 plETaQDBbgBpgClvARdPm0/HzNzXJLJ7pROO8q3nop6Qhx2VUtD2KceyVIj5YoFz4XsfPSnifbzkNb9TPNHze2ujKM3TEYtsN9Bb3DLMEsnc9+SW2IRPhf6x
 6W25ymm9eor60uh53OBHT5yFTVr7tMAcnqHm+FfGLEY7yYl7/IZRCTPyu2uJbr3JQ+MDx10irxoDhuMYivwXywX/zw7L5tsAXQhN+sWdXXMLIkwzFNcXjpl2
 YXtxiQJoeOt8KP49FKGPiuYwzS49mkj92AtVsPmWz0UmPzQsQtrM0NqOSfEofHkq+QTbNZOTzXQ4/ZeqDL3ihtM8FNPc/+KoKanpqfmEZBP1Sg6eYebE1lkg
 mAAedEj333AQZEe1OZaRQ9yj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I have offered, in every response, to collaborate with the simple
> > integration to use optoe as the default upstream driver to access the
> > module EEPROMs.  optoe would be superior to the existing default
> > routines in sfp.c
> 
> Actually, i'm not sure they would be. Since the KAPI issues are pretty
much a
> NACK on their own, i didn't bother raising other issues. Both Russell King
and
> I has issues with quirks and hotplug.
> 
> Our experience is that a number of SFPs are broken, they don't follow the
> standard. Some you cannot perform more than 16 bytes reads without them
> locking up. Others will perform a 16 byte read, but only give you one
useful
> byte of data. So you have to read enough of the EEPROM a byte at a time to
> get the vendor and product strings in order to determine what quirks need
> to be applied. optoe has nothing like this. Either you don't care and only
> support well behaved SFPs, or you have the quirk handling in user space,
in
> the various vendor code blobs, repeated again and again. To make optoe
> generically usable, you are going to have to push the quirk handling into
> optoe. The brokenness should be hidden from userspace.

Interesting.  I would throw away such devices.  That's why switch vendors
publish supported parts lists.

Can you point me to the code that is handling those quirks?  Since I haven't
seen those problems, I don't know what they are and how to address them.

Note there are a VAST number of data items in those EEPROMs, including
proprietary capabilities.  Many of the items are configuration dependent,
and mean different things depending on the value of other data items.  Most
of these items are not of any interest to kernel networking.  I try to
minimize the size of the kernel footprint and move those decoding and
management functions to user space.

> 
> And then you repeat all the quirk handling sfp.c has. That does not scale,
we
> don't want the same quirks in two different places. However, because SFPs
> are hot pluggable, you need to re-evaluate the quirks whenever there is a
> hot-plug event. optoe has no idea if there has been a hotplug event, since
it
> does not have access to the GPIOs. Your user space vendor code might
> know, it has access to the GPIOs. So maybe you could add an IOCTL call or
> something, to let optoe know the module has changed and it needs to
> update its quirks. Or for every user space read, you actually re-read the
> vendor IDs and refresh the quirks before performing the read the user
> actually wants. That all seems ugly and is missing from the current patch.

Actually I do need to know whether the device supports paging, that's the
only device state I need.  Since I don't detect hotplug events, I read the
'paging supported' bit on every read that changes the page register.  

There is a GPIO line to detect 'presence', which presumably could be
accessed via device tree configuration with the GPIO driver.  I haven't
figured out how to connect those pieces so I just read the page register on
every access.  Adding that would be a useful feature.

> 
> I fully agree with Jakub NACK.
> 
>   Andrew

Don

