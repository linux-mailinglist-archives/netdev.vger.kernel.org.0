Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6CB1B7707
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgDXNdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:33:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDXNdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 09:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s2yS0y/GLgicYB+wMuxSZduZh7mEuhK62X0kOl/Ok38=; b=EfU8675NHyVVTYicprhLE9sGJ/
        rLtTv5Jv7xF4Apw30dSHgykDhkCVXVEmzsCbKiswWpWqHonM5Y+hbybzlLpTZg1GFhjTVBLvlBIjk
        QD71PApYfzlwi88EeTJ6waNUrW9LBWyO5VR4aOSj53ElM8Lv6Br3CGSUWvfNGc2vkQjc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRySd-004YuI-QX; Fri, 24 Apr 2020 15:33:43 +0200
Date:   Fri, 24 Apr 2020 15:33:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH -next] net: phy: dp83867: Remove unneeded semicolon
Message-ID: <20200424133343.GA1087366@lunn.ch>
References: <20200424090850.96778-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424090850.96778-1-zhengbin13@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 05:08:50PM +0800, Zheng Bin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/phy/dp83867.c:368:2-3: Unneeded semicolon
> drivers/net/phy/dp83867.c:403:2-3: Unneeded semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
