Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3343A441C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhFKOeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 10:34:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhFKOeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 10:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5c/DOgmxC/uCvndJqmAcHemA+GbzSvnQ2Z0WS5qOnbo=; b=WRxQkrS6I76NGCrIGsn/tIgz5t
        RqdeJNSdfMaosgzNFwTcJ/L8xgjLgAbnumnsPgADZmVhHQP4bljHMZLNjEBLSahXyd1NXqsfi3tQY
        c9kVvrivzaBpHsnRRIIYlBkizdYkViKS21SoxDDJ8JD96F4nhilNA1ztVrSQNYxpoTyI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lriCT-008rjb-SM; Fri, 11 Jun 2021 16:31:57 +0200
Date:   Fri, 11 Jun 2021 16:31:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 1/8] net: phy: add a blank line after
 declarations
Message-ID: <YMNz3RnzhPak7XIT@lunn.ch>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-2-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623393419-2521-2-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:36:52PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> There should be a blank line after declarations.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/net/phy/bcm87xx.c  | 4 ++--
>  drivers/net/phy/dp83640.c  | 1 +
>  drivers/net/phy/et1011c.c  | 6 ++++--
>  drivers/net/phy/mdio_bus.c | 1 +
>  drivers/net/phy/qsemi.c    | 1 +
>  5 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
> index 4ac8fd1..3135634 100644
> --- a/drivers/net/phy/bcm87xx.c
> +++ b/drivers/net/phy/bcm87xx.c
> @@ -54,9 +54,9 @@ static int bcm87xx_of_reg_init(struct phy_device *phydev)
>  		u16 reg		= be32_to_cpup(paddr++);
>  		u16 mask	= be32_to_cpup(paddr++);
>  		u16 val_bits	= be32_to_cpup(paddr++);
> -		int val;
>  		u32 regnum = mdiobus_c45_addr(devid, reg);
> -		val = 0;
> +		int val = 0;
> +

This does a little bit more than add a blank line. Please mention it
in the commit message.

This is to do with trust. If you say you are just added blank lines,
the review can be very quick because you cannot break anything with
just blank lines. But as soon as i see more than just blank lines, i
can no longer trust your description, and i need to look much harder
at your changes.

> --- a/drivers/net/phy/et1011c.c
> +++ b/drivers/net/phy/et1011c.c
> @@ -46,7 +46,8 @@ MODULE_LICENSE("GPL");
>  
>  static int et1011c_config_aneg(struct phy_device *phydev)
>  {
> -	int ctl = 0;
> +	int ctl;
> +
>  	ctl = phy_read(phydev, MII_BMCR);
>  	if (ctl < 0)
>  		return ctl;

Since you made this change, you could go one step further

	int ctl = phy_read(phydev, MII_BMCR);

> @@ -60,9 +61,10 @@ static int et1011c_config_aneg(struct phy_device *phydev)
>  
>  static int et1011c_read_status(struct phy_device *phydev)
>  {
> +	static int speed;
>  	int ret;
>  	u32 val;
> -	static int speed;
> +

This is an O.K. change, but again, more than adding a blank line.

     Andrew
