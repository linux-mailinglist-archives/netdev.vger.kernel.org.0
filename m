Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221032DD61
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhCDWwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232609AbhCDWwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:52:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D5E64FF1;
        Thu,  4 Mar 2021 22:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614898324;
        bh=2ShpxM9PDt5ZBzXs/481jsdJhfpLD41dsosE11JszBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oLlHz0Jxob8Fd/tZsJDndtSKIgCJIqWMTkFeb6TtTj8vkbaOSsp49dcLr5qtZw0Dm
         S32I5HiOKMpm3+FAn1LHXziegDzxrgruxNPQIlnXex8zAD+ZUNIMyZ1Ea5Fi9HEFc5
         T/8JzZ3XLEl7fP00+apr14OYvgUH9G0WGKOEgcaRa6HBQZ8LzsADPIiDolgidw6Oi4
         TpdQuBQeWsodio6HtjEQ8jy/irdNPltISD0QFf9IUNd6nEUDHCwyjrcqfADkT3cqI4
         i8IQRoC4DzOQdYx5xeNtNiFKYs0GZROjeFJ2eP4jtHTfALeEPS9KhBkISYZv/MRYGQ
         1R6oUBYb97+VA==
Date:   Thu, 4 Mar 2021 16:52:02 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 043/141] net: cassini: Fix fall-through warnings for Clang
Message-ID: <20210304225202.GB105908@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <30b387eebc875f8083a84b0571460820692fa0d8.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30b387eebc875f8083a84b0571460820692fa0d8.1605896059.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It's been more than 3 months; who can take this, please? :)

Thanks
--
Gustavo

On Fri, Nov 20, 2020 at 12:31:02PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of just letting the code
> fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/sun/cassini.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
> index 9ff894ba8d3e..54f45d8c79a7 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -1599,6 +1599,7 @@ static inline int cas_mdio_link_not_up(struct cas *cp)
>  			cas_phy_write(cp, MII_BMCR, val);
>  			break;
>  		}
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.27.0
> 
