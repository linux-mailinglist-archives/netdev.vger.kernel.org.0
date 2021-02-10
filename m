Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9100315CFB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhBJCMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:12:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235262AbhBJCLQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 21:11:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9exa-005E2H-M6; Wed, 10 Feb 2021 03:10:30 +0100
Date:   Wed, 10 Feb 2021 03:10:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 8/9] net: phy: icplus: add PHY counter for IP101G
Message-ID: <YCNAlrJ2eZ7OG07J@lunn.ch>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-9-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209164051.18156-9-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:40:50PM +0100, Michael Walle wrote:
> The IP101G provides three counters: RX packets, CRC errors and symbol
> errors. The error counters can be configured to clear automatically on
> read. Unfortunately, this isn't true for the RX packet counter. Because
> of this and because the RX packet counter is more likely to overflow,
> than the error counters implement only support for the error counters.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
