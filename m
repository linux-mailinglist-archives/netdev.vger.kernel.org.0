Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC4B33A169
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 22:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhCMVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 16:36:25 -0500
Received: from p3plsmtpa11-07.prod.phx3.secureserver.net ([68.178.252.108]:37517
        "EHLO p3plsmtpa11-07.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234284AbhCMVf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 16:35:58 -0500
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id LBvPl7oBNLcOOLBvRlOorH; Sat, 13 Mar 2021 14:35:57 -0700
X-CMAE-Analysis: v=2.4 cv=MPKlJOVl c=1 sm=1 tr=0 ts=604d303d
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=_7zvWGKQsyqa8fvKPS0A:9 a=CjuIK1q_8ugA:10
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
References: <20210215193821.3345-1-don@thebollingers.org> <YDl3f8MNWdZWeOBh@lunn.ch> <000901d70cb2$b2848420$178d8c60$@thebollingers.org> <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org> <YD1ScQ+w8+1H//Y+@lunn.ch> <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org> <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <005e01d71230$ad203be0$0760b3a0$@thebollingers.org> <YEL3ksdKIW7cVRh5@lunn.ch> <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org> <YEvILa9FK8qQs5QK@lunn.ch>
In-Reply-To: <YEvILa9FK8qQs5QK@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Sat, 13 Mar 2021 13:35:56 -0800
Message-ID: <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKX2ThEytgxSBCv+zte4L/P7xUGAgJF1IfoAfArhLgBgnHheQD1wSRRAcnMEPsCilAQ5QM6jzKkAZTVJ60CU9Q9IAIn9Rn1qF58cXA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfNuVrFsR2c3mfZE29fbuUYrA//reGugaW2sbeDf2+mNTFrLT+iXZS2xc7Cx8HbbOttfXbCxoqre3fQSByF/D/UgAwWIqNT6hQbw0vmB/V9tzzohC9HL+
 jCYMZhMsJKPRsPvHQQSEboGs3homPlaAzV0IM0w693r5T31bUfi0+oeFat0zm+hNBEoct/Med0GItoW9xpf8A+iD4/9WracoCFOpiLRIqbQADuk7KuqZG1bT
 U6XbDcWgMnU0CkPZHsD28Ut99LMeCQneqdmnx3dNKOiCTrmGCZxZQ8XlQ6jQo1eH1cPRoAQzkf4M2Be6nzv1Npvemh91JIfl4x+W16vk2FVMZUHI5ePVmXrH
 8Lwy5xWDr78mrkYn6damcBulXxndw1wbkDbhV2MknbHx2MfCcEixZKpVekRQDxPuW4gYpvC4q9X2xKZKK/Duwn7CPIwvirVhKPRp6uUPu2k2mdkE4XKeAiEi
 LrXTEA4RkDeZSF1Ouu7pOFsbHlreGp8GeMCIqI+kcsPhmOCOtvrNJkBMGuSQywiGFVy8TU2o1jbgPqP3ubKtlUrIRJ09hg7k0g8T/uKpuzCZRIIuHT2ZxLXa
 Arnyt9Gn7cOGD0WXRDNRkwzE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This interface is implemented in python scripts provided by the switch
> > platform vendor.  Those scripts encode the mapping of CPLD i2c muxes
> > to i2c buses to port numbers, specific to each switch.
> >
> > At the bottom of that python stack, all EEPROM access goes through
> > open/seek/read/close access to the optoe managed file in
> > /sys/bus/i2c/devices/{num}-0050/eeprom.
> 
> And this python stack is all open source? So you should be able to throw

It is open in the sense that it is accessible to the world on github and the
maintainers would presumably entertain contributions.

In practice, these are developed and maintained by the white box switch
vendors.  There is one implementation for each platform on each supported
NOS.  There is lots of commonality among them, but each is nonetheless
unique.  Optoe has been adopted across this ecosystem as a common piece that
has been factored out of many of the platform specific implementations.

> away parts of the bottom end and replace it with a different KAPI, and
> nobody will notice? In fact, this is probably how it was designed. Anybody

Actually everyone who touches this code would notice, each implementation
would have to be modified, with literally no benefit to this community.

> working with out of tree code knows what gets merged later is going to be
> different because of review comments. And KAPI code is even more likely to
> be different. So nobody really expected optoe to get merged as is.

The list of 'nobody' includes myself, my switch platform partners, my NOS
partners and Greg KH.  I did expect to accommodate constructive review of
the code, which I have already done (this is v2).

> 
> > You're not going to like this, but ethtool -e and ethtool -m both
> > return ' Ethernet0 Cannot get EEPROM data: Operation not supported',
> > for every port managed by the big switch silicon.
> 
> You are still missing what i said. The existing IOCTL interface needs a
network
> interface name. But there is no reason why you cannot extend the new
> netlink KAPI to take an alternative identifier, sfp42. That maps directly
to the
> SFP device, without using an interface name. Your pile of python can
directly
> use the netlink API, the ethtool command does not need to make use of this
> form of identifier, and you don't need to "screen scrape" ethtool.

It is just software, your proposal is certainly technically feasible.  It
provides no benefit to the community that is using optoe.

optoe is using a perfectly good KAPI, the nvmem interface that is being
developed and maintained by the folks who manage the EEPROM  drivers in the
kernel.  It has been updated since the prior submittal in 2018 to use the
nvmem interface and the regmap interface, both from the at24.c driver.  This
community isn't using the rest of the netdev/netlink interfaces, and has
adopted (before I wrote optoe) a perfectly reasonable approach of writing a
simple driver to access these simple devices.  

optoe does not undermine the netlink KAPI that Moshe is working on.  If your
community is interested, it could adopt optoe, WITH your KAPI, to
consolidate and improve module EEPROM access for mainstream netdev
consumers.  I am eager to collaborate on the fairly simple integration.

> 
> It seems very unlikely optoe is going to get merged. The network
maintainers
> are against it, due to KAPI issues. I'm trying to point out a path you can
take
> to get code merged. But it is up to you if you decided to follow it.

Thank you, I decline.  I respectfully request that optoe be accepted as a
useful implementation of the EEPROM driver, with the same access methods as
other EEPROM drivers, customized for the unique memory layout of SFP, QSFP
and CMIS devices.  I remain open to improvements in the implementation, but
my community finds no value in an implementation that removes the standard
EEPROM access via sysfs and open/seek/read/close calls.

> 
> 	Andrew

Don

