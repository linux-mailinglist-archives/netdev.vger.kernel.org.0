Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C686218D92
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbgGHQyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:54:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53544 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730299AbgGHQyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 12:54:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtDKc-004Cyh-N6; Wed, 08 Jul 2020 18:54:02 +0200
Date:   Wed, 8 Jul 2020 18:54:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: phy: Define PHY statistics
 ethtool_phy_ops
Message-ID: <20200708165402.GE928075@lunn.ch>
References: <20200708164625.40180-1-f.fainelli@gmail.com>
 <20200708164625.40180-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708164625.40180-2-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 09:46:24AM -0700, Florian Fainelli wrote:
> Extend ethtool_phy_ops to include the 3 function pointers necessary for
> implementing PHY statistics. In a subsequent change we will uninline
> those functions.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
