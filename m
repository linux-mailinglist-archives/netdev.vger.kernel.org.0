Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6712978A3
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 23:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752338AbgJWVEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 17:04:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42410 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751213AbgJWVEd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 17:04:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kW4Eb-003Azi-6p; Fri, 23 Oct 2020 23:04:25 +0200
Date:   Fri, 23 Oct 2020 23:04:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 18/56] net: phy: fix kernel-doc markups
Message-ID: <20201023210425.GG752111@lunn.ch>
References: <cover.1603469755.git.mchehab+huawei@kernel.org>
 <d23c5638c4fd0e7b9f294f2bf647d2386428eb7e.1603469755.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d23c5638c4fd0e7b9f294f2bf647d2386428eb7e.1603469755.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 06:33:05PM +0200, Mauro Carvalho Chehab wrote:
> Some functions have different names between their prototypes
> and the kernel-doc markup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  drivers/net/phy/mdio_bus.c   | 2 +-
>  drivers/net/phy/phy-c45.c    | 2 +-
>  drivers/net/phy/phy.c        | 2 +-
>  drivers/net/phy/phy_device.c | 2 +-
>  drivers/net/phy/phylink.c    | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 757e950fb745..e59067c64e97 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -472,7 +472,7 @@ static inline void of_mdiobus_link_mdiodev(struct mii_bus *mdio,
>  #endif
>  
>  /**
> - * mdiobus_create_device_from_board_info - create a full MDIO device given
> + * mdiobus_create_device - create a full MDIO device given
>   * a mdio_board_info structure
>   * @bus: MDIO bus to create the devices on
>   * @bi: mdio_board_info structure describing the devices

Hi Mauro

If you need to repost, could you make use of:

-U<n>
--unified=<n>
Generate diffs with <n> lines of context instead of the usual three.

to increase the number of lines of context. Often three lines is not
enough to include the function declaration in the patch, so i need to
go look at the sources to do a review. 

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
