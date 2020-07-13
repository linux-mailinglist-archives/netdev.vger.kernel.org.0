Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBEC21DE1C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgGMRBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:01:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbgGMRBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 13:01:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jv1pP-004tYR-Cs; Mon, 13 Jul 2020 19:01:19 +0200
Date:   Mon, 13 Jul 2020 19:01:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 1/4] net: phy: add USXGMII link partner
 ability constants
Message-ID: <20200713170119.GI1078057@lunn.ch>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-2-michael@walle.cc>
 <20200713163416.3fegjdbrp6ccoqdm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713163416.3fegjdbrp6ccoqdm@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 07:34:16PM +0300, Vladimir Oltean wrote:
> On Thu, Jul 09, 2020 at 11:35:23PM +0200, Michael Walle wrote:
> > The constants are taken from the USXGMII Singleport Copper Interface
> > specification. The naming are based on the SGMII ones, but with an MDIO_
> > prefix.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>
> > ---
> 
> Somebody would need to review this patch, as it is introducing UAPI.

Anybody have a link to the "USXGMII Singleport Copper Interface"
specification.

Thanks
	Andrew
