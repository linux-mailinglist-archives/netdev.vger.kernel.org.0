Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3891E6EE5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437029AbgE1W1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:27:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437010AbgE1W1h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:27:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/27zeEm1FEzSY+vC1Y5STzxLlRllaq6wExRWCEECR2Y=; b=4HFQZSzkhBiTBxqbc02m6vM9Nj
        409cko7L0tGDT1b0N9J/2ALLXnaf2+3TyOllxXYAqYoCRvToskMPbMAIRPEg86kjrVZwytHjGTRa3
        VIFtS/kroxX6MnWFCLEXRQJ1X73tVPNbF8cJzHawW5DYAdoro8KpJn9xWSyK3AfagSU0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeQzv-003aU5-GS; Fri, 29 May 2020 00:27:35 +0200
Date:   Fri, 29 May 2020 00:27:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V7 07/19] net: ks8851: Remove ks8851_rdreg32()
Message-ID: <20200528222735.GD853774@lunn.ch>
References: <20200528222146.348805-1-marex@denx.de>
 <20200528222146.348805-8-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528222146.348805-8-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:21:34AM +0200, Marek Vasut wrote:
> The ks8851_rdreg32() is used only in one place, to read two registers
> using a single read. To make it easier to support 16-bit accesses via
> parallel bus later on, replace this single read with two 16-bit reads
> from each of the registers and drop the ks8851_rdreg32() altogether.
> 
> If this has noticeable performance impact on the SPI variant of KS8851,
> then we should consider using regmap to abstract the SPI and parallel
> bus options and in case of SPI, permit regmap to merge register reads
> of neighboring registers into single, longer, read.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
