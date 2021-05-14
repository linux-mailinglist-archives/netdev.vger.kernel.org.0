Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814CF3813F4
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhENWyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENWyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 18:54:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68239C06174A;
        Fri, 14 May 2021 15:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eh281Thqvu3kvV/Ud5/bxSwU22ZBQcfAxm4F2UK1AbY=; b=z8Q452Wlywg1WC/YDQtfboYmc
        uPwc0Gf9sTyC2uNV2tyqEtM9+KzOCOSUEZcMz4Oq9j7mCWDzHULlhl0wdw+aCTcjqqKE+Q0nEoztn
        zIv7KwJy0Uf9pEAevCjT8Ny48JXtfKsryaq8AbObUBfolq8F3NYJ2JIYHC4DllHNfPdTjVG6CQEV2
        qPsYCgegZ/rY9esDWc8sez1R9Lrkh/KJcPDPRobncn9QR7TCapQjsnxCCq0J71QgAK5CpYcVqLLAI
        ihn9Uih7O8r3jUMVy1fiWfovYTvwfOWTm/99D+yv7ZkWk8WA5O17nyebt6kgxoni+qH075w1OQiIr
        pH9bwRJuA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43988)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhggd-0000XG-B7; Fri, 14 May 2021 23:53:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhggd-0004Ni-4H; Fri, 14 May 2021 23:53:39 +0100
Date:   Fri, 14 May 2021 23:53:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 03/25] net: dsa: qca8k: improve qca8k
 read/write/rmw bus access
Message-ID: <20210514225339.GJ12395@shell.armlinux.org.uk>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
 <20210514210015.18142-4-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514210015.18142-4-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:59:53PM +0200, Ansuel Smith wrote:
> Put bus in local variable to improve faster access to the mdio bus.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
