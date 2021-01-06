Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070C82EC64B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbhAFWj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:39:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53942 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbhAFWj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 17:39:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxHSR-00GXFC-MK; Wed, 06 Jan 2021 23:39:11 +0100
Date:   Wed, 6 Jan 2021 23:39:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: replace mutex_is_locked with
 lockdep_assert_held in phylib
Message-ID: <X/Y8D2TgQDBumfvO@lunn.ch>
References: <ccc40b9d-8ee0-43a1-5009-2cc95ca79c85@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccc40b9d-8ee0-43a1-5009-2cc95ca79c85@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 02:03:40PM +0100, Heiner Kallweit wrote:
> Switch to lockdep_assert_held(_once), similar to what is being done
> in other subsystems. One advantage is that there's zero runtime
> overhead if lockdep support isn't enabled.

Hi Heiner

I'm not sure we are bothered about performance here. MDIO operations
are slow, a mutex check is fast relative to that.

I wonder how many do development work with lockdep enabled? I think i
prefer catching hard to find locking bugs earlier, verses a tiny
performance overhead.

       Andrew
