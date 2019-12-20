Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4967B127820
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 10:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfLTJar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 04:30:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfLTJar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 04:30:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ixfxpFTW0ArQgA/NiOTVf06aUqDgNDfmkWn3uSoWqEc=; b=KAqCn8GtrznpQEt3GI2LGRVb+R
        QtaAt1M7z5t93JkdJ+If/x+wsIu5eDtqv7uPTNyIqllLlEHILLRhylGC/89Pb1Dy6lBwiPSOivdr1
        ZtFYoksGa5tGz6Iky7ijomSTU6Sd/jlYmRYTXgnH1VqktyKXbkHFxZO2qL4C3WNfCzpQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iiEcM-0006pD-Uj; Fri, 20 Dec 2019 10:30:42 +0100
Date:   Fri, 20 Dec 2019 10:30:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: phy: ensure that phy IDs are correctly typed
Message-ID: <20191220093042.GC24174@lunn.ch>
References: <E1ii5A4-0003Ni-Vs@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ii5A4-0003Ni-Vs@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 11:24:52PM +0000, Russell King wrote:
> PHY IDs are 32-bit unsigned quantities. Ensure that they are always
> treated as such, and not passed around as "int"s.
> 
> Fixes: 13d0ab6750b2 ("net: phy: check return code when requesting PHY driver module")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
