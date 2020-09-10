Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D16E264C64
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgIJSJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:09:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgIJSJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 14:09:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGR0G-00E6lI-Q6; Thu, 10 Sep 2020 20:09:00 +0200
Date:   Thu, 10 Sep 2020 20:09:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: dp83869: Add ability to advertise
 Fiber connection
Message-ID: <20200910180900.GE3354160@lunn.ch>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-2-dmurphy@ti.com>
 <20200905111755.4bd874b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200907142911.GT3112546@lunn.ch>
 <aea8db25-88a9-d8d2-1a26-ecb81dbeb2b5@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aea8db25-88a9-d8d2-1a26-ecb81dbeb2b5@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The note in the ethtool.h says
> 
>     /* Last allowed bit for __ETHTOOL_LINK_MODE_LEGACY_MASK is bit
>      * 31. Please do NOT define any SUPPORTED_* or ADVERTISED_*
>      * macro for bits > 31. The only way to use indices > 31 is to
>      * use the new ETHTOOL_GLINKSETTINGS/ETHTOOL_SLINKSETTINGS API.
>      */
> 
> Which was added by Heiner
> 
> I guess I would prefer to add this in a separate patchset once I figure out
> how the ETHTOOL_GLINKSETTINGS/ETHTOOL_SLINKSETTINGS API works

The phydev supported value is no longer a u32, it is now a bitmap. So
you can do something like

linkmode_set_bit(ETHTOOL_LINK_MODE_100BaseFX_Full_BIT, &supported);

       Andrew
