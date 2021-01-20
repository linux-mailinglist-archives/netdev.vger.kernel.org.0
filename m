Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD72FDAEC
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387618AbhATUeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:34:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388310AbhATU3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 15:29:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l2K68-001hi4-H4; Wed, 20 Jan 2021 21:29:00 +0100
Date:   Wed, 20 Jan 2021 21:29:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
Message-ID: <YAiSjIi0T+nO++WF@lunn.ch>
References: <20210120194303.28268-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120194303.28268-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 08:43:03PM +0100, Michael Walle wrote:
> If the MII interface is used, the PHY is the clock master, thus don't
> set the clock rate. On Zynq-7000, this will prevent the following
> warning:
>   macb e000b000.ethernet eth0: unable to generate target frequency: 25000000 Hz
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
