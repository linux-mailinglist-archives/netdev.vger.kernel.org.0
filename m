Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7B533970E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhCLTEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:04:24 -0500
Received: from p3plsmtpa08-10.prod.phx3.secureserver.net ([173.201.193.111]:58984
        "EHLO p3plsmtpa08-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233517AbhCLTEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:04:14 -0500
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id Kn4wl6nPrOhTrKn4xlQAXf; Fri, 12 Mar 2021 12:04:08 -0700
X-CMAE-Analysis: v=2.4 cv=TJGA93pa c=1 sm=1 tr=0 ts=604bbb28
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=-7CivnDRKoGH-SBZfI8A:9 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     "'Jakub Kicinski'" <kuba@kernel.org>, <arndb@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <brandon_chuang@edge-core.com>, <wally_wang@accton.com>,
        <aken_liu@edge-core.com>, <gulv@microsoft.com>,
        <jolevequ@microsoft.com>, <xinxliu@microsoft.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>
References: <20210215193821.3345-1-don@thebollingers.org> <YDl3f8MNWdZWeOBh@lunn.ch> <000901d70cb2$b2848420$178d8c60$@thebollingers.org> <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org> <YD1ScQ+w8+1H//Y+@lunn.ch> <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org> <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <005e01d71230$ad203be0$0760b3a0$@thebollingers.org> <YEL3ksdKIW7cVRh5@lunn.ch>
In-Reply-To: <YEL3ksdKIW7cVRh5@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 12 Mar 2021 11:04:06 -0800
Message-ID: <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKX2ThEytgxSBCv+zte4L/P7xUGAgJF1IfoAfArhLgBgnHheQD1wSRRAcnMEPsCilAQ5QM6jzKkAZTVJ62ogJyhMA==
Content-Language: en-us
X-CMAE-Envelope: MS4xfNc00aF/ZWf8Ydww900RPjaTU9TyR3HBfOwU2asZHyRMd9JIoDne9bb33QIKI48dLZhUa6BFQZFsUBG6u+f16UvUTdlQnfc7L4GdO3hM5LWqF49h7hQi
 Rbo5PIXPf1LDIHVIhxy4RVpQomjDFknO1p/dCTB0JsJ/clc7jxMVzSy0c7yQCwtkc8YRxPvHaCf2jfnPwrWWeUxKZPWin6FgBKfgEX4wgGDQJ4zolshkl0q2
 oQ7wyO8pjkLyB45TrxvUn1lb9BpmQsM637cL09gmwIhV2PZY2WeHWyO+gynDmN7DQGqVnsUbKDEStnAPf2xLkkcqxVfgBaXasVKWlWotDcO7TAud98stA4Ft
 T49HhP+ZWVcm8ASHl9Wgn1UknHe/M7KYWH0URy3e7FpEMsdM+KjZLIg0eAMSmV904/gychBlDWcB9Oq6yyEvExquRTEITVo38SqpOyBVNnunhsdED575CZDU
 wlOge9pD1v8U7LTCYVksKNGn4mbTGNLlY9RDXaebivqLN50AeinQraUIOONrlRF5wkmtTr0WrlU0M1WsPawGoBysNFmeL/+r7tlQCxu3FSRI8+cmKbi2xoX2
 G7s=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Mar 2021 19:32 -0800 Andrew Lunn wrote:
> > I am proposing acceptance of a commonly used implementation for
> > accessing SFPs because the one used by the netdev/netlink community
> > does not fit the architecture of the white box NOS/switch community.
> 
> Please could you expand on this. I've given suggests as to how the new
> netlink KAPI could be used for this use case, without being attached to a
> netdev. And you have said nothing about why it cannot be made to work.
> You cannot argue the architecture does not fit without actually saying why
it
> does not fit.
> 
>    Andrew

Sorry it took some time to clarify this for myself.  I'm using SONiC (the
NOS
Microsoft uses to run the switches in its Azure cloud) as my example.  They
are users of optoe, and they actually initiated the request to push optoe 
upstream.  Other white box NOS vendors are similar.

SONiC manages all aspects of SFP/QSFP/CMIS interaction through user
space.  They have specified an API that is implemented by switch platform
vendors, that provides things like presence detection, LowPower mode
up/down/status, raw access to EEPROM content, interpretation of EEPROM
content (including TxPower/RxPower/bias, high/low alarm/warning thresholds,
static content like serial number and part number, and dozens of other
items).
This interface is implemented in python scripts provided by the switch
platform
vendor.  Those scripts encode the mapping of CPLD i2c muxes to i2c buses to
port numbers, specific to each switch.

At the bottom of that python stack, all EEPROM access goes through
open/seek/read/close access to the optoe managed file in 
/sys/bus/i2c/devices/{num}-0050/eeprom.

You're not going to like this, but ethtool -e and ethtool -m both return 
' Ethernet0 Cannot get EEPROM data: Operation not supported', for
every port managed by the big switch silicon.

So, my users are using Linux for all the usual Linux things (memory 
management, process management, I/O, IPC, containers), but they don't
use Linux networking to manage the ports that are managed by the big
switch silicon.  (Linux networking is still in use for the management port
that talks to the management processor running Linux.)

optoe provides the device EEPROM foundation for this architecture, but 
requires the sysfs interface (via nvmem) to provide it.  optoe can also
easily
provide the default EEPROM access for the netdev/netlink interface through
the old and new KAPI.

Don

