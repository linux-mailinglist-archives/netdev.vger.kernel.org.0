Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265703EF4AE
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 23:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhHQVL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 17:11:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhHQVLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 17:11:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8qoTyawVXKotmiDHx+N4CisOVDlQx6rCGZSPJMmaLy8=; b=gYnEeHPuo2g3ld0B0VjGpaynZN
        hTvfbmNkq1MLBQf+O9bQaI1Go5NdDWQt0hWVPnGk14dJQXbj8GHB5mUXxigPoFoMD7qPasxz2QAIW
        mHhQpVHe6UBRovBGk7IcUyoXWKFDqTvktWCdSnGcP56DXQp2Qd2iOup5m7OxAxXOGguo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mG6Lw-000eQd-6R; Tue, 17 Aug 2021 23:10:32 +0200
Date:   Tue, 17 Aug 2021 23:10:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/3] net: mdio-mux: Delete unnecessary devm_kfree
Message-ID: <YRwlyH0cjazjsSwe@lunn.ch>
References: <20210817180841.3210484-1-saravanak@google.com>
 <20210817180841.3210484-2-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817180841.3210484-2-saravanak@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 11:08:39AM -0700, Saravana Kannan wrote:
> The whole point of devm_* APIs is that you don't have to undo them if you
> are returning an error that's going to get propagated out of a probe()
> function. So delete unnecessary devm_kfree() call in the error return path.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Kevin Hilman <khilman@baylibre.com>
> Tested-by: Kevin Hilman <khilman@baylibre.com>

Please add a Fixes: tag, since you want this in stable.

All three patches need fixes tags, possibly different for each patch?

       Andrew
