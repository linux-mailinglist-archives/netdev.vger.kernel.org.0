Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F64340CE4
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhCRSYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbhCRSYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:24:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0431C06174A;
        Thu, 18 Mar 2021 11:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=O7KkIrzg13+cX11RMq6hNbBlBRj0x2eAQYuBMzGVLUw=; b=N7PpFtyVyJB3u0rD74a/99itaE
        D1HPRZdxxKHng2EI3Tgu8CBu7Gn5f3Tv60q4t3pkvz7Hs/tbBHeCTmgaNj9iZlmR09ScySHd0tuQC
        fFyfwfku0pn6XT7AXkUx8F9mrtsNRZRxnJjI/pnoS5lI77DVbr6w/yOXt8wHdAjC7axgtlda+kXhz
        WPhsMLlo6UZtxdA6IZjbrP/fLVzjz/ngHsdyDFOQQaNpTo61jdaKRWhCcG5LJRZNR6t83hpwyxfjA
        83EeGyyErelseCAtOBTs/qwnyFlioCYvN4VV+sofNiQxG1SG6TYnprxS9gtT++mpjI4cjPozPVhH3
        yHcPvD9w==;
Received: from [2601:1c0:6280:3f0::9757]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMxJc-003LTd-0D; Thu, 18 Mar 2021 18:24:14 +0000
Subject: Re: [PATCH] ethernet: sun: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, yuehaibing@huawei.com, gustavoars@kernel.org,
        christophe.jaillet@wanadoo.fr, vaibhavgupta40@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210318060223.6670-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <858d0b7f-db9c-05cd-2650-4eeb683f70a3@infradead.org>
Date:   Thu, 18 Mar 2021 11:24:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210318060223.6670-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 11:02 PM, Bhaskar Chowdhury wrote:
> 
> s/serisouly/seriously/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ethernet/sun/sungem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
> index 58f142ee78a3..b4ef6f095975 100644
> --- a/drivers/net/ethernet/sun/sungem.c
> +++ b/drivers/net/ethernet/sun/sungem.c
> @@ -1675,7 +1675,7 @@ static void gem_init_phy(struct gem *gp)
>  		int i;
> 
>  		/* Those delay sucks, the HW seem to love them though, I'll

		         delays suck; the HW seems to love them though. I'll


> -		 * serisouly consider breaking some locks here to be able
> +		 * seriously consider breaking some locks here to be able
>  		 * to schedule instead
>  		 */
>  		for (i = 0; i < 3; i++) {
> --


-- 
~Randy

