Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC1A373666
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhEEIjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:39:48 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:40504 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhEEIjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:39:47 -0400
Received: from [192.168.0.20] (cpc89244-aztw30-2-0-cust3082.18-1.cable.virginm.net [86.31.172.11])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C9ECC2CF;
        Wed,  5 May 2021 10:38:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1620203929;
        bh=QdqoNvph4DT3PiPWxxcQ72QkJnI2p554Kaxscdfp82U=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bbUUuwfLhb1szjyCIUvFrBFEhlODc5k1bWnH2TVW94jpf0mwsDMV7rXVF4wGJfn1S
         /okzETMj9agF17aPlIIGk/IpfBXHaHGBj5He3hfsJBZQMpPZjnpaB0yun2OU66MZWg
         urOqPldpCQZXlBSgNzlqjGUWZmC6kM7IYpGLqxdE=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 1/3] Fix spelling error from "eleminate" to "eliminate"
To:     Sean Gloumeau <sajgloumeau@gmail.com>,
        Jiri Kosina <trivial@kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Gloumeau <sajgloumeau@protonmail.com>
References: <cover.1620185393.git.sajgloumeau@gmail.com>
 <21caf628a8aeec21ea9d3f06c95f712a7e7ce7fa.1620185393.git.sajgloumeau@gmail.com>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <3fc4016e-53a9-fd30-3073-5b8955f49be9@ideasonboard.com>
Date:   Wed, 5 May 2021 09:38:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <21caf628a8aeec21ea9d3f06c95f712a7e7ce7fa.1620185393.git.sajgloumeau@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

Thank you for the patch,

On 05/05/2021 05:15, Sean Gloumeau wrote:
> Spelling error "eleminate" amended to "eliminate".

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> Signed-off-by: Sean Gloumeau <sajgloumeau@gmail.com>
> ---
>  drivers/net/ethernet/brocade/bna/bnad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
> index 7e4e831d720f..ba47777d9cff 100644
> --- a/drivers/net/ethernet/brocade/bna/bnad.c
> +++ b/drivers/net/ethernet/brocade/bna/bnad.c
> @@ -1764,7 +1764,7 @@ bnad_dim_timeout(struct timer_list *t)
>  		}
>  	}
>  
> -	/* Check for BNAD_CF_DIM_ENABLED, does not eleminate a race */
> +	/* Check for BNAD_CF_DIM_ENABLED, does not eliminate a race */
>  	if (test_bit(BNAD_RF_DIM_TIMER_RUNNING, &bnad->run_flags))
>  		mod_timer(&bnad->dim_timer,
>  			  jiffies + msecs_to_jiffies(BNAD_DIM_TIMER_FREQ));>

