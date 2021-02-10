Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7E6315CAE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhBJB5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:57:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59134 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235054AbhBJB4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 20:56:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9eit-005DoA-Eq; Wed, 10 Feb 2021 02:55:19 +0100
Date:   Wed, 10 Feb 2021 02:55:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 1/9] net: phy: icplus: use PHY_ID_MATCH_MODEL()
 macro
Message-ID: <YCM9B/XhNM02GCLx@lunn.ch>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209164051.18156-2-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:40:43PM +0100, Michael Walle wrote:
> Simpify the initializations of the structures. There is no functional
> change.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
