Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5C656BDEF
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238805AbiGHP1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238412AbiGHP1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:27:04 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5E372EE6
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 08:27:03 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h200so771893iof.9
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 08:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F1gk+Prfsqp7B5fRbU+ZlaqTg/Oc9XMgn05ZNfxHc6k=;
        b=TMFub2RhO98hm6yRFI1f2+XY4MvsygPgJ8Qah6PZm+159gDohno9a5hQ/16fByVKu6
         H2Pp2pIdeNvVgDcnmOqHmultuW4/gxJwNXyMm4q1FTGlcaSD5llw4aENDd913VMEXcEx
         WDwyilt3HyegG3eg8luWkkUVXx2Vo9Jp0yEgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F1gk+Prfsqp7B5fRbU+ZlaqTg/Oc9XMgn05ZNfxHc6k=;
        b=E105BcVsW0hn5J+JZL7UMKWdaw7HbCTVIKTwYZhMC1D36Lp+KH934vEllSNkpzGV0L
         7JHY1jNHxuJPULYAA13WP3gPuHgPox08LEPJ6vlL9P+OtGqFw5CYPTpFxAtVwjUgUsvY
         TYZIRxUPgCkQciHUlXmDBDb78O6K7ooaInwCpGWiSEXVcttAER+RGRKB8vAp8gAjO6c4
         rjWwu9fR/8hHPDrBNSlaX6OI/6p+BnFrnUZ7NYiwjBos5TaccufqGirO4BQyIg1oNP+9
         d1vTu5UMw3RIXwOWNe0nf1KI+JIUI01UhyttvJSmZa6dE1mHwtutxhfiR82DOpYOTMvd
         XVXA==
X-Gm-Message-State: AJIora/5ZJW6kl9hjjdGx26tjjwtygCF4v1Sq3Ah1dw33dkMd85gcxas
        RV5d5lcxIiszf9DLoMwsLRBFHw==
X-Google-Smtp-Source: AGRyM1unHcvN2OIn63qXDsRgczQII0J2vwif+D4LuJuDzcAiJGJF9UIOU06GfuUBYGO1BLKhMmGWlg==
X-Received: by 2002:a05:6638:14d1:b0:339:e8ea:a7c4 with SMTP id l17-20020a05663814d100b00339e8eaa7c4mr2531570jak.309.1657294023215;
        Fri, 08 Jul 2022 08:27:03 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id ay3-20020a056638410300b00331a3909e46sm7554532jab.68.2022.07.08.08.27.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 08:27:02 -0700 (PDT)
Message-ID: <44529968-c679-198c-0eb3-c62316681dff@ieee.org>
Date:   Fri, 8 Jul 2022 10:27:01 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net/ipa: fix repeated words in comments
Content-Language: en-US
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220708152038.55840-1-yuanjilin@cdjrlc.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20220708152038.55840-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/22 10:20 AM, Jilin Yuan wrote:
>   Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

These are trivial changes.  Please do them all in a single commit.

					-Alex

> ---
>   drivers/net/ipa/gsi_private.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
> index ea333a244cf5..d7065e23c92e 100644
> --- a/drivers/net/ipa/gsi_private.h
> +++ b/drivers/net/ipa/gsi_private.h
> @@ -108,7 +108,7 @@ void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
>    * gsi_channel_tx_queued() - Report the number of bytes queued to hardware
>    * @channel:	Channel whose bytes have been queued
>    *
> - * This arranges for the the number of transactions and bytes for
> + * This arranges for the number of transactions and bytes for
>    * transfer that have been queued to hardware to be reported.  It
>    * passes this information up the network stack so it can be used to
>    * throttle transmissions.

