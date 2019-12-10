Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1488B118ECB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfLJRVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:21:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbfLJRVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 12:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A34+YIdrcJBwvQW+C7iVgEowUT9pCnXVfFyFW8nJ4Q0=; b=AgfByVZ+KglZawJkBhCw0XJ6uF
        xcBH4PJapl054zHtnKGDSD7k56Hxsusy1mzIVX8ODx4ck+FxO7+Bp+CHNzSO0fFrTdO44HiNfWHtN
        NMlCU3VK14FSD3UZ2VEHPm8GGbrqVqF4j4uRVYXEwxCzM61Dg5eMRYD2YTF7wL2SHxyY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iejC9-0005ih-Fn; Tue, 10 Dec 2019 18:21:09 +0100
Date:   Tue, 10 Dec 2019 18:21:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 14/14] net: sfp: add support for Clause 45
 PHYs
Message-ID: <20191210172109.GS27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKp0-0004w3-Pb@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKp0-0004w3-Pb@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:19:38PM +0000, Russell King wrote:
> Some SFP+ modules have a Clause 45 PHY onboard, which is accessible via
> the normal I2C address.  Detect 10G BASE-T PHYs which may have an
> accessible PHY and probe for it.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
