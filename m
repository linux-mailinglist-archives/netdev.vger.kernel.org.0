Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F28C2EF58F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbhAHQLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:11:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbhAHQLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 11:11:30 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxuLX-00Gvey-Pc; Fri, 08 Jan 2021 17:10:39 +0100
Date:   Fri, 8 Jan 2021 17:10:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <X/iD/3dl+FxiIjUU@lunn.ch>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 05:45:54PM +0200, Claudiu Beznea wrote:
> KSZ9131 is used in setups with SAMA7G5. SAMA7G5 supports a special
> power saving mode (backup mode) that cuts the power for almost all
> parts of the SoC. The rail powering the ethernet PHY is also cut off.
> When resuming, in case the PHY has been configured on probe with
> slew rate or DLL settings these needs to be restored thus call
> driver's config_init() on resume.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
