Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C384355FD9
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344928AbhDGAB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:01:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344841AbhDGAB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:01:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTvdH-00FDP2-BB; Wed, 07 Apr 2021 02:01:19 +0200
Date:   Wed, 7 Apr 2021 02:01:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 16/18] net: phy: marvell10g: differentiate
 88E2110 vs 88E2111
Message-ID: <YGz2TzbTL9jdPHhM@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
 <20210406221107.1004-17-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210406221107.1004-17-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 12:11:05AM +0200, Marek Behún wrote:
> 88E2111 is a variant of 88E2110 which does not support 5 gigabit speeds.
> 
> Differentiate these variants via the match_phy_device() method, since
> they have the same PHY ID.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
