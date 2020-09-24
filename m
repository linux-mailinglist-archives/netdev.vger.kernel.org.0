Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365DB2765A5
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgIXBHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:07:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIXBHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 21:07:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLFjT-00FxFV-4Q; Thu, 24 Sep 2020 03:07:35 +0200
Date:   Thu, 24 Sep 2020 03:07:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 2/3] of: add of_mdio_find_device() api
Message-ID: <20200924010735.GH3770354@lunn.ch>
References: <20200923154123.636-1-ioana.ciornei@nxp.com>
 <20200923154123.636-3-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923154123.636-3-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 06:41:22PM +0300, Ioana Ciornei wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Add a helper function which finds the mdio_device structure given a
> device tree node. This is helpful for finding the PCS device based on a
> DTS node but managing it as a mdio_device instead of a phy_device.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
