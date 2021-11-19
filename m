Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA875456AA5
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhKSHLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhKSHLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 02:11:22 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A0AC06173E
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 23:08:21 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id y196so7539382wmc.3
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 23:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yMZ/XNTo6RdS+Y76BX8L/1avH0l3gqSxfoRyoU72ZXU=;
        b=TEZ76Ij2PibkzQa+i31y+/rQqy7gx//lmogS0896ix3RFSrlHmp54DLJJZre77q+Gi
         5d5A0Jd4Z/fTt7Yw2io0/9sZLVeLj5euM8F/6JY09hJzsLRzcAPO+y9tdce0rQGux8VC
         A9hhI13M/ALeDBf5Ht+uawSApu7UijOaB3k0Qa1/M+LYGJbCMCH/0QPCrWVvHsMwAcfE
         KYVz7wRzHGwgYvsnZKiAYDhs0vxwO3hiTfuKNqYQtG9hW1tVD2/HWrOrUa6jQ8J0/Ab/
         BlUPBnLVIC12Ky+6jfg61ZlZLrwdFkIZN4VC4X3AuQCcut2WvYEAUbhvPTVq3u62wHJ3
         wfBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yMZ/XNTo6RdS+Y76BX8L/1avH0l3gqSxfoRyoU72ZXU=;
        b=oUrTaJp0l43luZwRbzuqPOoFlf36iLYT6hn8k9OHEylWVESn5qv2cGU99NBVjaHVDA
         EvwBXUwxtfMdPRtmQS8aPJW+kZs3dk7giQtFihV7BdhiypMJ1EBa+/aTeqVQPZ5534ja
         hFm4df6/LfiMRpO4JGiP48uLrvcH4MgVK2mQrT1wELE29sfxT7Gp/HqTPJNwFXnGALTE
         RLNuaH7bP5I90hyKPA/K+CghZlHUN7Y+UzOyzJYT9DHcxpE89ouRd5JnuAWDSMHQh971
         TfUq9IDP+XmigfCqcA8n9ISM6aJCqUA3L/BDnXvv1UgCnoGA0j9liap3yjqI/kgbMA1K
         c4XQ==
X-Gm-Message-State: AOAM532LrLnys7RZmxYQ3/BdWXVx2s3ur4pLVsLIF/SMvjfeEtLJYuaK
        DAcJeRv25LOpK1Vx8i8Dp41i2g==
X-Google-Smtp-Source: ABdhPJym+3NtXcKichGqNPRGRokZ3hBAxiKdCB4mfrjpGZX7l+yh9GWHtzLOoUf0qXmErUS3af+gEA==
X-Received: by 2002:a05:600c:1d0e:: with SMTP id l14mr3966207wms.64.1637305700038;
        Thu, 18 Nov 2021 23:08:20 -0800 (PST)
Received: from apalos.home (ppp-94-66-220-79.home.otenet.gr. [94.66.220.79])
        by smtp.gmail.com with ESMTPSA id m2sm11074548wml.15.2021.11.18.23.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 23:08:19 -0800 (PST)
Date:   Fri, 19 Nov 2021 09:08:17 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Bernard Zhao <bernard@vivo.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/core: remove useless type conversion to bool
Message-ID: <YZdNYWfr89/9NcD0@apalos.home>
References: <20211119015421.108124-1-bernard@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211119015421.108124-1-bernard@vivo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 05:54:21PM -0800, Bernard Zhao wrote:
> (ret == 0) is bool value, the type conversion to true/false value
> is not needed.
> 
> Signed-off-by: Bernard Zhao <bernard@vivo.com>
> ---
>  net/core/page_pool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9b60e4301a44..d660d46f6ad6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -398,7 +398,7 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool, struct page *page)
>  	else
>  		ret = ptr_ring_produce_bh(&pool->ring, page);
>  
> -	return (ret == 0) ? true : false;
> +	return (ret == 0);
>  }
>  
>  /* Only allow direct recycling in special circumstances, into the
> -- 
> 2.33.1
> 
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
