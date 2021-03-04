Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639AA32DD68
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhCDWxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCDWxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:53:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AF0A64FF1;
        Thu,  4 Mar 2021 22:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614898401;
        bh=1JsYNck3o/hQ5eTqJqLqsRGUXDWDncBO/AnJGGfNIq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n+kDuJ4tAbrF8hpJ5kBuEJnNN4P7AHdgy2gj1Re36hiVP8gMHW3bGAoEUQnXkXwrt
         NfltMY8oXutNZY/F2ssUHt3zv2xmdgOSgjX5JrYUFd5xxdzMnA1NhGxJgYRETpNAsG
         +0mdWSles7k+xjYhgXyyWz+sTE7E09AX/qB1DYN/w7335ecjbexouCQ0MB0Acag+cu
         4Jqifhb9MyIGCrjVFfVyWOngvLvpNHBM7UUpo3xcwo8C0fFd8TavAmRuwMTRXUUdtc
         rFG0FxU92yS5J2Alpfy00CEM6nhisCcsO79e/GRz3JxsKbk5LLFqVb7saF5kAvk+TV
         Spazwb0t1+HRQ==
Date:   Thu, 4 Mar 2021 16:53:18 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 045/141] net: mscc: ocelot: Fix fall-through warnings for
 Clang
Message-ID: <20210304225318.GC105908@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <a36175068f59c804403ec36a303cf1b72473a5a5.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36175068f59c804403ec36a303cf1b72473a5a5.1605896059.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It's been more than 3 months; who can take this, please? :)

Thanks
--
Gustavo

On Fri, Nov 20, 2020 at 12:31:13PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of just letting the code
> fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/mscc/ocelot_vcap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
> index d8c778ee6f1b..8f3ed81b9a08 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vcap.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
> @@ -761,6 +761,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
>  			vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
>  					   etype.value, etype.mask);
>  		}
> +		break;
>  	}
>  	default:
>  		break;
> -- 
> 2.27.0
> 
