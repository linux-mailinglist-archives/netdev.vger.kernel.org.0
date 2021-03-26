Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5603834AF80
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 20:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhCZTqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 15:46:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhCZTql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 15:46:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPsPc-00DBzp-Im; Fri, 26 Mar 2021 20:46:28 +0100
Date:   Fri, 26 Mar 2021 20:46:28 +0100
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
Message-ID: <YF46FI4epRGwlyP8@lunn.ch>
References: <YEL3ksdKIW7cVRh5@lunn.ch>
 <018701d71772$7b0ba3f0$7122ebd0$@thebollingers.org>
 <YEvILa9FK8qQs5QK@lunn.ch>
 <01ae01d71850$db4f5a20$91ee0e60$@thebollingers.org>
 <20210315103950.65fedf2c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <001201d719c6$6ac826c0$40587440$@thebollingers.org>
 <YFJHN+raumcJ5/7M@lunn.ch>
 <009601d72023$b73dbde0$25b939a0$@thebollingers.org>
 <YFpr2RyiwX10SNbD@lunn.ch>
 <011301d7226f$dc2426f0$946c74d0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <011301d7226f$dc2426f0$946c74d0$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In my community, the SFP/QSFP/CMIS devices (32 to 128 of them per switch)
> often cost more than the switch itself.  Consumers (both vendors and
> customers) extensively test these devices to ensure correct and reliable
> operation.  Then they buy them literally by the millions.  Quirks lead to
> quick rejection in favor of reliable parts from reliable vendors.  In this
> environment, for completely different reasons, optoe does not need to handle
> quirks.

Well, if optoe were to be merged, it would not be just for your
community. It has to work for everybody who wants to use the Linux
kernel with an SFP. You cannot decide to add a KAPI which just
supports a subset of SFPs. It needs to support as many as possible,
warts and all.

So how would you handle these SFPs with the optoe KAPI?

   Andrew
