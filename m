Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15F4387B9E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 16:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240593AbhEROsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 10:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbhEROr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 10:47:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A15C061573
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 07:46:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t3so11514781edc.7
        for <netdev@vger.kernel.org>; Tue, 18 May 2021 07:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7hrky9LcnKu8wTawZiUgtVR6JmeIjl5ZkSMZKfqfylU=;
        b=gjCSlS74HjuiEPETP40AAVAJuYqhVGEuCImnSxTbcsX5y0j8IiCv7zRnEbATJGEXXy
         GlLPPtzQQJaoJ/xekKvklc0135dshcd8XZRfYlKGeWepHAPEoT736N30roQaGSBF/PDs
         pk40VMcQYz03iamb+spK4ips8aq2fWrzdNSpuw9404Ja1ev0Bpsspcxr1PexzEfqhFgM
         o+8nGIfHt5IKxofjWG5kG1GVinXk4xyeR/tB0L+CxDPMTAEwc+Vfohvry2B6L0q4PGIq
         oZ/0/U7YJzqvwO7TGDXYRDCKQ6C9pSBsDbohhWtlSwjQXZ+qQj1to+Njmyioh4ZkTET1
         qU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7hrky9LcnKu8wTawZiUgtVR6JmeIjl5ZkSMZKfqfylU=;
        b=fAXR98SDvwkttV2FXNqcYxdS7xYqLXSE2wPiK4/xk5QWoAM4DD+A8bdleQTpKeQnQ9
         k6pCc+RYe/eYsPNKcDdEo8bADEZqUTOXZp3qAT8ZaIslg7M3hBQRFfmRS5W9TV+1PglI
         IMg54h1eB6fkAnbraVEkwUAJFUy678lvrkX1dlEVQo4CIDzr8Jo+HQU71Wzi5PMc5tgi
         hg3Lmu1YBgIbN5XEisJ3QJQDCOELFA4cPb13VWaA2HMQYYzi7x6Q731BAym0X3mR0qHk
         rXoaANK2HSLNjSRBQlO3fNtO2jgmuFo3VdW8JRegRsCUyTd4BonpG3VLQJfwtsrGTnv+
         tX7Q==
X-Gm-Message-State: AOAM533ZtQ/hBPj2HUf8ITe0xo6c3Z98HpwB2w3cQo4w37pEKndWxorg
        mLPrnv+86HYvipUYsJ0ivK3GrG7ers8QscM8te+C3jRIBw==
X-Google-Smtp-Source: ABdhPJyNt22D1ivdX4JrrMTCu2N0WPAC1rCyLo59P4Fi4rH1TPrNv3MRzKSqQOS0Ie5060kZPrqbeyHEdd87yKh+oIM=
X-Received: by 2002:a05:6402:199:: with SMTP id r25mr7507180edv.128.1621349198925;
 Tue, 18 May 2021 07:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210518091141.2316684-1-zhengyejian1@huawei.com>
In-Reply-To: <20210518091141.2316684-1-zhengyejian1@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 18 May 2021 10:46:28 -0400
Message-ID: <CAHC9VhTuiHXGRmW3Rs=6k6PJagpq=rxX5E8nDW2puAZVzb4xbQ@mail.gmail.com>
Subject: Re: [PATCH net-next] cipso: correct comments of cipso_v4_cache_invalidate()
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     netdev@vger.kernel.org, zhangjinhao2@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 5:05 AM Zheng Yejian <zhengyejian1@huawei.com> wrote:
>
> Since cipso_v4_cache_invalidate() has no return value, so drop
> related descriptions in its comments.
>
> Fixes: 446fda4f2682 ("[NetLabel]: CIPSOv4 engine")
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  net/ipv4/cipso_ipv4.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Thanks for catching this.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> index bfaf327e9d12..d6e3a92841e3 100644
> --- a/net/ipv4/cipso_ipv4.c
> +++ b/net/ipv4/cipso_ipv4.c
> @@ -187,8 +187,7 @@ static int __init cipso_v4_cache_init(void)
>   * cipso_v4_cache_invalidate - Invalidates the current CIPSO cache
>   *
>   * Description:
> - * Invalidates and frees any entries in the CIPSO cache.  Returns zero on
> - * success and negative values on failure.
> + * Invalidates and frees any entries in the CIPSO cache.
>   *
>   */
>  void cipso_v4_cache_invalidate(void)
> --
> 2.17.1

-- 
paul moore
www.paul-moore.com
