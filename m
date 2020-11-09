Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930EC2AC27E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgKIRg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:36:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732186AbgKIRg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 12:36:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcB5a-0067LI-Jn; Mon, 09 Nov 2020 18:36:22 +0100
Date:   Mon, 9 Nov 2020 18:36:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: microchip_t1: Don't set .config_aneg
Message-ID: <20201109173622.GC1456319@lunn.ch>
References: <20201109091605.3951c969@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109091605.3951c969@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 09:16:05AM +0800, Jisheng Zhang wrote:
> The .config_aneg in microchip_t1 is genphy_config_aneg, so it's not
> needed, because the phy core will call genphy_config_aneg() if the
> .config_aneg is NULL.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
