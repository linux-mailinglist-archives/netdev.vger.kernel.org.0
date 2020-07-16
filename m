Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA531222C7E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 22:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbgGPUKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 16:10:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728907AbgGPUKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 16:10:07 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwACd-005V5H-0X; Thu, 16 Jul 2020 22:09:59 +0200
Date:   Thu, 16 Jul 2020 22:09:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        michael@walle.cc
Subject: Re: [PATCH net-next] net: phy: continue searching for C45 MMDs even
 if first returned ffff:ffff
Message-ID: <20200716200959.GD1308244@lunn.ch>
References: <20200712164815.1763532-1-olteanv@gmail.com>
 <20200716120139.78f6f9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716120139.78f6f9a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 12:01:39PM -0700, Jakub Kicinski wrote:
> On Sun, 12 Jul 2020 19:48:15 +0300 Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > At the time of introduction, in commit bdeced75b13f ("net: dsa: felix:
> > Add PCS operations for PHYLINK"), support for the Lynx PCS inside Felix
> > was relying, for USXGMII support, on the fact that get_phy_device() is
> > able to parse the Lynx PCS "device-in-package" registers for this C45
> > MDIO device and identify it correctly.
> > [...]
> 
> PHY folks, is this part of the larger PCS discussion or something
> you're happy to have applied in the current form?

Hi Jakub

This seems fine, independent of the PCS discussions.

     Andrew
