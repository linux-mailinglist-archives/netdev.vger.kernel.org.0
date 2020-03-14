Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34865185821
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgCOByq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbgCOByo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=752rHxzir9rFEb3N8x/ei01N+wmMccVhGPROdsM0xzc=; b=KckaQXiTMC+Yks3n2+TPbc5oZm
        BTz8ZhszFeJ95n7ZgVYD3oTYE7Ltz2pkBJ1FETzKmp51We0ciRKSYOmAjUosSbJJk5GBEQmXwCdV/
        ccruON4GlofLyX76FxBFrn/JDwxj6ydE93XI0KmKS+8qHOkx0XPBKHlGqn3mMe9tiiGo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBbY-0001aW-Sp; Sat, 14 Mar 2020 19:33:48 +0100
Date:   Sat, 14 Mar 2020 19:33:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH REPOST net-next 0/8] net: dsa: improve serdes integration
Message-ID: <20200314183348.GD5388@lunn.ch>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314101431.GF25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:14:31AM +0000, Russell King - ARM Linux admin wrote:
> Depends on "net: mii clause 37 helpers".
> 
> Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
> does not automatically update the switch MACs with the link parameters.
> Currently, the DSA code implements a work-around for this.
> 
> This series improves the Serdes integration, making use of the recent
> phylink changes to support split MAC/PCS setups.  One noticable
> improvement for userspace is that ethtool can now report the link
> partner's advertisement.
> 
> This repost has no changes compared to the previous posting; however,
> the regression Andrew had found which exists even without this patch
> set has now been fixed by Andrew and merged into the net-next tree.

Hi Russell

With the CPU port being broken with the last version, i did not give
this much testing. Unfortunately, I'm not in a position to test this
at the moment. So i'm just going to review it. If anything breaks, we
can fix it up later.

       Andrew
