Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8C4315D09
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhBJCP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:15:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235428AbhBJCNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 21:13:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9eza-005E42-Sg; Wed, 10 Feb 2021 03:12:34 +0100
Date:   Wed, 10 Feb 2021 03:12:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 9/9] net: phy: icplus: add MDI/MDIX support for
 IP101A/G
Message-ID: <YCNBEhmx3hyADFyu@lunn.ch>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-10-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209164051.18156-10-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:40:51PM +0100, Michael Walle wrote:
> Implement the operations to set desired mode and retrieve the current
> mode.
> 
> This feature was tested with an IP101G.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
