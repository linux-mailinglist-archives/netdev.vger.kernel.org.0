Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C344FBEF7
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiDKOY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238927AbiDKOYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:24:24 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4207836B72
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:22:10 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id k36so6086038ybj.11
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SekmTFeaADg/aoeb/xxyCnNcfGBZuVUsAJy39hCiHeY=;
        b=eLqhEfstZhVetKlPsYu3zb4H4zj9cnyuOLHnbjQXyAMu7MCYDQrNI/YKwVBKY0WyzT
         Z+StNtbPk7/ZqvWogR0mTIXc/J/1emLGG0na9j8YO/CUwNvB9OTz9u25aehr0ZWFJ6xG
         Yvs+JW3oObsbF/fXh/PQ3v9Mq1yXKs99j/d2P8db3NAraSrcfB1sV5pE7j25YCEqmYNm
         bbHUnWnyXey3cwYUSRj5S0EdHzhZK8+NBjytApP2nYJWin+tv3pdla1caqp+peFdVjGJ
         b8IBCJTbxDCohHZwcGKEWBJK7UGnSfM3co4O5X1q1dAy+gv73W+5e75yw5+asuS5iNtT
         hn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SekmTFeaADg/aoeb/xxyCnNcfGBZuVUsAJy39hCiHeY=;
        b=bmqofGv6hTr7uxJzQLlCg0v2rjQom8M29ze0z7ALNZjGn8JlAMWet0uddO7pRt8TxB
         xRHwi25ao1cnNg2P7YdCOVJi3Yl2Ti9yFSusVcsMBoPYBpuErQ7udXlYMcjxr/k3F5rq
         M8HCev0KDq9ZdCeWrQy9fc4TB6PlViz2FjC09BnjA5uWLoXeR/z/EMkcQzVR1hOqkssc
         CPP0I5fRe9owBCEL55qb4qmBB3dT6r5sfOyWOF2Of+gLCD7kW65iF3OK9anfEZuuXePp
         83RagH0KZywY1W/UxVoEZCLuAq+e8NUYvcF6c7HhYD+J6C8At9r1sdqSjKNhIRnRodti
         tVpQ==
X-Gm-Message-State: AOAM532rcrApS00VrZUefSONSC8n9cklbDFAYIr1stKVqA5LSmyISTG4
        lbdrSkIPvKQsWNnpqiu6ASmWVNF8UFTLRz2VZkZ5Jg==
X-Google-Smtp-Source: ABdhPJxWkZGMx+D3WkMVneoQTjDeaf01WCByyajoLf8yGxU5tafPZ30aE19EzmS/r6bI3scVxHVhtPH7prPV21pOPDQ=
X-Received: by 2002:a25:544:0:b0:641:17ff:396d with SMTP id
 65-20020a250544000000b0064117ff396dmr9510787ybf.248.1649686929329; Mon, 11
 Apr 2022 07:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <3712178b51c007cfaed910ea80e68f00c916b1fa.1649685634.git.lorenzo@kernel.org>
In-Reply-To: <3712178b51c007cfaed910ea80e68f00c916b1fa.1649685634.git.lorenzo@kernel.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 11 Apr 2022 17:21:33 +0300
Message-ID: <CAC_iWjJZYBR2OAUJuqrUU+UxX3G17OLZ6sgchOhfaWgB=reGTw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] page_pool: Add recycle stats to page_pool_put_page_bulk
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jbrouer@redhat.com, jdamato@fastly.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 at 17:05, Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Add missing recycle stats to page_pool_put_page_bulk routine.
>
> Reviewed-by: Joe Damato <jdamato@fastly.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rebase on net-next
> ---
>  net/core/page_pool.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1943c0f0307d..4af55d28ffa3 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -36,6 +36,12 @@
>                 this_cpu_inc(s->__stat);                                                \
>         } while (0)
>
> +#define recycle_stat_add(pool, __stat, val)                                            \
> +       do {                                                                            \
> +               struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;       \
> +               this_cpu_add(s->__stat, val);                                           \
> +       } while (0)
> +
>  bool page_pool_get_stats(struct page_pool *pool,
>                          struct page_pool_stats *stats)
>  {
> @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
>  #else
>  #define alloc_stat_inc(pool, __stat)
>  #define recycle_stat_inc(pool, __stat)
> +#define recycle_stat_add(pool, __stat, val)
>  #endif
>
>  static int page_pool_init(struct page_pool *pool,
> @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
>         /* Bulk producer into ptr_ring page_pool cache */
>         page_pool_ring_lock(pool);
>         for (i = 0; i < bulk_len; i++) {
> -               if (__ptr_ring_produce(&pool->ring, data[i]))
> -                       break; /* ring full */
> +               if (__ptr_ring_produce(&pool->ring, data[i])) {
> +                       /* ring full */
> +                       recycle_stat_inc(pool, ring_full);
> +                       break;
> +               }
>         }
> +       recycle_stat_add(pool, ring, i);
>         page_pool_ring_unlock(pool);
>
>         /* Hopefully all pages was return into ptr_ring */
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
