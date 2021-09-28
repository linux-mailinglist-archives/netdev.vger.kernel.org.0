Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB2641AE83
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbhI1MNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:13:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240426AbhI1MNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 08:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7Xp7mC54QxQOrkWuTBBJLRY+NahLSxuPBi641CqpyvQ=; b=DSH7LWZNl1UR87E8Hwx/l+sai5
        2t2P8xnFIArmv/8kLYr3Ian/UByGBgUeaDfYAl9utYxEuBtEMrl+WBtywmQYi0GS0PfdpVQex8eBw
        Y53MIN+8nWRyVeWym9D/pbhXk3SxuuFQeKbByocxhuZEBJv/c73k+UWFBWQJ+7YTrnH8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVBxq-008b96-IF; Tue, 28 Sep 2021 14:12:02 +0200
Date:   Tue, 28 Sep 2021 14:12:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: mchp: Add support for LAN8804 PHY
Message-ID: <YVMGkmgwIQDMwldp@lunn.ch>
References: <20210928073502.2108815-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928073502.2108815-1-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 09:35:02AM +0200, Horatiu Vultur wrote:
> The LAN8804 PHY has same features as that of LAN8814 PHY except that it
> doesn't support 1588, SyncE or Q-USGMII.

Sorry, i missed it first time. The subject line is wrong. There is no
mchp driver in mainline.

When you fix it, please add my Reviewed-by.

     Andrew
