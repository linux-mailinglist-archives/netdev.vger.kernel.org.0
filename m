Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5022F891E
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 00:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbhAOXD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 18:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbhAOXDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 18:03:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE15F239EE;
        Fri, 15 Jan 2021 23:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610751795;
        bh=nugy413tdUOE+8/269UQSgxe03RPvf9D9Ao+4xZZqNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iy+GdbmOWmtRJG8MUODm/vK3Y0MlCwrxIF+rKMlQvOtBPB0Lw4qLl8hvZCgU6q0dj
         2OHk2Ci7F+cyLujBHUq6XBqiosyynlC8+ii4lwZWV07EjqpLa7EynAgp20rIAQ9IC5
         D2Bbw1pC2ceR14eLcaWybz1pAY3TNykMrSZXCtHDtGsHyFQBesqZ9CwFJIX5iRa+L6
         aJ0Glq4i2XvwXgPImCNedDvArIpmNUPaolnyTgAYtTQFQntqstU8QzrfdA6s1ssoQ+
         ZajoPqvO8gWRFIe9ZVuPv9ChU6RzPtDqi5B43bN9SiZXbxtA51nmLakLD9D2zNpJRv
         aqYZcDgXsE5tg==
Date:   Fri, 15 Jan 2021 15:03:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next] net: dsa: set
 configure_vlan_while_not_filtering to true by default
Message-ID: <20210115150314.757c8740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114173426.2731780-1-olteanv@gmail.com>
References: <20210114173426.2731780-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 19:34:26 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> drivers to always receive bridge VLANs"), DSA has historically been
> skipping VLAN switchdev operations when the bridge wasn't in
> vlan_filtering mode, but the reason why it was doing that has never been
> clear. So the configure_vlan_while_not_filtering option is there merely
> to preserve functionality for existing drivers. It isn't some behavior
> that drivers should opt into. Ideally, when all drivers leave this flag
> set, we can delete the dsa_port_skip_vlan_configuration() function.

No longer applies :(
