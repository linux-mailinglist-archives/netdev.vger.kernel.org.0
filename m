Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD0834B001
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhCZUQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:16:33 -0400
Received: from p3plsmtpa06-01.prod.phx3.secureserver.net ([173.201.192.102]:33563
        "EHLO p3plsmtpa06-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhCZUQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 16:16:17 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id PssRluyw95NJSPssSlh2vm; Fri, 26 Mar 2021 13:16:17 -0700
X-CMAE-Analysis: v=2.4 cv=bPLTnNyZ c=1 sm=1 tr=0 ts=605e4111
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=RhfDxTFQNv-UFsv0dfcA:9 a=CjuIK1q_8ugA:10
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
References: <YEL3ksdKIW7cVRh5@lunn.ch> <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org> <YEvILa9FK8qQs5QK@lunn.ch> <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org> <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <001201d719c6$6ac826c0$40587440$@thebollingers.org> <YFJHN+raumcJ5/7M@lunn.ch> <009601d72023$b73dbde0$25b939a0$@thebollingers.org> <YFpr2RyiwX10SNbD@lunn.ch> <011301d7226f$dc2426f0$946c74d0$@thebollingers.org> <YF46FI4epRGwlyP8@lunn.ch>
In-Reply-To: <YF46FI4epRGwlyP8@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 26 Mar 2021 13:16:14 -0700
Message-ID: <011901d7227c$e00015b0$a0004110$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQGU1SetidobDDbBbPSeytwVQgsqiAJT1D0gAif1GfUCN93UFQH9aXkeAgikA2gCDVXEaQIaigMZAliqgToBPL7YiwHCMwNMqnmDWgA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfHyUkELn3EA/B12+Sx+cLF0zxakA4dwqL8EgwX2LLa0yuIIISUC+uguilZXaBcRsorkhuUUB1wEwM4wox2qLZMneKA5MyVmbdZ/cNlJJm/Pnczs/i5u+
 iZLUVQS+ri6Ryw8POwfyZK2qAGjUW/Baqb1uf8tawjEykH+ISaexqzFUUSZW+vp3guKIaT1qf+6f0QTs6t2KX5UH0EO+X5q+VbfqvmvKiNAlbmRPmOyMN/OZ
 qDzLmj+qNNVCmtxsiO/f/qUVN/SkblTDuoryLhqDDabh7ZRnhA2GNxfoNLpmFmM/h0UcA/Evw4bBMI1gfXJdvaGEn265EruAAeVCkye7QvfUAJxLcgp/9ksc
 UyHEfm4hHz46pK5nLTeLSUbvN/wVe3qnYy6EadZwaOUHGS3GmfXzvxwbiJQyzvHsQRIfCXJfigKmfzd5EklppCPiOPNYZ8xAGHQvhtLrdbINJWmbaKO3xMU5
 n8t29LTS37jzdDcgzyjZOSdYm/KvjakPp8j5wv1+A9pVOs7A4fgyEpKErX9/0HJG2qn+jGjV8P7RqFmMTqzm4CxDRaQ4Qf1PA+LW+skegR2nO0HjkiydFH0n
 mhoBSYbrfsAfxldZvT2SG4YN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > In my community, the SFP/QSFP/CMIS devices (32 to 128 of them per
> > switch) often cost more than the switch itself.  Consumers (both
> > vendors and
> > customers) extensively test these devices to ensure correct and
> > reliable operation.  Then they buy them literally by the millions.
> > Quirks lead to quick rejection in favor of reliable parts from
> > reliable vendors.  In this environment, for completely different
> > reasons, optoe does not need to handle quirks.
> 
> Well, if optoe were to be merged, it would not be just for your community.
It
> has to work for everybody who wants to use the Linux kernel with an SFP.
> You cannot decide to add a KAPI which just supports a subset of SFPs. It
> needs to support as many as possible, warts and all.
> 
> So how would you handle these SFPs with the optoe KAPI?

Just like they are handled now.  Folks who use your stack would filter
through sfp.c, with all the quirk handling, and eventually call optoe for
the actual device access.  Folks who don't use kernel networking would call
optoe directly and limit themselves to well behaved SFPs, or would handle
quirks in user space.  You think that's dumb, but there is clearly a market
for that approach.  It is working, at scale, today.

BTW, why can't we have a driver that only handles devices that work
correctly?  Indeed, why would we tolerate an endless stream of special cases
for each new device that comes along?

Don

