Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769EF1BCE8F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgD1VWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:22:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgD1VWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 17:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/HEO8iV5zd2rO1zBMobf3wGw/aBe4lt0VpzkcITbvGw=; b=wUKG9YqV2CvYZGGfbJGHVLq131
        aDS5v95GCcADMiVr59oLHU15cvr4I7q0tGmCcudpyEdZN6FUaL4wlr/llwBzBwuduorDzwBxjQ6g2
        WMYjK7TPzM8jy6XbuuZPvXyNMj2zBLtVAjkBd7xnQjfdk2IVJZHEzlk0s7bpoycGofwk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTXgB-000A6P-7y; Tue, 28 Apr 2020 23:22:11 +0200
Date:   Tue, 28 Apr 2020 23:22:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/4] net: phy: bcm54140: fix phy_id_mask
Message-ID: <20200428212211.GC30459@lunn.ch>
References: <20200428210854.28088-1-michael@walle.cc>
 <20200428210854.28088-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428210854.28088-2-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:08:52PM +0200, Michael Walle wrote:
> Broadcom defines the bits for this PHY as follows:
>   { oui[24:3], model[6:0], revision[2:0] }
> 
> Thus we have to mask the lower three bits only.
> 
> Fixes: 6937602ed3f9 ("net: phy: add Broadcom BCM54140 support")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
