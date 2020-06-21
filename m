Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A75202B78
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgFUPv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:51:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgFUPv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 11:51:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jn2G9-001XcF-M2; Sun, 21 Jun 2020 17:51:53 +0200
Date:   Sun, 21 Jun 2020 17:51:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v2 0/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200621155153.GC338481@lunn.ch>
References: <20200621110005.23306-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621110005.23306-1-ioana.ciornei@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana

I will be submitting a patchset soon which does as Russell requested,
moving drivers into subdirectories.

As part of that, i rename mdio-xpcs to pcs-xpcs, and change its
Kconfig symbol to PCS_XPCS. It would be nice if you could follow this
new naming, so all i need to do is a move.

Thanks
	Andrew

