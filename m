Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C0B1D2413
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbgENAtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:49:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59190 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbgENAtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 20:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0zSWqS0BLF8f82KzcFPyt3RJw+QvZmJoBuclVHm6jqM=; b=3f2uujsgxA6FNTyEZdH9cWAQ0V
        bvJ22SoPE5tI1K3L/bPrIGo2Myvq0VW4WdjPxzWWnVcxmmRCzdEnv3iKeVTRjO5eokYAPcojAq07Y
        NerdJZVto78Hv4HGafGy6TZ8wskpso7vbzEr5sDCZcCbiIG1oFvI6ZbVznW8UOtsSAnY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ24D-002E4c-4T; Thu, 14 May 2020 02:49:41 +0200
Date:   Thu, 14 May 2020 02:49:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 01/19] net: ks8851: Factor out spi->dev in
 probe()/remove()
Message-ID: <20200514004941.GA527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-2-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:29AM +0200, Marek Vasut wrote:
> Pull out the spi->dev into one common place in the function instead of
> having it repeated over and over again. This is done in preparation for
> unifying ks8851 and ks8851-mll drivers. No functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
