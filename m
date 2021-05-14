Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6873813DC
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234109AbhENWov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhENWot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 18:44:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722D2C06174A;
        Fri, 14 May 2021 15:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uzvr2SJMiz01S1/rzyLN8aogW3ujb7XczDU7iIHqLSY=; b=YXK26n8wp1drFRG9NdffAxYsV
        5sJSznN8zjIi0yT9/w1VfBgd95V+XzAbFfmcuigJBk9FG0fnpBW4qFCRBSz1wGwUF65T0Wj9aeCWU
        /xm/UTM1vA+J2Vp1zxu/XY6gD5r6Ykmb8gPF+5aqFISgiogxeOxWuARzMY7wKBDsa8GgQBVEgu7R1
        2tRlkcZRQxsbVL1EHveKOqpW2a3RTqNVM9RmDpJFS8TZy0UQq6drE7jDnvxbBzcx7PB2u98sfrwir
        /HAFJpcOs7SRcr6ZGOWqUrgJuU1iOgIiV5+hHkzJIi52l2H45Q73/Tp78IMhqOgS9yeugQM9DY/iB
        XBZ9wKkiQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43984)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhgWg-0000Vj-1n; Fri, 14 May 2021 23:43:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhgWe-0004Mw-MR; Fri, 14 May 2021 23:43:20 +0100
Date:   Fri, 14 May 2021 23:43:20 +0100
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
Subject: Re: [PATCH net-next v6 01/25] net: dsa: qca8k: change simple print
 to dev variant
Message-ID: <20210514224320.GH12395@shell.armlinux.org.uk>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
 <20210514210015.18142-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514210015.18142-2-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 10:59:51PM +0200, Ansuel Smith wrote:
> Change pr_err and pr_warn to dev variant.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
