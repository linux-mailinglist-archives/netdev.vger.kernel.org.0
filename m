Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE5A5533F2
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345583AbiFUNrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiFUNrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:47:35 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313FE25291
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:47:34 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id c189so14292445iof.3
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xdWJmoRejUz+usfSLKb7xTPUz6NOCPSTvqf5z1FVOJ8=;
        b=u/kTnsf1La7YBmG43UjGEHCgCToSRc/Lc1X2KD921nzg+i32xzUUy9PIcl1Y7iUBog
         oD6QFdzlAtyHWEY9JEbgvORE02AsCEoGVypTvlcbjc16TKFM9XzkP8pPe7/P9YEXV5GE
         edAVDWB76/YYfOImIhTw1LgxKN8EFoWDv5xRJyjw4ioO7z5A4DRn5OP7cMnIUQKKtzf9
         ic/8qhjBloQphV1as0srTWKAGEZLX61tvhiBHLlHszr+Z6SJ1MMvn89uTZN+8w2jLSJb
         OhOBC96GVHxXxXheJUU1V1Q5f/IGGp6yFTSHhA18p4t2hMwyKZ6KyJmUWgK6jr2h9qvs
         YwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xdWJmoRejUz+usfSLKb7xTPUz6NOCPSTvqf5z1FVOJ8=;
        b=vNNTIiaZLfIRaB+ge32aDb9u4bxqON/xaSK8nXemg848qZzvX8XlUukAvSLWB6JNTf
         2RKbNh7PMVM1y8DB8d2zDvXZAvRRwpobIAgGNf5EGJUy9R/KPlrsRy0CAczDCbz6yAX9
         03fC819fhVyMDDl78vomKLaTSb4O3a2l6VoZPcp6herlitC/m+AI5olH4ZYZfqfwvxEn
         57wMHcQjfBwgK19QDssfdf2ncXxCvcZzuf6j9FvowXU+8Vu2yNEPNB9Q16CFFq4U7Z0A
         7/PVZH53B2cWPgQccvvKKJIjAADMxIra33cWqUf4PP/j1z1248R58Jj1hl0yvmJ7NRXN
         zZuQ==
X-Gm-Message-State: AJIora+Xoh6n24qbbfTrQ5T+Rb4xCknuJV/bqxgKiDHR2/Z5kw+4l5AT
        OsCjEdleSgm6nKUEiaIyARWydA==
X-Google-Smtp-Source: AGRyM1sbd72qqTReT8J49xfpU6Ltqk6Tv0BNo5NwR7vplQG1VOCUAf/C0JMNLiCLfB3X8nJ/RGtohA==
X-Received: by 2002:a05:6602:1696:b0:66a:d4d:e8c3 with SMTP id s22-20020a056602169600b0066a0d4de8c3mr14501356iow.48.1655819253333;
        Tue, 21 Jun 2022 06:47:33 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q1-20020a027b01000000b00334748f85easm7183302jac.106.2022.06.21.06.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 06:47:33 -0700 (PDT)
Message-ID: <1a81c73e-234d-0c7d-618a-a3bcf773f1b0@linaro.org>
Date:   Tue, 21 Jun 2022 08:47:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: ipa: remove unexpected word "the"
Content-Language: en-US
To:     Jiang Jian <jiangjian@cdjrlc.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220621085001.61320-1-jiangjian@cdjrlc.com>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220621085001.61320-1-jiangjian@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/22 3:50 AM, Jiang Jian wrote:
> there is an unexpected word "the" in the comments that need to be removed

In the future, maybe something more like "Remove duplicate 'the'
in two places."

But regardless, this looks fine to me.

Reviewed-by: Alex Elder <elder@linaro.org>

> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>   drivers/net/ipa/gsi_trans.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
> index cf646dc8e36a..29496ca15825 100644
> --- a/drivers/net/ipa/gsi_trans.c
> +++ b/drivers/net/ipa/gsi_trans.c
> @@ -339,7 +339,7 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
>   	if (!gsi_trans_tre_reserve(trans_info, tre_count))
>   		return NULL;
>   
> -	/* Allocate and initialize non-zero fields in the the transaction */
> +	/* Allocate and initialize non-zero fields in the transaction */
>   	trans = gsi_trans_pool_alloc(&trans_info->pool, 1);
>   	trans->gsi = gsi;
>   	trans->channel_id = channel_id;
> @@ -669,7 +669,7 @@ int gsi_trans_read_byte(struct gsi *gsi, u32 channel_id, dma_addr_t addr)
>   	if (!gsi_trans_tre_reserve(trans_info, 1))
>   		return -EBUSY;
>   
> -	/* Now fill the the reserved TRE and tell the hardware */
> +	/* Now fill the reserved TRE and tell the hardware */
>   
>   	dest_tre = gsi_ring_virt(tre_ring, tre_ring->index);
>   	gsi_trans_tre_fill(dest_tre, addr, 1, true, false, IPA_CMD_NONE);

