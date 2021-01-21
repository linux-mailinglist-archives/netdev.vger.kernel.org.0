Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837472FF5A9
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbhAUUQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:16:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbhAUUQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 15:16:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2gMy-001t9P-8d; Thu, 21 Jan 2021 21:15:52 +0100
Date:   Thu, 21 Jan 2021 21:15:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, torii.ken1@fujitsu.com
Subject: Re: [PATCH v3] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <YAng+Gf4pmviSuff@lunn.ch>
References: <20210121080254.21286-1-ashiduka@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121080254.21286-1-ashiduka@fujitsu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 05:02:54PM +0900, Yuusuke Ashizuka wrote:
> RTL9000AA/AN as 100BASE-T1 is following:
> - 100 Mbps
> - Full duplex
> - Link Status Change Interrupt
> - Master/Slave configuration
> 
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Signed-off-by: Torii Kenichi <torii.ken1@fujitsu.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
