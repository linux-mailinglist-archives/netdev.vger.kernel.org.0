Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB132DB929
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgLPCcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:32:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgLPCcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 21:32:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpMbB-00CDMM-PB; Wed, 16 Dec 2020 03:31:29 +0100
Date:   Wed, 16 Dec 2020 03:31:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 1/4] enetc: drop unneeded indirection
Message-ID: <20201216023129.GD2893264@lunn.ch>
References: <20201215212200.30915-1-michael@walle.cc>
 <20201215212200.30915-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215212200.30915-2-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:21:57PM +0100, Michael Walle wrote:
> Before commit 6517798dd343 ("enetc: Make MDIO accessors more generic and
> export to include/linux/fsl") these macros actually had some benefits.
> But after the commit it just makes the code hard to read. Drop the macro
> indirections.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
