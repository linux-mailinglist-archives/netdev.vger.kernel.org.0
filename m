Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2866D64614C
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 19:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiLGSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 13:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiLGSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 13:54:14 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D88A49B42
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:54:13 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id x22so16132801ejs.11
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 10:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gmYqWTuzJ4TgCTE1makdIO/bNGhz5+x3COs28RrPCmA=;
        b=gyau48thzarsATNZhpMPb3r4Oyg/miozPhULj/7gQpcXmxNr62ZKw9kDs4wivqgdRU
         rPqyCSXK9sw5EO+bVj3RcF9wQ/eKS5IYoyD/i6KKgofWobY0K2EZdfgY1k7F2HG4CaAx
         +L+6miz7fGQ+ibO6VGuEkJ3dVCZ0a/sByafmQA/b69IgAPVy8oouzDoBUvt7EThzrTBx
         Cu+5ZDKra6Sgvu2VOTS6Z8+PACie8I0C+auFSDmUvH1yALzzomtLOBMq8UhIbKF3u1fz
         OzmJlgiAmEF5kmv2+sAjBObdgbnzkAErQNVwoDyzSks0Zz57COrl09EL3ybbpxaf65fe
         y0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gmYqWTuzJ4TgCTE1makdIO/bNGhz5+x3COs28RrPCmA=;
        b=eBoM9RLjeRbbEQ5eN6q4OS4ng/kgKpnlEu0dJ6sewos3pTmtZOYBFq/zCJUYmxWVf+
         3bFRy42fPILMmjrBg0pyYAKXfc78/YAjnaTnlgcMYSMlK5XTr3CPjCHRreAEpkK3OyD6
         vsh/joVX0OKNyN8Mtep1osYqsDXkX0l3tn55aY3yXSTTW/7n8fP4KGy70u7oabtG01nD
         0ICKo/XTJdD3uPJXGSz+HNQ22S5rLWYrUYKinEAcbkOq9gKbA3mftGKJN6BmSxBbSnpj
         Phe4YBPwP/dURhuBatUL3InszrjXMIWIPiUK4DNJcAhPW5+LacwApdVL99ROWU9aHw5S
         Z/pg==
X-Gm-Message-State: ANoB5pluQ6N+QwU6HmH3tVkq2TWpobmvPXzNEcE3rfiSgw1zzL7N92jt
        OR5iQH3qiftG2lfPMz55tsg=
X-Google-Smtp-Source: AA0mqf4byV5xJZux/9JtE8//IET1LwD8u65+OVSFp1HfnGOWdoDmQ0tvQMPR921Px+VQBU0whNkMwQ==
X-Received: by 2002:a17:906:73d2:b0:7c0:e80d:7657 with SMTP id n18-20020a17090673d200b007c0e80d7657mr13532719ejl.323.1670439252079;
        Wed, 07 Dec 2022 10:54:12 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id x14-20020aa7cd8e000000b0046b00a9eeb5sm2530105edv.49.2022.12.07.10.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 10:54:11 -0800 (PST)
Message-ID: <42df8568-0aa9-6e38-cee8-fc9bf1793b96@gmail.com>
Date:   Wed, 7 Dec 2022 20:54:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 net-next 3/3] net/mlx4: small optimization in
 mlx4_en_xmit()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Wei Wang <weiwan@google.com>
References: <20221207141237.2575012-1-edumazet@google.com>
 <20221207141237.2575012-4-edumazet@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221207141237.2575012-4-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/7/2022 4:12 PM, Eric Dumazet wrote:
> Test against MLX4_MAX_DESC_TXBBS only matters if the TX
> bounce buffer is going to be used.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: Wei Wang <weiwan@google.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

