Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6347B578530
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiGROTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiGROTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:19:49 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CDF11458;
        Mon, 18 Jul 2022 07:19:47 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id va17so21596259ejb.0;
        Mon, 18 Jul 2022 07:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fxt6hvNBrD+/s56t+eAs5/vG71j6lW/tRW6W4xaRhd0=;
        b=N0W0qi0uw3JEqD3ITRejN7zmNF9SvV7LgOZf6UbhTNpfyfnC4Ik0BqshTLWRjCvwba
         Lw38ar2xT3M5QQsMkJqaJHqB2NYeSHouf6/2mPLxaHi4CkuLxFmeALXVrRzWirK+5OW6
         cyFO4fG5LvlqiObS6Y0rVyq+QmlKP1zuJw+AbXgkjjMcV62f9xt/ZFw704SYGt6KIh1t
         Vvt1pbF3SQSUnKw2LzD5HPpEW4htX0g71qKk/qC8i29sywai/iCAakbRAoqWBArDJBOf
         5k1mLOZILWvdy5pHHo+AOHigl2VNY+F3CZpDwG6vtDOt73chzzSJG2MdFJOO3zhO3oO3
         Gyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fxt6hvNBrD+/s56t+eAs5/vG71j6lW/tRW6W4xaRhd0=;
        b=DLrStLtxKFmbnQFhvpHUtrTjNvSuZ2Ds3Nb6K2UBFinTf+UkD8mwxm/FW+mGmhjq5y
         Banef2cEqPAMs17+HFBghWYrfcrmdgXP9KRsOml3P2qZ35EWlFhkfcZSLBpXthYOFOF3
         0lV1bIXEHaN5LFDZJRyw6NvwjHOgDZ+8Ikq5kK1ol38VUbGZNaiMuzLSnsyiGkV8Lozq
         jKn8Y95n5TOEntZJUxAASUbk6h8FqUHG26xhpKq4YUts3TNM0IX2VvvuQ6o1gAXQPWPA
         lh+T/oR+Cs1NfEpm+Uq9AkvO+ZM3Krpcj0E7y7whktuuLcGFGLjsEZ2CvOX/xPaPW/Wh
         ss3Q==
X-Gm-Message-State: AJIora+8SC+JMq7W0ycZzXwgCPDDEvVcqezyLScB9XWefaOOG90IXYvh
        jdGIxYc64/PRAuY1F6MS1jye9VXOlRA=
X-Google-Smtp-Source: AGRyM1sgaMFr4an1GTT+bhZ6tzsNl71DKX2d1Im3q3EueSbjVmhs+HCyOxr0tr50xyWUt/qhvCXm3A==
X-Received: by 2002:a17:906:9b0a:b0:72b:4fc2:4b07 with SMTP id eo10-20020a1709069b0a00b0072b4fc24b07mr26656533ejc.700.1658153985840;
        Mon, 18 Jul 2022 07:19:45 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id r24-20020aa7da18000000b0043ad162b5e3sm8665686eds.18.2022.07.18.07.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 07:19:45 -0700 (PDT)
Subject: Re: [PATCH] net: ethernet/sfc: Fix comment typo
To:     Jason Wang <wangborong@cdjrlc.com>, edumazet@google.com
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220715045914.23629-1-wangborong@cdjrlc.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <d65c8772-ae46-f913-b3fe-f58d4f812b40@gmail.com>
Date:   Mon, 18 Jul 2022 15:19:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220715045914.23629-1-wangborong@cdjrlc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 15/07/2022 05:59, Jason Wang wrote:
> The double `that' is duplicated in line 2438, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/net/ethernet/sfc/falcon/falcon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/falcon.c b/drivers/net/ethernet/sfc/falcon/falcon.c
> index 3324a6219a09..9fcd28500939 100644
> --- a/drivers/net/ethernet/sfc/falcon/falcon.c
> +++ b/drivers/net/ethernet/sfc/falcon/falcon.c
> @@ -2435,7 +2435,7 @@ static void falcon_init_rx_cfg(struct ef4_nic *efx)
>  		 * supports scattering for user-mode queues, but will
>  		 * split DMA writes at intervals of RX_USR_BUF_SIZE
>  		 * (32-byte units) even for kernel-mode queues.  We
> -		 * set it to be so large that that never happens.
> +		 * set it to be so large that never happens.
>  		 */
>  		EF4_SET_OWORD_FIELD(reg, FRF_AA_RX_DESC_PUSH_EN, 0);
>  		EF4_SET_OWORD_FIELD(reg, FRF_AA_RX_USR_BUF_SIZE,
> 

Nack.  The first 'that' is a subordinating conjunction, the second is
 a demonstrative pronoun, so this is not a mere duplication.
(Admittedly, some writers would omit the conjunction, but I think the
 sentence reads more clearly with it present.)
One possible alternative would be to change the second 'that' to
 'this' or 'the above', or even 'such splitting', if you really find
 the original confusing.

-ed
