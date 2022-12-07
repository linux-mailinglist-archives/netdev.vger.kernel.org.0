Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B796D64614A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 19:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiLGSxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 13:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLGSxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 13:53:17 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EAB2FFEA
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:53:16 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id m18so14627424eji.5
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 10:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UZIXeEI9PoJWyZL6FShBI3a9G7I8D+Xih96BTDFG4Jc=;
        b=RqcvdXoM0Nr+P/pW44pilnHftz5yRO2OyfSP7XwfoO93exPtnt1C6qSEgYpPOabDQg
         xeOdh0BnkybfzdZkJxRk6HWVu3v3erZJiPHbXmK8ShX54qu2ahUjrI/tEYi7ly61L61Z
         GNJZEs3lKeMpAPZFagxl5PeGm+0hXgE3FNfUPKw3ip1OET14myuNrmuAlX80O1Aa6voI
         Y8ueQqfVFOZ8QqzXh0NwsyDuSCj8vGvHan0BZ5hL7S1tPj/3CPxoTtGpuCg+zn3yeV8V
         HhCu9RlsOJP/w+K6CHb7XwUPwLFLa6HZ2Mg+TNN9PuQrF0a9ZhcYJ/8+SDo9TQjuGWA5
         s/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UZIXeEI9PoJWyZL6FShBI3a9G7I8D+Xih96BTDFG4Jc=;
        b=c41c+7Z3Aw0NQX3Fi2p3wHTIEWV8rPKlKqBezCxG3JbC4XKIpsSdu4VGSHEvg5KW31
         axPUDdFAdcfV5YHXKu7crEyq6JP8jsgNqOrAJqZbpZJqL8rgJxc3+j97xED5bqthxVms
         cd/BSkms/iSMmBf4WP0TcX61N5tnG4Gn+p5B+cY12XyiSNPncivQ4DUITeQcdVKPsm6A
         1E/5JOQAQsagW0h1+2pObgQYG0ZF64zScY0vv2hUyWGwmAq4aejb0Yx1oqOFKaKmgGQS
         lCowbvCvgIkekB7CohDIkceZ2tJ54nxqD9+KyxtMLa/m3guOblq6n92D7dT8nz//wjF0
         xjhA==
X-Gm-Message-State: ANoB5pmghG8kIPtquJKUyYM14GENXLyVvZQSGpq5EeUkhNVztg69mI3n
        rUTWcEUaVE+GYFpjJ+VF4hs=
X-Google-Smtp-Source: AA0mqf68GOVwH81E5OnZV3+8MLB+lp3QB7nRwEtBWwp/12cX/YMl6yS+2iyvMNCYKpf9ysZn+PLYYQ==
X-Received: by 2002:a17:906:3a14:b0:7ad:79c0:4662 with SMTP id z20-20020a1709063a1400b007ad79c04662mr78796840eje.400.1670439195152;
        Wed, 07 Dec 2022 10:53:15 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id cf5-20020a0564020b8500b0046b4e0fae75sm2546991edb.40.2022.12.07.10.53.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 10:53:14 -0800 (PST)
Message-ID: <956d9a63-d481-eb1c-7fec-176a497ad6d0@gmail.com>
Date:   Wed, 7 Dec 2022 20:53:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 net-next 1/3] net/mlx4: rename two constants
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
References: <20221207141237.2575012-1-edumazet@google.com>
 <20221207141237.2575012-2-edumazet@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221207141237.2575012-2-edumazet@google.com>
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
> MAX_DESC_SIZE is really the size of the bounce buffer used
> when reaching the right side of TX ring buffer.
> 
> MAX_DESC_TXBBS get a MLX4_ prefix.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 10 ++++++----
>   drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |  4 ++--
>   2 files changed, 8 insertions(+), 6 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your series!
