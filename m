Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB64829DBBE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390789AbgJ2AN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731745AbgJ2ANX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXkAR-003y9L-A8; Wed, 28 Oct 2020 13:03:03 +0100
Date:   Wed, 28 Oct 2020 13:03:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     f.fainelli@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v5 1/3] net: phy: Add 5GBASER interface mode
Message-ID: <20201028120303.GA933237@lunn.ch>
References: <cover.1603837678.git.pavana.sharma@digi.com>
 <a64c292dad43a28ca77145d7d82cb9db3b775cb0.1603837679.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a64c292dad43a28ca77145d7d82cb9db3b775cb0.1603837679.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 10:08:27AM +1000, Pavana Sharma wrote:
> Add new mode supported by MV88E6393 family.
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
> ---
>  include/linux/phy.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 3a09d2bf69ea..9de7c57cfd38 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -107,6 +107,7 @@ typedef enum {
>  	PHY_INTERFACE_MODE_2500BASEX,
>  	PHY_INTERFACE_MODE_RXAUI,
>  	PHY_INTERFACE_MODE_XAUI,
> +	PHY_INTERFACE_MODE_5GBASER,
>  	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
>  	PHY_INTERFACE_MODE_10GBASER,
>  	PHY_INTERFACE_MODE_USXGMII,


Hi Pavana

You need to add this new mode to the kerneldoc above the
typedef. Otherwise you will get a warning from W=1 and kernel
documentation build process.

	Andrew
