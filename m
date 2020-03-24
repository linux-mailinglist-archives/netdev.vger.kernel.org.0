Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB79190379
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgCXB6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:58:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53316 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgCXB6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ofi5BjFBCRgWhCmZhWXBasCYhHCUTqeUBdj6Elm+zdQ=; b=ms2JKHCf4xMmfU2+qU0U5EqPPO
        4rWFXlBPfVZUQxiiPrt/Whrk68G30aK4AcmtMZfpGwcQisogqgVGaoguc4LowQLkjdHtw2Sh0MYOO
        KJ4kY5gR+ilGILv46kkvwdbYw8yxkyUT7CmxDUMfftPawmAJ64/XxmmyTFgMOkCYYNm8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYpa-0005k4-0v; Tue, 24 Mar 2020 02:58:14 +0100
Date:   Tue, 24 Mar 2020 02:58:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 10/14] net: ks8851: Split out SPI specific code from
 probe() and remove()
Message-ID: <20200324015814.GQ3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-11-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-11-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:59AM +0100, Marek Vasut wrote:
> Factor out common code into ks8851_probe_common() and
> ks8851_remove_common() to permit both SPI and parallel
> bus driver variants to use the common code path for
> both probing and removal.
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
