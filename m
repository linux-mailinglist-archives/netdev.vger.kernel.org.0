Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED931A1B6
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhBLPcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhBLPcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:32:24 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6A1C061574;
        Fri, 12 Feb 2021 07:31:44 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id m2so6488435pgq.5;
        Fri, 12 Feb 2021 07:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ltSglfZMY17lX+uRkeTIPeqR41cYRoHJOPQRHZ7b8SA=;
        b=f7vfbs7+M/3t3iQGo58QVprRfZXx5BQk3Sij+dtxwkA2B4d8TshrJcy4IDYuqUrQ3X
         jbPFLR+JPae+rfpK7FKI+U04zlmU3OpqB0YA2XRvkQb0XHQgfzkIyvVfpcqiipqwMXbM
         4QybCTMDE0NThS6gvVYsw2906IV1takbFt1Z/ffCEHLc7DbATmTc6m1POkLiEwlENW1T
         fPxKDkNaU8W9btzFhn3XTcHb0kw1JAQHNUHnedOmIme/Kc5JQY7lqTlNGJmhpSGKH9EO
         hKJnISvH0Klyg2av5nnRYRF/D5cfQVAUq9NRQOz9wjT0hMXB2CO/Ya03utLzoj4yu8B9
         QMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ltSglfZMY17lX+uRkeTIPeqR41cYRoHJOPQRHZ7b8SA=;
        b=RCTMj+g7RLihwU9SxxELvCCukHpO6UW6LMi3S3g3apUn4/Xy20Yeg/C3A+fxAsEp4A
         4pPNlRSZoZ1MIpuHixqgHzR+fmkmwLpvHJwjNajdR2d+O6bBpYbwSsjGrJ+eYirq2unT
         pAEmQ4hjvHbR9Mux9t6EaIBjOryMKNnz4bg8lE8wSW0mIeL/n2EHjx4rE7nLUu/NBt6K
         jZOjMbZxg9ovS299IGxWXqHYMVSc20j9s5LSGRZzPt/XBbpG3c/ak9RntVFas620E483
         oToRCVEzzxgM5G+H5x5c6l/SLpn70DKFbNEIXH4BIc4Ydn4SCBBur+VI/1aufqofSlXF
         ZnGg==
X-Gm-Message-State: AOAM531uA1wf0byP+ShZLItCBr6DoYqqPbpXCKYNawNC9ebJNvp1C3wZ
        vlGfqoV1FqCnhOQJmmQh0+KGEA38CvY=
X-Google-Smtp-Source: ABdhPJwkkaW9PbSeEz8asnJ9d3ynvxVnat3zvpZ+Ee6/2K15NFPd0FxLedtoM9ifRBF+cDoN34qmiA==
X-Received: by 2002:a65:60d1:: with SMTP id r17mr3772915pgv.210.1613143903488;
        Fri, 12 Feb 2021 07:31:43 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w1sm8308238pjq.38.2021.02.12.07.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:31:42 -0800 (PST)
Date:   Fri, 12 Feb 2021 07:31:40 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     vincent.cheng.xh@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] ptp: ptp_clockmatrix: Add
 wait_for_sys_apll_dpll_lock.
Message-ID: <20210212153140.GB23246@hoboy.vegasvil.org>
References: <1613104725-22056-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1613104725-22056-2-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613104725-22056-2-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:38:44PM -0500, vincent.cheng.xh@renesas.com wrote:

> +static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
> +{
> +	char *fmt = "%d ms SYS lock timeout: APLL Loss Lock %d  DPLL state %d";

Probably you want: const char *fmt

> diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
> index 645de2c..fb32327 100644
> --- a/drivers/ptp/ptp_clockmatrix.h
> +++ b/drivers/ptp/ptp_clockmatrix.h
> @@ -15,7 +15,6 @@
>  #define FW_FILENAME	"idtcm.bin"
>  #define MAX_TOD		(4)
>  #define MAX_PLL		(8)
> -#define MAX_OUTPUT	(12)

...

> @@ -123,7 +137,6 @@ struct idtcm_channel {
>  	enum pll_mode		pll_mode;
>  	u8			pll;
>  	u16			output_mask;
> -	u8			output_phase_adj[MAX_OUTPUT][4];
>  };

Looks like this removal is unrelated to the patch subject, and so it
deserves its own small patch.

Acked-by: Richard Cochran <richardcochran@gmail.com>
