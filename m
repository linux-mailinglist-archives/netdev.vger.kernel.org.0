Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327928A949
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfHLV1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:27:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54502 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbfHLV1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 17:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y7KWCE7PfCzOe5GGzcvFtvKHGkDQGmAAlax+DhcKY5M=; b=rmmMgAAEbv1QCKTT5/4Fu/n5ZU
        yGMvVirxtlfpxICFeGLcySHH9I40KydjGifn8q+Ua49Z+gbmtBbd2HSXnv8icmywAv/IPl/lOt7z+
        uL4dQImdzS7zVvDPs/mKsdT5HbZZ5/UJAXiTDeZPBqsTycgxAyV8PKGuoYaF1mfeyoD0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxHqV-0004O8-Ib; Mon, 12 Aug 2019 23:27:15 +0200
Date:   Mon, 12 Aug 2019 23:27:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add __set_linkmode_max_speed
Message-ID: <20190812212715.GB15047@lunn.ch>
References: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
 <5067e168-7b49-7ba9-1f17-89d17509d423@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5067e168-7b49-7ba9-1f17-89d17509d423@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:19:31PM +0200, Heiner Kallweit wrote:
> We will need the functionality of __set_linkmode_max_speed also for
> linkmode bitmaps other than phydev->supported. Therefore split it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy-core.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 9ae3abb2d..de085f255 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -207,14 +207,15 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
>  	return count;
>  }
>  
> -static int __set_phy_supported(struct phy_device *phydev, u32 max_speed)
> +static int __set_linkmode_max_speed(struct phy_device *phydev, u32 max_speed,
> +				    unsigned long *addr)
>  {

Hi Heiner

It looks like phydev is an unused parameter. Maybe it should be
removed?

	Andrew
