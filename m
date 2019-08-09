Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EECF88323
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406607AbfHITH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:07:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48654 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfHITH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 15:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j8lWV3Z0eksOQSkWHRVeohf3Ffl0SNn7eVIGMaHTwuw=; b=mNQfxb1Jqx5G0ZnaGdCmer9TsY
        vj/Ow/fne5n5D/HKAwPpIkC7Nce/YEliKDsJ8z/QzvjnnzARWwEb0rxfx/Fd7bu1i46E63omNfBGr
        i9kUvyMYjoA3gNmHtwUzuY3l8YnCThlcovzPzU9aocrMobH/eWSKmncFgaKcibfozgsM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwAEX-0003yz-Mc; Fri, 09 Aug 2019 21:07:25 +0200
Date:   Fri, 9 Aug 2019 21:07:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/4] net: phy: simplify genphy_config_advert
 by using the linkmode_adv_to_xxx_t functions
Message-ID: <20190809190725.GX27917@lunn.ch>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
 <6ba42ade-5874-9bc9-4f4d-b80f79c0deca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ba42ade-5874-9bc9-4f4d-b80f79c0deca@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 08:43:04PM +0200, Heiner Kallweit wrote:
> Using linkmode_adv_to_mii_adv_t and linkmode_adv_to_mii_ctrl1000_t
> allows to simplify the code. In addition avoiding the conversion to
> the legacy u32 advertisement format allows to remove the warning.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
