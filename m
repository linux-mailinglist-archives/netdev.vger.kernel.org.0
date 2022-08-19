Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CB0599CBA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349318AbiHSNMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349153AbiHSNMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:12:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488ED74E1F;
        Fri, 19 Aug 2022 06:12:38 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w138so1670266pfc.10;
        Fri, 19 Aug 2022 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=+HttuOcfh+F+H+y/J89AxcmFEcYFCA26kNV2tXQCUuw=;
        b=qW70MXd5DgmcAj2wWFFVkV72o/nHNC6AwzJv9JFJIL8u+AUbDtl5cUrT4fmFpOC4MM
         Gh2bl+79+4YBkFPoFJFWEzoH9bvGOkZGWS/0HPXWqzf/lQGb0xg2NQeedi5NVkp+7sgU
         MnAW9bhdz9RPq+FWYPdJ6FZrzFAhsZDHJlXZBs16mxwbkUL5xTDVfrgBNOPpiry66IVF
         vKyajl8PgQlqoEqzOhjEW4lEatM/rLGeR0ouszRmhyd0LN6xYjQA2GXb7QFhXSt9YHiZ
         COHFgVc9ylRiK452vHLhos5ZwxDny4wx+2ZOkraVCVRIDSWEI5crFnoSoLPGoCBfBVQE
         i1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=+HttuOcfh+F+H+y/J89AxcmFEcYFCA26kNV2tXQCUuw=;
        b=WZ0p3n6IAjkme1rJE0DOjxUOustYBWvLsv+s6VfpHPjIql7iTT24ejJ3mIR8VSzeH0
         QVl1XXyU0SVyUm7p+3mXJpY1fXCm5OxuPt91JPUZn9cyDxQWXjyfNtMAG0HgRobVO1TK
         QnhviJ32M0BiMrbXLI77AYSUwfZhKkpsPSgXDVUwqD7+YuHja3HZkzNrlX0MgzT8MBB9
         xcrdcg9p5yFyolmCAqvo9TVsQfnzUDxY7aES3uYIWEscoiwyP0BIljHlP6WYIBCGLjHT
         wRjqMKq2bjNpOj/9Lb/QkLM/hMWHoPV/asCmwKze3rk7gWEnJ6tW7/Acbdb0OfMNodjd
         7+RA==
X-Gm-Message-State: ACgBeo1nCmGno+ml4oDSDaf+J6EUBeEoJd0nqDnG2ZoVkGsKjovtYDK3
        JExjQ0jcM8stX9NP8uyB4hE=
X-Google-Smtp-Source: AA6agR5fk8/zWfwk5/fLk4VWIsYM4zx1HwDid0OHsYkMdPMacu01upPGMPH5s3T+iuO/vjxq2/quXA==
X-Received: by 2002:a05:6a00:23d1:b0:52f:39e9:9150 with SMTP id g17-20020a056a0023d100b0052f39e99150mr7981942pfc.16.1660914757655;
        Fri, 19 Aug 2022 06:12:37 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id v2-20020a626102000000b005361708275fsm1073566pfb.217.2022.08.19.06.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 06:12:36 -0700 (PDT)
Message-ID: <afbff5b7-1004-a445-9005-7391c91a275d@gmail.com>
Date:   Fri, 19 Aug 2022 22:12:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH -next] amt: remove unneccessary skb pointer check
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <20220818093114.2449179-1-yangyingliang@huawei.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220818093114.2449179-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,
Thanks for this work!

On 8/18/22 18:31, Yang Yingliang wrote:
> The skb pointer will be checked in kfree_skb(), so remove the outside check.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Taehee Yoo <ap420073@gmail.com>

> ---
>   drivers/net/amt.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index 9a247eb7679c..2d20be6ffb7e 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -2894,8 +2894,7 @@ static void amt_event_work(struct work_struct *work)
>   			amt_event_send_request(amt);
>   			break;
>   		default:
> -			if (skb)
> -				kfree_skb(skb);
> +			kfree_skb(skb);
>   			break;
>   		}
>   	}
> @@ -3033,8 +3032,7 @@ static int amt_dev_stop(struct net_device *dev)
>   	cancel_work_sync(&amt->event_wq);
>   	for (i = 0; i < AMT_MAX_EVENTS; i++) {
>   		skb = amt->events[i].skb;
> -		if (skb)
> -			kfree_skb(skb);
> +		kfree_skb(skb);
>   		amt->events[i].event = AMT_EVENT_NONE;
>   		amt->events[i].skb = NULL;
>   	}
