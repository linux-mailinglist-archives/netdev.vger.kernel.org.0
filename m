Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12201E6F05
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437149AbgE1W3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:29:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55626 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436990AbgE1W3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zSCoYYuealHo14lKIdoTmXGBNuCgNIpAS3s4+/C2qDY=; b=in9Zg72GbI3B1PsBtnd1kyWZNH
        3pd8vVexhmLGKXxkEhTYjYj/XGPGdXO8aPdJnuB+YZ2kr29L30agSSEcLbJhep9iOgop99rFoKS64
        M37sQecHwLD7agoHZi32YISily/5HJ23b5OkI9zsHWm577R2+v3FZRJ4zhB9T+mpBKtU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeR1x-003aVp-Ug; Fri, 29 May 2020 00:29:41 +0200
Date:   Fri, 29 May 2020 00:29:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V7 11/19] net: ks8851: Factor out SKB receive function
Message-ID: <20200528222941.GF853774@lunn.ch>
References: <20200528222146.348805-1-marex@denx.de>
 <20200528222146.348805-12-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528222146.348805-12-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:21:38AM +0200, Marek Vasut wrote:
> Factor out this netif_rx_ni(), so it could be overridden by the parallel
> bus variant of the KS8851 driver.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
