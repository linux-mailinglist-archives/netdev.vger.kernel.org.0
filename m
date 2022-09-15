Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067B95B9EA7
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiIOPWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiIOPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:21:47 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C772143633;
        Thu, 15 Sep 2022 08:18:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t7so31349666wrm.10;
        Thu, 15 Sep 2022 08:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date;
        bh=Ws/FvdgxS6QqVnLaYHYxhUMc/MoFSD9Yx4sONyAg3gk=;
        b=fbsyZ+8SZ0Q8iY+QZUwIN7WquJo3UTOPbFkrI2YjE5fbUeH8K2XArhax97vPZIKP3A
         pW/oCXUHitI5QnfjVpfeU1sAsZCFZMGCUCM6kshQKBwuUDUs9XjwSQ8LWphKSJZjJtiX
         TgPt2PGgIZnHs9Pbe/jStej0B0Q/KA9PGMggQLwWg3wQTTr+sZ6+HxHNry3VUUzSQwSR
         0JSDgtOpr8MEl8cxo51v4nkUPLt1CZW3powoafI48G1HGYmxpdgTqc+ewqcS4XQLVrUV
         YX/ax620OiPuM7po7hQq61jLKt5WF9WZWyrz95S3TRNx1oV+D1M9szqtWf3DK6aM5oWo
         U1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Ws/FvdgxS6QqVnLaYHYxhUMc/MoFSD9Yx4sONyAg3gk=;
        b=V1xaNlLAB6/K5x9nIB6/tTcm3HLfJGf7L9EZhh0DSzD+zt/wbxXzaYzC7sBPWj5LfW
         PW6K5Q+N+u5UbV4y41IjYlR12LbRDgv9pLJTF5TH9D4hlkqJFCD1jpva/hB6qUMb61FY
         ABsiNuYtg2dcMJ+45fBXHSDPMpUSy82q8ouleniKQgmtPhYzZEtuO0T0bnbOLpJNLOoa
         cSZDoXGb0s+SgQ2tfbKv8klktu4qNAh4m5+rUfX4q7oBmGLeJeNvMwZphKZ+iyUzO4T0
         JI19F+TzbuQzPhaRW8pfRvW5q8fsM4tNg2btSkMIw07Ns8AVHj9cYm4zwqYeYkha27Jd
         oXjw==
X-Gm-Message-State: ACrzQf1QC90jAGPKx2RNMJ92prFLuCvRXSd11R7pUW9SKYdaByw5u3Vb
        dSc8Gal9FTm0c/RP5pOt6QjW69PNR3w=
X-Google-Smtp-Source: AMsMyM64rbdTUv7JkuKifgXu1WKnzOewmvZ93U0Dlz6/ujDx/Rg8jA4rDhgYkUl11mIAOx2yeh7y2Q==
X-Received: by 2002:adf:e781:0:b0:228:b44c:d0f7 with SMTP id n1-20020adfe781000000b00228b44cd0f7mr92481wrm.243.1663255087151;
        Thu, 15 Sep 2022 08:18:07 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003b341a2cfadsm3548407wmq.17.2022.09.15.08.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Sep 2022 08:18:06 -0700 (PDT)
Subject: Re: [PATCH] sfc: fix repeated words in comments
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220915075411.33059-1-yuanjilin@cdjrlc.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <11efcaf5-a24f-3e38-945c-005187eba092@gmail.com>
Date:   Thu, 15 Sep 2022 16:18:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220915075411.33059-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2022 08:54, Jilin Yuan wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/sfc/bitfield.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/bitfield.h b/drivers/net/ethernet/sfc/bitfield.h
> index 1f981dfe4bdc..0b502d1c3c9e 100644
> --- a/drivers/net/ethernet/sfc/bitfield.h
> +++ b/drivers/net/ethernet/sfc/bitfield.h
> @@ -117,7 +117,7 @@ typedef union efx_oword {
>   *
>   *   ( element ) << 4
>   *
> - * The result will contain the relevant bits filled in in the range
> + * The result will contain the relevant bits filled in the range
>   * [0,high-low), with garbage in bits [high-low+1,...).
>   */
>  #define EFX_EXTRACT_NATIVE(native_element, min, max, low, high)		\
> 

NACK, per [1].
Please stop using whatever tool is finding these, or find someone who can
 filter out the false positives.

-ed

[1]: https://lore.kernel.org/netdev/30f2488d-9af3-fe8d-6e6f-713a7d38800b@gmail.com/
