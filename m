Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3745020F94A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732995AbgF3QTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgF3QTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 12:19:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20AD920722;
        Tue, 30 Jun 2020 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593533946;
        bh=qrEHE8MQL8ERV/sGGM/05Ao7MXyc1fsTIC8xoVVX+Vk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a2eD8u4MyB2ZmEgokS7/rET44+ZZzoB6TrBmtxbz+td8h8BYmQVWlft8SWP0FWAGB
         KSwnRAsY2F5ghVY4axuoBv4duzPRLXwl85a3WylL7YB7PcmyXEwPTGNTxZ3PDAAw/T
         FmFv//MmPxGWaZQd3a07072VFGoGhtiG42nWokOc=
Date:   Tue, 30 Jun 2020 09:19:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 10/13] net: phylink: in-band pause mode
 advertisement update for PCS
Message-ID: <20200630091904.7e477783@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <E1jqHGE-0006Pz-5h@rmk-PC.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
        <E1jqHGE-0006Pz-5h@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 15:29:22 +0100 Russell King wrote:
> +	ret = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
> +				      pl->link_config.interface,
> +				      pl->link_config.advertising,
> +				      !!(pl->link_config.pause & MLO_PAUSE_AN));

patches 10 and 11 don't build:

drivers/net/phy/phylink.c: In function phylink_change_inband_advert:
drivers/net/phy/phylink.c:485:34: error: struct phylink has no member named pcs
  485 |  ret = pl->pcs_ops->pcs_config(pl->pcs, pl->cur_link_an_mode,
      |                                  ^~
make[4]: *** [drivers/net/phy/phylink.o] Error 1
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [drivers/net/phy] Error 2
make[3]: *** Waiting for unfinished jobs....
