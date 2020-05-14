Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD141D241C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbgENAvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:51:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729973AbgENAvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 20:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e31bPwpmPZzZFxLi+GebvC4VgSjQtj+ZCKhrBFUgbRU=; b=sTwzj6tJwFyfxaRXMtHTmDNSaG
        kkYEz7DXkI9EuJfVuqdYQhw8Mq5U7JQCRcxJBLXp+nQBMnm6h35+HjqCuoWqI1NGMEvgeoK6N/j9i
        IWSVwsIJVTrXm1I78yvHEwZ/rqZeWgUS5FRVUTxVqwQSkrmQhAmQ0g+HeI90TZOT5smk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ26L-002EBN-Ac; Thu, 14 May 2020 02:51:53 +0200
Date:   Thu, 14 May 2020 02:51:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 04/19] net: ks8851: Pass device node into
 ks8851_init_mac()
Message-ID: <20200514005153.GC527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-5-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-5-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:32AM +0200, Marek Vasut wrote:
> Since the driver probe function already has a struct device *dev pointer
> and can easily derive of_node pointer from it, pass the of_node pointer as
> a parameter to ks8851_init_mac() to avoid fishing it out from ks->spidev.
> This is the only reference to spidev in the function, so get rid of it.
> This is done in preparation for unifying the KS8851 SPI and parallel bus
> drivers.
> 
> No functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
