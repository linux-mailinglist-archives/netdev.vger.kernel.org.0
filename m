Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D414C18580A
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCOByH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgCOByH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=moNYRuU53fYqHS+ZEW4JjZQBnfNeLEOzT0t53vHqWVg=; b=05kArL3HVCrMd//YhRkInMKQhh
        zHtqkdt2aNWzJs0WOiy/RFtvW+ST5i1LkrKkmuwJt6d0ZBNtLV2wZfqqe2iR8NAtOeU7nzSc8UpPL
        b/LnPPrBBsMr/qSDML8CWOQH1SVJVkG62OHoG6TUzuNmKaoeCP3xzYzf1h+GXMax2914=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDEpO-0002Zv-Tc; Sat, 14 Mar 2020 23:00:18 +0100
Date:   Sat, 14 Mar 2020 23:00:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH REPOST3 net-next 0/3] net: add phylink support for PCS
Message-ID: <20200314220018.GH8622@lunn.ch>
References: <20200314103102.GJ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200314103102.GJ25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:31:02AM +0000, Russell King - ARM Linux admin wrote:
> Depends on "net: mii clause 37 helpers".
> 
> This series adds support for IEEE 802.3 register set compliant PCS
> for phylink.  In order to do this, we:
> 
> 1. add accessors for modifying a MDIO device register, and use them in
>    phylib, rather than duplicating the code from phylib.
> 2. add support for decoding the advertisement from clause 22 compatible
>    register sets for clause 37 advertisements and SGMII advertisements.
> 3. add support for clause 45 register sets for 10GBASE-R PCS.

Hi Russell

How big is the patchset which actually makes use of this code? It is
normal to add helpers and at least one user in the same patchset. But
if that would make the patchset too big, there could be some leeway.

   Thanks
	Andrew
