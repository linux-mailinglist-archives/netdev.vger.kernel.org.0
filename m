Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E4333A9AA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 03:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCOCle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 22:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhCOClK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 22:41:10 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BA5C061574;
        Sun, 14 Mar 2021 19:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=rF5z7Q+U0V4ejfuGqUkuiEbAV/n5/ukND9oRxweN5dw=; b=O6z3bGxscsata/eNsYkWMtcK9A
        Z4h4fE1tp0W3wV2kHHrSNGsofccwPIfl4EMpCo01ejiRtLpy62eJI0qtz716sCt3cI1Vy20LGEYFk
        oFjy0gOW0E/V8F8uDXj927/LrLcMDo+OXgZ+Z1GFKlIoHz96hosUp3h9RyXzI/CffiZiGrA+cFhmV
        CDJklLV3pBKoBCpUSCWNurAL/mek/abYrYaY7chy4w6wK9c7jVaJjpNmxtfy5uNflCAhGXovhneMc
        nQsS38D7wcSSjHauwK7jS42qEtFxp9ceqRotevS4GwP/iPLlOuHYLaVHXqWyXn4p/UXgxyPIspjuW
        kMTDOCnQ==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lLd9x-001FSc-74; Mon, 15 Mar 2021 02:40:52 +0000
Subject: Re: [PATCH] net: ethernet: neterion: Fix a typo in the file s2io.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, jdmason@kudzu.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210315015322.1207647-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <53f6db88-d549-3275-d100-9e8cfe9e23ea@infradead.org>
Date:   Sun, 14 Mar 2021 19:40:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210315015322.1207647-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/21 6:53 PM, Bhaskar Chowdhury wrote:
> 
> s/structue/structure/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/ethernet/neterion/s2io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
> index 8f2f091bce89..9cfcd5500462 100644
> --- a/drivers/net/ethernet/neterion/s2io.c
> +++ b/drivers/net/ethernet/neterion/s2io.c
> @@ -6657,7 +6657,7 @@ static int s2io_change_mtu(struct net_device *dev, int new_mtu)
> 
>  /**
>   * s2io_set_link - Set the LInk status
> - * @work: work struct containing a pointer to device private structue
> + * @work: work struct containing a pointer to device private structure
>   * Description: Sets the link status for the adapter
>   */
> 
> --


-- 
~Randy

