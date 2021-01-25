Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DF23049F3
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbhAZFT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:19:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58260 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730225AbhAYPmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:42:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l43zP-002YMy-O7; Mon, 25 Jan 2021 16:41:15 +0100
Date:   Mon, 25 Jan 2021 16:41:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: sfp: add support for GPON RTL8672/RTL9601C
 and Ubiquiti U-Fiber
Message-ID: <YA7mm52f4Ub4EEbg@lunn.ch>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210111113909.31702-1-pali@kernel.org>
 <20210118093435.coy3rnchbmlkinpe@pali>
 <20210125140957.4afiqlfprm65jcr5@pali>
 <20210125141643.GD1551@shell.armlinux.org.uk>
 <20210125142301.qkvjyzrm3efkkikn@pali>
 <20210125144221.GE1551@shell.armlinux.org.uk>
 <20210125144703.ekzvp27uqwgdxmsn@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125144703.ekzvp27uqwgdxmsn@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ok! If this is the only remaining issue, I will update commit messages
> and send a new patch series. I was just waiting for a response if
> somebody else has other comments or if somebody write that is fine with
> it.

Hi Pali

As a general rule of thumb, with netdev, wait 3 days and then send the
next version. If the change request is minor, everybody seems to be in
agreement, you can wait just one day. Please don't send new versions
faster than that.

       Andrew
