Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84CD34B7F9
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 16:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhC0P0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 11:26:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51132 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhC0P0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 11:26:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQAp3-00DLWU-Jx; Sat, 27 Mar 2021 16:25:57 +0100
Date:   Sat, 27 Mar 2021 16:25:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Jakub Kicinski' <kuba@kernel.org>, arndb@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brandon_chuang@edge-core.com, wally_wang@accton.com,
        aken_liu@edge-core.com, gulv@microsoft.com, jolevequ@microsoft.com,
        xinxliu@microsoft.com, 'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YF9OhSBHnDVqW5JQ@lunn.ch>
References: <YFJHN+raumcJ5/7M@lunn.ch>
 <009601d72023$b73dbde0$25b939a0$@thebollingers.org>
 <YFpr2RyiwX10SNbD@lunn.ch>
 <011301d7226f$dc2426f0$946c74d0$@thebollingers.org>
 <YF46FI4epRGwlyP8@lunn.ch>
 <011901d7227c$e00015b0$a0004110$@thebollingers.org>
 <YF5GA1RbaM1Ht3nl@lunn.ch>
 <011c01d72284$544c8f50$fce5adf0$@thebollingers.org>
 <YF5YAQvQXCn4QapJ@lunn.ch>
 <012b01d7228f$a2547270$e6fd5750$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012b01d7228f$a2547270$e6fd5750$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What I have works.  Your consumers get quirk handling, mine don't need it.
> No compromise.

Hi Don

All this discussion is now a mute point. GregKH has spoken.

But i'm sure there are some on the side lines, eating popcorn, maybe
learning from the discussion.

Would you think it is O.K. to add a KAPI which works for 3 1/2" SCSI
disks, but not 2", because you only make machines with 3 1/2" bays?

This is an extreme, absurd example, but hopefully you get the
point. We don't design KAPIs with the intention to only work for a
subset of devices. It needs to work with as many devices as possible,
even if the first implementation below the KAPI is limited to just a
subset.

Anyway, i'm gratefull you have looked at the new ethtool netlink
KAPI. It will be better for your contributions. And i hope you can
make use of it in the future. But i think this discussion about optoe
in mainline is over.

     Andrew
