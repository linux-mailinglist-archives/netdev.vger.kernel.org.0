Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A741662582
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbjAIM1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjAIM1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:27:30 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152E61AD8D
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 04:27:29 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ss4so12370477ejb.11
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 04:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EE9Qcu3z7v0X1mDBiTnwrZNHkM5hhkyxidu/GsNr9gE=;
        b=HHzBk/XXxKPMa9zUSD9579QR5DxcZC3rzr3DEr5jBImYvCav0lC2uLSz2p4UIdM3yS
         QtU+YvqpEJh0REQKXF8u0yMRQlnoesXArX9PY+OSHfJBwoO6mB8ySHK4Rg5CeUXNYm5N
         ftqQInbPmtmn29BjImohXMZXrznjqFlLGaE/yx0ghEO7wIyEDYKj8JoVgma4mj3h766m
         lg7CeNfTzuS2Naa6AClN/tFCRUj68rJi9Mvb17A/eEaO3+JdOm77YQVlFM0aSOCvDh2L
         oNCjW3F+gKAxDsCpiVD3NjE1IURBzvdnMsJaLndwN0Pxn2ExWcO5vB5R5oPV/h4B7Qj7
         kQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EE9Qcu3z7v0X1mDBiTnwrZNHkM5hhkyxidu/GsNr9gE=;
        b=jP4dw87T2lQYr7WPR7zJ1czK+ljsAX2hsdgCI5R1w/0ln1odru0K3y6MxaxWpIKSVR
         ANLPugqLqR2ahlpjHOEPbjKmW4/3Fov9bW6WT2nJHXE04W9mIuTuhzga+NsnH51pfuxz
         RLL7n7L9z/WvVXE11AoOEX4zotm+4mSYMOGqJUUrD+MnD4+Z5jrLkMdrRryHiG4FvASk
         suvBCf6SY8AJmvdtsVYT805EmEQVyD40Bsfg3n32x/GkdrZ2K5asy9sKQajfDae8/ogH
         Izqtr7xC5/T7iOZh7Kzn63ylNMUMYDwL6RLgyU90co1gGxod2264us7UU6iXns5+7e34
         SsHA==
X-Gm-Message-State: AFqh2koSMGu2TCytNeRlvgQbxirSMNM7qGISQxcAZQ/YWhXuXvRHPT9+
        Zgnp6/GHrvQH/flrX4tgn2A=
X-Google-Smtp-Source: AMrXdXvvwhSuYxEZ/vXA8iDG4gVWSSLPZRUvc6Wv/irVmyVsFev+hVU81J5c0x5xAVDuboCskbw1jw==
X-Received: by 2002:a17:906:398f:b0:7fd:ec83:b8b9 with SMTP id h15-20020a170906398f00b007fdec83b8b9mr53095058eje.44.1673267247674;
        Mon, 09 Jan 2023 04:27:27 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id e21-20020aa7d7d5000000b0048ca2b6c370sm3662719eds.29.2023.01.09.04.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 04:27:27 -0800 (PST)
Message-ID: <558a8db8-ee66-b333-a065-0f4e83646232@gmail.com>
Date:   Mon, 9 Jan 2023 14:27:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 24/24] mlx5: Convert to netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-25-willy@infradead.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230105214631.3939268-25-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/01/2023 23:46, Matthew Wilcox (Oracle) wrote:
> Use the netmem APIs instead of the page_pool APIs.  Possibly we should
> add a netmem equivalent of skb_add_rx_frag(), but that can happen
> later.  Saves one call to compound_head() in the call to put_page()
> in mlx5e_page_release_dynamic() which saves 58 bytes of text.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  10 +-
>   .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   4 +-
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  24 ++--
>   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   2 +-
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 130 +++++++++---------
>   6 files changed, 94 insertions(+), 88 deletions(-)
> 

Thanks for your patch!
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Tariq
