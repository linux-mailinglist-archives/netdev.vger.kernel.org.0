Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2D2CFD0B
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgLEST3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40340 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbgLERwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 12:52:15 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klYbR-00AMhO-FB; Sat, 05 Dec 2020 15:32:01 +0100
Date:   Sat, 5 Dec 2020 15:32:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        nicolas.ferre@microchip.com, linux@armlinux.org.uk,
        paul.walmsley@sifive.com, palmer@dabbelt.com, yash.shah@sifive.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH 2/7] net: macb: add capability to not set the clock rate
Message-ID: <20201205143201.GE2420376@lunn.ch>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
 <1607085261-25255-3-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607085261-25255-3-git-send-email-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:34:16PM +0200, Claudiu Beznea wrote:
> SAMA7G5's ethernet IPs TX clock could be provided by its generic clock or
> by the external clock provided by the PHY. The internal IP logic divides
> properly this clock depending on the link speed. The patch adds a new
> capability so that macb_set_tx_clock() to not be called for IPs having
> this capability (the clock rate, in case of generic clock, is set at the
> boot time via device tree and the driver only enables it).
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
