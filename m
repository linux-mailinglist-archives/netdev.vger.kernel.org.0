Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF541C53B4
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgEEKwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:52:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:51398 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgEEKwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 06:52:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 71FA5AC22;
        Tue,  5 May 2020 10:52:44 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B54CB602B9; Tue,  5 May 2020 12:52:41 +0200 (CEST)
Date:   Tue, 5 May 2020 12:52:41 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 08/10] net: phy: marvell: Add cable test
 support
Message-ID: <20200505105241.GL8237@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-9-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505001821.208534-9-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:18:19AM +0200, Andrew Lunn wrote:
> The Marvell PHYs have a couple of different register sets for
> performing cable tests. Page 7 provides the simplest to use.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/marvell.c | 202 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 202 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 7fc8e10c5f33..72afc67f7f35 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -27,6 +27,7 @@
>  #include <linux/module.h>
>  #include <linux/mii.h>
>  #include <linux/ethtool.h>
> +#include <linux/ethtool_netlink.h>
>  #include <linux/phy.h>
>  #include <linux/marvell_phy.h>
>  #include <linux/bitfield.h>
> @@ -35,6 +36,7 @@
>  #include <linux/io.h>
>  #include <asm/irq.h>
>  #include <linux/uaccess.h>
> +#include <uapi/linux/ethtool_netlink.h>
>  
>  #define MII_MARVELL_PHY_PAGE		22
>  #define MII_MARVELL_COPPER_PAGE		0x00

This shouldn't be necessary, <linux/ethtool_netlink.h> includes the UAPI
header.

[...]
> +static int mavell_vct7_cable_test_report_trans(int result)

Typo: "mavell".

Michal
