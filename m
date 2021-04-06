Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1EA355F62
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236062AbhDFXWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:22:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232287AbhDFXWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 19:22:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTv1L-00FCwg-JF; Wed, 07 Apr 2021 01:22:07 +0200
Date:   Wed, 7 Apr 2021 01:22:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 05/18] net: phy: marvell10g: add all MACTYPE
 definitions for 88X33x0
Message-ID: <YGztH+HO3nTPEb9Q@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
 <20210406221107.1004-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210406221107.1004-6-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 12:10:54AM +0200, Marek Behún wrote:
> Add all MACTYPE definitions for 88X3310, 88X3310P, 88X3340 and 88X3340P.
> 
> In order to have consistent naming, rename
> MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH to
> MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
