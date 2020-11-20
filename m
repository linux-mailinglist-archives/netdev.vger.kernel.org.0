Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40212B9F79
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgKTAzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:55:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbgKTAzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 19:55:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfuiA-0082O4-8i; Fri, 20 Nov 2020 01:55:38 +0100
Date:   Fri, 20 Nov 2020 01:55:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     lkp@intel.com, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v10 2/4] net: phy: Add 5GBASER interface mode
Message-ID: <20201120005538.GY1804098@lunn.ch>
References: <cover.1605830552.git.pavana.sharma@digi.com>
 <ce2bdff4ef9a98e47d93b3e183327f16acf05768.1605830552.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce2bdff4ef9a98e47d93b3e183327f16acf05768.1605830552.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:25:33AM +1000, Pavana Sharma wrote:
> Add 5GBASE-R phy interface mode
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> ---
>  include/linux/phy.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index eb3cb1a98b45..71e280059ec5 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
>   * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
>   * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
>   * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
> + * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
>   * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
>   * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
>   * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
> @@ -137,6 +138,8 @@ typedef enum {
>  	PHY_INTERFACE_MODE_TRGMII,
>  	PHY_INTERFACE_MODE_1000BASEX,
>  	PHY_INTERFACE_MODE_2500BASEX,
> +	/* 5GBASE-R mode */
> +	PHY_INTERFACE_MODE_5GBASER,


Again, what is the value of the comment? 10GBASE-R has a comment
because it is different from the rest, XFI and SFI caused a of
discussion, and it was used wrong. But there does not seem to be
anything special for 5GBASE-R.

	 Andrew
