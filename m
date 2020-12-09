Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06252D446F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgLIOde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:33:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLIOdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:33:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn0WO-00B48x-26; Wed, 09 Dec 2020 15:32:48 +0100
Date:   Wed, 9 Dec 2020 15:32:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: fec: Clear stale flag in IEVENT register
 before MII transfers
Message-ID: <20201209143248.GG2611606@lunn.ch>
References: <20201209102959.2131-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201209102959.2131-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 11:29:59AM +0100, Uwe Kleine-König wrote:
> For some mii transfers the MII bit in the event register is already set
> before a read or write transfer is started. This breaks evaluating the
> transfer's result because it is checked too early.
> 
> Before MII transfers were switched from irq to polling this was not an
> issue because then it just resulted in an irq which completed the
> mdio_done completion. This completion however was reset before each
> transfer and so the event didn't hurt.
> 
> This fixes NFS booting on an i.MX25 based machine.
> 
> Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I tried (shortly) to find out what actually results in this bit being
> set because looking at f166f890c8f0 I'd say it cares enough. It's just
> proven by the real world that it's not good enough :-)
> 
> Best regards
> Uwe

Hi Uwe

Humm. This should of been fixed already. Has a patch been dropped?

Let me go look at the history.

    Andrew
