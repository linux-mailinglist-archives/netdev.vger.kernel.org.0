Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30BD315CEE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhBJCKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:10:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59222 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233870AbhBJCIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 21:08:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9ev1-005Dzn-5T; Wed, 10 Feb 2021 03:07:51 +0100
Date:   Wed, 10 Feb 2021 03:07:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before
 writing control register
Message-ID: <YCM/99gMNAIp0hof@lunn.ch>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209164051.18156-8-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:40:49PM +0100, Michael Walle wrote:
> Registers >= 16 are paged. Be sure to set the page. It seems this was
> working for now, because the default is correct for the registers used
> in the driver at the moment. But this will also assume, nobody will
> change the page select register before linux is started. The page select
> register is _not_ reset with a soft reset of the PHY.
> 
> Add read_page()/write_page() support for the IP101G and use it
> accordingly.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
