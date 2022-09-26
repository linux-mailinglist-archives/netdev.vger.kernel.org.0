Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C385E9DA5
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbiIZJaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbiIZJa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:30:27 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1824812AB2;
        Mon, 26 Sep 2022 02:29:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a41so8151939edf.4;
        Mon, 26 Sep 2022 02:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=RRTzEh4eX7QJuMr9PBYcSE6qe2YnKNQ4s+EeI3ZLOR8=;
        b=N2CdQZ5DidOd7rXorrAHwsU7REyGYjsVLRQw24k5i/zVnwxTVLXi79SokmwMPQ23dG
         ltHADiZ2Xdl1ZpGJHcq9sCz91HuEiXsn5cgUkN6cCcc0qhs3gJdO6JtWSNxOVKAm2maA
         RUP45w5trMH4BmzGD7P4bYWDoQ80fJ5gk/tTcqUWNZwxEVqilkjzRE/DXJj2o9eLrnMT
         Eibb/G/CFzTjUYyiTkzjs9+xpKaddZrQr2Ady4gPnOt6q/+8sfnBsKlTNnNA0nWB58c5
         OZTJtHQ5pIa7jnF722Q6qFBJveO3Wd9eH06jY4XW0T30bgmjP4abl+o8prFN+WFIDcbp
         QH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RRTzEh4eX7QJuMr9PBYcSE6qe2YnKNQ4s+EeI3ZLOR8=;
        b=TNPn9AYtmnngjVCdi87k1yFv6XJAA7gE4e+/fYSch7edyqffp+EnbWn3XHD1o+M85a
         fYtu8kC1g/SiVIqgEX788FPBKsDctBwY2OoP72sJH6CReKNHoSlMH7wbNXnSVvKIHm57
         E6TQ2wANT8JWxGQyVm9Z8Dr+NzczUByxK9nMJ/qnQhyHZDrUphrObp/km7ZQ+sTHIcod
         uTDUnxsnbcfQ7FvjrVZAehFenluMtjjyPPE+1tfQtFSAzmko60nhmY4htX9B58ZLw1i1
         hA2kqxIEnZmxePDoIwXVAO3lC+p25ncv1r4zVea8loWHMfKB2BVVGB7nid3xZTT1cczw
         3WTA==
X-Gm-Message-State: ACrzQf1w3KfGKXMtj93HKRC+GRO7asNNy5Vkd/Oe4WszXv1h/DgZfxpf
        GFgbuRKN+giNOt4A3pjD9vw=
X-Google-Smtp-Source: AMsMyM7SuVBgSYWy5kh1HhAcVXy6Llss6obNUjIA/ZoXJgkE8T8RGaoTb9VPoRu5QX3Pg6i6kN2O6A==
X-Received: by 2002:a05:6402:2489:b0:454:11de:7698 with SMTP id q9-20020a056402248900b0045411de7698mr21490387eda.214.1664184564514;
        Mon, 26 Sep 2022 02:29:24 -0700 (PDT)
Received: from [192.168.178.21] (p4fc20ebf.dip0.t-ipconnect.de. [79.194.14.191])
        by smtp.gmail.com with ESMTPSA id lh3-20020a170906f8c300b00782ee6b34f2sm3710039ejb.183.2022.09.26.02.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 02:29:24 -0700 (PDT)
Message-ID: <a07c4a5e-1668-3609-334c-8aee2834ff90@gmail.com>
Date:   Mon, 26 Sep 2022 11:29:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [Linaro-mm-sig] [PATCH v2 08/16] dma-buf: Proactively round up to
 kmalloc bucket size
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>, Vlastimil Babka <vbabka@suse.cz>
Cc:     Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Oj eda <ojeda@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-9-keescook@chromium.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <20220923202822.2667581-9-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 23.09.22 um 22:28 schrieb Kees Cook:
> Instead of discovering the kmalloc bucket size _after_ allocation, round
> up proactively so the allocation is explicitly made for the full size,
> allowing the compiler to correctly reason about the resulting size of
> the buffer through the existing __alloc_size() hint.
>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: "Christian König" <christian.koenig@amd.com>
> Cc: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/dma-buf/dma-resv.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
> index 205acb2c744d..5b0a4b8830ff 100644
> --- a/drivers/dma-buf/dma-resv.c
> +++ b/drivers/dma-buf/dma-resv.c
> @@ -98,12 +98,17 @@ static void dma_resv_list_set(struct dma_resv_list *list,
>   static struct dma_resv_list *dma_resv_list_alloc(unsigned int max_fences)
>   {
>   	struct dma_resv_list *list;
> +	size_t size;
>   
> -	list = kmalloc(struct_size(list, table, max_fences), GFP_KERNEL);
> +	/* Round up to the next kmalloc bucket size. */
> +	size = kmalloc_size_roundup(struct_size(list, table, max_fences));
> +
> +	list = kmalloc(size, GFP_KERNEL);
>   	if (!list)
>   		return NULL;
>   
> -	list->max_fences = (ksize(list) - offsetof(typeof(*list), table)) /
> +	/* Given the resulting bucket size, recalculated max_fences. */
> +	list->max_fences = (size - offsetof(typeof(*list), table)) /
>   		sizeof(*list->table);
>   
>   	return list;

