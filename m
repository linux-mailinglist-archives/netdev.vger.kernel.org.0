Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1FE357846
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhDGXKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:10:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39196 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhDGXKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 19:10:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUHJn-00FOvF-93; Thu, 08 Apr 2021 01:10:39 +0200
Date:   Thu, 8 Apr 2021 01:10:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, kuba@kernel.org
Subject: Re: [PATCH net-next v4 14/16] net: phy: marvell10g: differentiate
 88E2110 vs 88E2111
Message-ID: <YG4779sBqlcK/lbB@lunn.ch>
References: <20210407202254.29417-1-kabel@kernel.org>
 <20210407202254.29417-15-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210407202254.29417-15-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 10:22:52PM +0200, Marek Behún wrote:
> 88E2111 is a variant of 88E2110 which does not support 5 gigabit speeds.
> 
> Differentiate these variants via the match_phy_device() method, since
> they have the same PHY ID.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
