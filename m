Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0555B2C19DB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgKXAOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:14:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46314 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgKXAOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 19:14:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khLyZ-008ZLR-Ap; Tue, 24 Nov 2020 01:14:31 +0100
Date:   Tue, 24 Nov 2020 01:14:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201124001431.GA2031446@lunn.ch>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 10:06:16PM +0000, Russell King wrote:
> Add debugfs support to SFP so that the internal state of the SFP state
> machines and hardware signal state can be viewed from userspace, rather
> than having to compile a debug kernel to view state state transitions
> in the kernel log.  The 'state' output looks like:
> 
> Module state: empty
> Module probe attempts: 0 0
> Device state: up
> Main state: down
> Fault recovery remaining retries: 5
> PHY probe remaining retries: 12
> moddef0: 0
> rx_los: 1
> tx_fault: 1
> tx_disable: 1
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Hi Russell

This looks useful. I always seem to end up recompiling the kernel,
which as you said, this should avoid.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
