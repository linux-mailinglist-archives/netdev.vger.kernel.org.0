Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968593A442D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhFKOil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 10:38:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59356 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhFKOik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 10:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5OjOCYrzYtaTS5kiVtwzbvRbcjvTIaJRWUswwxUP32E=; b=ZWf3sH4Bzje88o6LoNkWdBfCHE
        TaNr6aC5b19rdKKEDFt6pN83IhIdardOCAqA/97XtK1/Id9kOXwKkgkOi/ESuw5c/XeJgDKj267rK
        FIMIPo/pzUOQzNrUCM99Vl9v+GspEsJgdLugLKK/5ndqJcZrC5t7u7KZPPXuplfZ00h8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lriH1-008rlz-FC; Fri, 11 Jun 2021 16:36:39 +0200
Date:   Fri, 11 Jun 2021 16:36:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 2/8] net: phy: correct format of block comments
Message-ID: <YMN092dsNrUikeQJ@lunn.ch>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-3-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623393419-2521-3-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:36:53PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> Block comments should not use a trailing */ on a separate line and every
> line of a block comment should start with an '*'.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/net/phy/lxt.c      | 6 +++---
>  drivers/net/phy/national.c | 6 ++++--
>  drivers/net/phy/phy-core.c | 3 ++-
>  drivers/net/phy/phylink.c  | 9 ++++++---
>  drivers/net/phy/vitesse.c  | 3 ++-
>  5 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/lxt.c b/drivers/net/phy/lxt.c
> index bde3356..5e00910 100644
> --- a/drivers/net/phy/lxt.c
> +++ b/drivers/net/phy/lxt.c
> @@ -241,9 +241,9 @@ static int lxt973a2_read_status(struct phy_device *phydev)
>  			if (lpa < 0)
>  				return lpa;
>  
> -			/* If both registers are equal, it is suspect but not
> -			* impossible, hence a new try
> -			*/
> +		/* If both registers are equal, it is suspect but not
> +		 * impossible, hence a new try
> +		 */
>  		} while (lpa == adv && retry--);

Please indicate in the commit message why you changed the indentation.

       Andrew
