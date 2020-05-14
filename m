Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC7A1D24A1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgENBZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:25:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENBZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gQZa2juhBqDuNuGrLivzzQomxH27t5i8xWqwTX+05js=; b=UtihBpCYojCvXAq4S7JuIY5dOH
        KS0EtLP8VqSJqNKx8OM/z9oI2ERapoxs+kqpfNx/9viVUq5GnG1rzz4muJfJ1mT29TLvksXolDuUV
        WsdYUNQjXBN64rJLIJXnX/XxdnOnPVBqoCnX5yhwplEQFPFxB+NNlLqNj8t1jGv4Me7s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ2cb-002Eo7-3y; Thu, 14 May 2020 03:25:13 +0200
Date:   Thu, 14 May 2020 03:25:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 12/19] net: ks8851: Split out SPI specific entries in
 struct ks8851_net
Message-ID: <20200514012513.GG527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-13-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-13-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:40AM +0200, Marek Vasut wrote:
> Add a new struct ks8851_net_spi, which embeds the original
> struct ks8851_net and contains the entries specific only to
> the SPI variant of KS8851.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
