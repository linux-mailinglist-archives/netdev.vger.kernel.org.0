Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FBC18D825
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 20:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCTTLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 15:11:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37033 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgCTTLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 15:11:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id h72so1558592pfe.4
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3u2jT42bvSt+2o2Zd9nowbPlEO5iIsz710bbKk63OAM=;
        b=upZd5qip82aPsDrbqYKGkRw6AqP17/vuJ7L+wOWOYJ3f/qsJCoPwm9rdXWbPuWpDUB
         rdj2S1bGd+N9E/XYNMzCFcnYlNRKDm7OBsZL6lBM8spK++2espudNJRpUi03WyBcRKZu
         A2qB4nRqVSy2u/IO+xURA/38Q2EbwVd0qlIVKfwse8kyv7jmDwTTWTjGJpmk7GhqqnnG
         FpJwF8gXzuPn4GuS1euzuCutUGDgzk0FxrlWA7KQfIY9xDbEODei0hC9GhkFWNsFN1wH
         Pxiqf+TnquG+sqKr2r1tc7++0Gf3JVIZxzW2Bu7b1BSKHa0MD+UIG/wR+J/nub4MrzsG
         bvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3u2jT42bvSt+2o2Zd9nowbPlEO5iIsz710bbKk63OAM=;
        b=YhSwejJFNFNVNMb7p6glcz2xj+LHw0ngnqvKO8EfHgAmyYjTb6U3M8O8e6aS2TDx8n
         DMVqq2wMFkxM8IEY7V5lGIgD4IwYCYaIVg0mB3yd66+ccLIOwm2wdCqW50ZSjXWD77Ru
         dz7kYWE1nkCieWSdD50ymJ08pgmjQ/e7LwIIDJ5MOCRtOgV5RlUVBk72cinWW/Z5bBqh
         94ynsgN30VIkblw4KTA0o8cfr/Mnwxrw9H5CuBG5kHMK0ZBsjs47A3PZhF84kVmBUBKE
         Xo/rqLfXmKU9P/FGWlaIeK4W8NBwxGue/eObG6bqlyyy2OElkRlHhTxrSQxTZFMo/I8Y
         P2ww==
X-Gm-Message-State: ANhLgQ1ynZAKbwQ8JrVTO50yMVQtO+KR0JQFOcwNpH7fDh5I7kFHiKw0
        NFPV+nffp32FkQbZoJAsuDiElT3eLVY=
X-Google-Smtp-Source: ADFU+vt2jvJ0PqqLCjWwKM5qOg2owfJdmFyMARh0jt/G1rgPCkBRjTe7UlG5y54KFvXhPGtAguzO4g==
X-Received: by 2002:a63:103:: with SMTP id 3mr7345137pgb.193.1584731470315;
        Fri, 20 Mar 2020 12:11:10 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id x75sm6428543pfc.161.2020.03.20.12.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 12:11:09 -0700 (PDT)
Date:   Fri, 20 Mar 2020 12:11:07 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: ipa: kill IPA_RX_BUFFER_ORDER
Message-ID: <20200320191107.GA119913@minitux>
References: <20200320160220.21425-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320160220.21425-1-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 20 Mar 09:02 PDT 2020, Alex Elder wrote:

> Don't assume the receive buffer size is a power-of-2 number of pages.
> Instead, define the receive buffer size independently, and then
> compute the page order from that size when needed.
> 
> This fixes a build problem that arises when the ARM64_PAGE_SHIFT
> config option is set to have a page size greater than 4KB.  The
> problem was identified by Linux Kernel Functional Testing.
> 
> The IPA code basically assumed the page size to be 4KB.  A larger page
> size caused the receive buffer size to become correspondingly larger
> (32KB or 128KB for ARM64_16K_PAGES and ARM64_64K_PAGES, respectively).
> The receive buffer size is used to compute an "aggregation byte limit"
> value that gets programmed into the hardware, and the large page sizes
> caused that limit value to be too big to fit in a 5 bit field.  This
> triggered a BUILD_BUG_ON() call in ipa_endpoint_validate_build().
> 
> This fix causes a lot of receive buffer memory to be wasted if
> system is configured for page size greater than 4KB.  But such a
> misguided configuration will now build successfully.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Alex Elder <elder@linaro.org>

Seems better than relying on PAGE_SIZE.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
> 
> Dave, I *hope* this is it for IPA for this release.	-Alex
> 
>  drivers/net/ipa/ipa_endpoint.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 217cbf337ad7..6de03be28784 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -26,8 +26,8 @@
>  
>  #define IPA_REPLENISH_BATCH	16
>  
> -#define IPA_RX_BUFFER_SIZE	(PAGE_SIZE << IPA_RX_BUFFER_ORDER)
> -#define IPA_RX_BUFFER_ORDER	1	/* 8KB endpoint RX buffers (2 pages) */
> +/* RX buffer is 1 page (or a power-of-2 contiguous pages) */
> +#define IPA_RX_BUFFER_SIZE	8192	/* PAGE_SIZE > 4096 wastes a LOT */
>  
>  /* The amount of RX buffer space consumed by standard skb overhead */
>  #define IPA_RX_BUFFER_OVERHEAD	(PAGE_SIZE - SKB_MAX_ORDER(NET_SKB_PAD, 0))
> @@ -758,7 +758,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
>  	u32 len;
>  	int ret;
>  
> -	page = dev_alloc_pages(IPA_RX_BUFFER_ORDER);
> +	page = dev_alloc_pages(get_order(IPA_RX_BUFFER_SIZE));
>  	if (!page)
>  		return -ENOMEM;
>  
> @@ -787,7 +787,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
>  err_trans_free:
>  	gsi_trans_free(trans);
>  err_free_pages:
> -	__free_pages(page, IPA_RX_BUFFER_ORDER);
> +	__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
>  
>  	return -ENOMEM;
>  }
> @@ -1073,7 +1073,7 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
>  		struct page *page = trans->data;
>  
>  		if (page)
> -			__free_pages(page, IPA_RX_BUFFER_ORDER);
> +			__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
>  	}
>  }
>  
> -- 
> 2.20.1
> 
