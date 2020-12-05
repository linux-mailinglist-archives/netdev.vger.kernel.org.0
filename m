Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61AA2CFD1E
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgLESTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbgLERzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 12:55:06 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1klYa6-00AMgV-Mj; Sat, 05 Dec 2020 15:30:38 +0100
Date:   Sat, 5 Dec 2020 15:30:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        nicolas.ferre@microchip.com, linux@armlinux.org.uk,
        paul.walmsley@sifive.com, palmer@dabbelt.com, yash.shah@sifive.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH 1/7] net: macb: add userio bits as platform configuration
Message-ID: <20201205143038.GD2420376@lunn.ch>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
 <1607085261-25255-2-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607085261-25255-2-git-send-email-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:34:15PM +0200, Claudiu Beznea wrote:
> This is necessary for SAMA7G5 as it uses different values for
> PHY interface and also introduces hdfctlen bit.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
