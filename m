Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D554C11F503
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 00:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfLNXLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 18:11:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbfLNXLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 18:11:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=thNFXN1cpamV+90YJ4mr3kFNYe+AmTgX6YLBssGwJqw=; b=Qf1QKaR2W1MYqcLHeeFbn+VAOH
        OMp87t3in3bFF/nJq8hNEVWm40CP95F6daGTByNYPqhOJTRfe7ARBYpRUYXUWC5xiPOSy5H/NkOtw
        A38VX/rlh1xpurY0t0KSAErn2KAcJPqVGcqZuGG/OI7n/WKxbbP8WiE/KWAxM2xf6IuI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1igGZ0-0002Su-Kf; Sun, 15 Dec 2019 00:11:06 +0100
Date:   Sun, 15 Dec 2019 00:11:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: dp83869: Remove unneeded semicolon
Message-ID: <20191214231106.GC6314@lunn.ch>
References: <1576318644-38066-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576318644-38066-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 06:17:24PM +0800, zhengbin wrote:
> Fixes coccicheck warning:
> 
> drivers/net/phy/dp83869.c:337:2-3: Unneeded semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
