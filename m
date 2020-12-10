Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743982D68A6
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393748AbgLJU1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 15:27:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgLJU1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 15:27:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knSWY-00BHeN-Va; Thu, 10 Dec 2020 21:26:50 +0100
Date:   Thu, 10 Dec 2020 21:26:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port()
 helper
Message-ID: <20201210202650.GA2654274@lunn.ch>
References: <20201102180326.GA2416734@kroah.com>
 <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm>
 <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com>
 <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
 <20201210154651.GV1551@shell.armlinux.org.uk>
 <CAPv3WKdWr0zfuTkK+x6u7C6FpFxkVtRFrEq1FvemVpLYw2+5ng@mail.gmail.com>
 <20201210175619.GW1551@shell.armlinux.org.uk>
 <CAPv3WKe+2UKedYXgFh++-OLrJwQAyCE1i53oRUgp28z6AbaXLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKe+2UKedYXgFh++-OLrJwQAyCE1i53oRUgp28z6AbaXLg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +1. As soon as the MDIO+ACPI lands, I plan to do the rework.

Don't hold you breath. It has gone very quiet about ACPI in net
devices.

	Andrew
