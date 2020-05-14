Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD721D24BD
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgENBdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:33:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59386 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENBdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:33:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ge1uhSVf4N5vVppRYoDomUDJHZfoCaTywpL4hhJumqs=; b=XfJPQJW3QeeM8wgZmTUPEJAdNU
        rWlwKLaLTJtS0guk/XzvU7puQ58rd6FEAVjuPp/Rln51s4GvvteruBqDWuGfGRwmMDqAsqNeU70dN
        +JV09oejwT/kWVmMusgvIsbqfpI41jbRnOlJogLeXzbZAuKtRxwk3yfk1HP24Qijus1M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ2kE-002Er3-VW; Thu, 14 May 2020 03:33:06 +0200
Date:   Thu, 14 May 2020 03:33:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 14/19] net: ks8851: Factor out TX work flush function
Message-ID: <20200514013306.GI527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-15-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-15-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:42AM +0200, Marek Vasut wrote:
> While the SPI version of the KS8851 requires a TX worker thread to pump
> data via SPI, the parallel bus version can write data into the TX FIFO
> directly in .ndo_start_xmit, as the parallel bus access is much faster
> and does not sleep. Factor out this TX work flush part, so it can be
> overridden by the parallel bus driver.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
