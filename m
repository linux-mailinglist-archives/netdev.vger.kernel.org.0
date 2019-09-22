Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D76FBA32E
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 18:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbfIVQfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 12:35:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387777AbfIVQfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 12:35:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RC/meEvdlpUV870EYpdut/bVQCMHjqw0plSP4nqu3O0=; b=F1GYEpHpYGD11lOpvi3b348WGi
        +Ttzeu/eqlyRim5HJnjkw6wq3Zri+92VSw71JJ+mefh/CguJfUzvXod5GhvJPUvVLQuBm9f1qp2ee
        l9MjIb9mF6iBEeo8NI71vQshBoEzL7FYsFkn2I6ki19eYrKjlAmoz5NmsT4ig1+AWg54=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iC4pQ-0007DW-J7; Sun, 22 Sep 2019 18:35:16 +0200
Date:   Sun, 22 Sep 2019 18:35:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] net: phy: extract link partner advertisement reading
Message-ID: <20190922163516.GB27014@lunn.ch>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
 <E1iBzbD-00006v-Fb@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iBzbD-00006v-Fb@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 12:00:15PM +0100, Russell King wrote:
> Move reading the link partner advertisement out of genphy_read_status()
> into its own separate function.  This will allow re-use of this code by
> PHY drivers that are able to read the resolved status from the PHY.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
