Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1971E6EE2
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437058AbgE1W1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:27:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436986AbgE1W0h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:26:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WIAurDbJhRU2bMqfTU0tbNXCiq89iTe2xuHb04LIRas=; b=noWGsAHLqnNhHjixfClchBngOd
        /oQv60GkoRZ0u2Sf/O/X8mM6k2CaJTORGWljquPPsGKdT9W1OHgJvXmy2AzqD6T2F835HtqNBSRNR
        j1e87mO07ETmsSKVKsr2HXU4Y37p1CppE1XpFFdBHUlv0upB/XTqckbAlWf8qFEagZvE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeQyw-003aT4-Cd; Fri, 29 May 2020 00:26:34 +0200
Date:   Fri, 29 May 2020 00:26:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V7 04/19] net: ks8851: Pass device node into
 ks8851_init_mac()
Message-ID: <20200528222634.GC853774@lunn.ch>
References: <20200528222146.348805-1-marex@denx.de>
 <20200528222146.348805-5-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528222146.348805-5-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:21:31AM +0200, Marek Vasut wrote:
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

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
