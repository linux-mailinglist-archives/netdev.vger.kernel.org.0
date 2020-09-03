Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4852425B82E
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgICBQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:16:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39232 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgICBQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 21:16:49 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDdrg-00Cxmk-QV; Thu, 03 Sep 2020 03:16:36 +0200
Date:   Thu, 3 Sep 2020 03:16:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: mvpp2: restructure "link status"
 interrupt handling
Message-ID: <20200903011636.GF3071395@lunn.ch>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
 <E1kDVMF-0000j7-3U@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kDVMF-0000j7-3U@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 05:11:35PM +0100, Russell King wrote:
> The "link status" interrupt is used for more than just link status.
> Restructure mvpp2_link_status_isr() so we can add additional handling.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

I don't particularly know this code, so it would be good to get others
to review it as well, but.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
