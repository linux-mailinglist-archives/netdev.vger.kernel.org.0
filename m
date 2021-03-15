Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D46333C548
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhCOSK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:10:27 -0400
Received: from p3plsmtpa11-06.prod.phx3.secureserver.net ([68.178.252.107]:55137
        "EHLO p3plsmtpa11-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230250AbhCOSKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:10:02 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id LrfEllU8vhFMzLrfFlrIHj; Mon, 15 Mar 2021 11:10:02 -0700
X-CMAE-Analysis: v=2.4 cv=MNClJOVl c=1 sm=1 tr=0 ts=604fa2fa
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=28_-FdfHECPUQo66F5MA:9 a=CjuIK1q_8ugA:10
 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Jakub Kicinski'" <kuba@kernel.org>
Cc:     "'Andrew Lunn'" <andrew@lunn.ch>, <arndb@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <brandon_chuang@edge-core.com>, <wally_wang@accton.com>,
        <aken_liu@edge-core.com>, <gulv@microsoft.com>,
        <jolevequ@microsoft.com>, <xinxliu@microsoft.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>, <don@thebollingers.org>
References: <20210215193821.3345-1-don@thebollingers.org>       <YDl3f8MNWdZWeOBh@lunn.ch>      <000901d70cb2$b2848420$178d8c60$@thebollingers.org>     <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>     <YD1ScQ+w8+1H//Y+@lunn.ch>      <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>     <20210305145518.57a765bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <005e01d71230$ad203be0$0760b3a0$@thebollingers.org>     <YEL3ksdKIW7cVRh5@lunn.ch>      <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>     <YEvILa9FK8qQs5QK@lunn.ch>      <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org> <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Mon, 15 Mar 2021 11:09:59 -0700
Message-ID: <001201d719c6$6ac826c0$40587440$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKX2ThEytgxSBCv+zte4L/P7xUGAgJF1IfoAfArhLgBgnHheQD1wSRRAcnMEPsCilAQ5QM6jzKkAZTVJ60CU9Q9IAIn9Rn1Ajfd1BUB/Wl5Hqg/v1Nw
Content-Language: en-us
X-CMAE-Envelope: MS4xfIW5HYrvwji0eD8ILQajFORLv6Qwoeg2AYuKR5ZWkFuUcdgaNyVXEFz8rYZR9YMNFdBwTA3us4gXuJ/zxd1toTdVtxEvhwKkSJXQPFpBFWfwgHQCVo4W
 IVoYSODukTwn3TlPSwzvxKYNp6gHOEWTmnbOD1bmnmdVBQd7DgXcMP1HUrTsohe3lj3mIX40E6jaPuL+E3i34X8Sz5FFwpqvQ5vAiP+ZZBfneRxAaQmuEoBa
 fiQKKovUHWNHG/Il9BDYOc1cN1CwjJ22VTGt9lx36plY+gTSer3fscixMb/kA9PqE9Yv0BVGroeu8tMZ0ZIthRlELBaWq8QtxORVurQ5MjN9yIrKwIQQJ4Jr
 fcWVSNjcyART2BhrH0uJyBQQoRbaYwW3SwCo66wyGr5abG93P9Q88ScjFMP8SF34b57Rrdmaang+KNxQYgvAYnI6MAQO4/7TAxZY3t8P+lUBruU1I+jVI1vZ
 WF6YjfYwcRAY7hUAwKl41F2Ack8AwN5tP/YHotZA9x6zzAcpF8LAE4RGiTbWZtxKta1qurAlk0KODiEBTRgH6AFbrPZEj4FO5KOKnHQ5iLemXqUBvrsQ3d5J
 Ynws5l1yUQeM5MzTNwpaubaD
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 10:40 -0800 Jakub Kicinski wrote:
> On Sat, 13 Mar 2021 13:35:56 -0800 Don Bollinger wrote:
> > > away parts of the bottom end and replace it with a different KAPI,
> > > and nobody will notice? In fact, this is probably how it was
> > > designed. Anybody
> >
> > Actually everyone who touches this code would notice, each
> > implementation would have to be modified, with literally no benefit to
this
> community.
> 
> You keep saying that kernel API is "of no benefit to this community"
> yet you don't want to accept the argument that your code is of no benefit
to
> the upstream community.

I have offered, in every response, to collaborate with the simple
integration to use optoe as the default upstream driver to access the module
EEPROMs.  optoe would be superior to the existing default routines in sfp.c
and would allow multiple existing vendor specific upstream drivers to adopt
the default.  That would reduce the code base they maintain and provide
better access to module eeproms.  I already adopted the existing EEPROM api
to make that integration easy (nvmem).  I'm reluctant to submit the changes
to sfp.c because I have no expertise in that stack and no platform to test
it on.

> 
> > optoe does not undermine the netlink KAPI that Moshe is working on.
> 
> It does, although it may be hard to grasp for a vendor who can just EoL a
> product at will once nobody is paying for it. We aim to provide uniform
> support for all networking devices and an infinite backward compatibility
> guarantee.

I aim to provide uniform support for module EEPROM devices, with no less
reason to expect an infinite backward compatibility guarantee.  (Infinite is
a bit much, that technology will inevitably become uninteresting to my
community as well as yours.)

> 
> People will try to use optoe-based tools on the upstream drivers and they
> won't work. Realistically we will need to support both APIs.

I assume they "won't work" because of new requirements or newly discovered
defects.  At that point optoe would be fixed by people who care, just like
any other upstream code.  If your stack adopts optoe, through Moshe's KAPI,
then both communities benefit from ongoing support to maintain and enhance
EEPROM access.  If your stack does not adopt optoe, then my community will
manage the support, since they need and use the code.

As for "both APIs", the first API is Moshe's, which we both support
(politically and technically).  The second is nvmem, which is supported by
the EEPROM driver folks, led by the support for the at24 driver.  I'm
calling the routines they created for this purpose, I'm not creating a new
API.

Bottom line:  "Realistically we will need to support both APIs" even if
optoe does not get accepted.

> 
> > If your community is interested, it could adopt optoe, WITH your KAPI,
> > to consolidate and improve module EEPROM access for mainstream netdev
> > consumers.  I am eager to collaborate on the fairly simple
> > integration.
> 
> Nacked-by: Jakub Kicinski <kuba@kernel.org>
> 
> Please move on.

My community still has useful code that they would like in the upstream
kernel.

Don

