Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52ED2314592
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhBIBXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:23:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhBIBXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 20:23:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9Hk8-004z7S-CQ; Tue, 09 Feb 2021 02:23:04 +0100
Date:   Tue, 9 Feb 2021 02:23:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: drop explicit genphy_read_status() op
Message-ID: <YCHj+FlXs0I+i8pa@lunn.ch>
References: <20210209010018.1134-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209010018.1134-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 02:00:18AM +0100, Michael Walle wrote:
> genphy_read_status() is already the default for the .read_status() op.
> Drop the unnecessary references.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
