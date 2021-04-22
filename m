Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA07368080
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbhDVMcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:32:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35624 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236168AbhDVMcC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:32:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZYUQ-000UqE-NV; Thu, 22 Apr 2021 14:31:26 +0200
Date:   Thu, 22 Apr 2021 14:31:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Kochetkov <fido_max@inbox.ru>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH 2/2] net: phy: marvell: fix m88e1111_set_downshift
Message-ID: <YIFsno+hmSnJMwOG@lunn.ch>
References: <20210422104644.9472-1-fido_max@inbox.ru>
 <20210422104644.9472-3-fido_max@inbox.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422104644.9472-3-fido_max@inbox.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 01:46:44PM +0300, Maxim Kochetkov wrote:
> Changing downshift params without software reset has no effect,
> so call genphy_soft_reset() after change downshift params.
> 
> As the datasheet says:
> Changes to these bits are disruptive to the normal operation therefore,
> any changes to these registers must be followed by software reset
> to take effect.
> 
> Fixes: 5c6bc5199b5d ("net: phy: marvell: add downshift support for M88E1111")
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
