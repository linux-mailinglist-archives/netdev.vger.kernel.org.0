Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9831596BF9
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiHQJUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbiHQJUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:20:24 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF1B1836F;
        Wed, 17 Aug 2022 02:20:23 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v7-20020a1cac07000000b003a6062a4f81so691731wme.1;
        Wed, 17 Aug 2022 02:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=7ikS/qYVcv7wXWd3CVl9CZRmAH6FRtV4e+F1Li60Jxc=;
        b=e9PYfA+7XIjfCnelW8fRFC+mer4w5uHsuXU7z0/pgXLd1vzzoV37G3pyMEgEv+cvq5
         mUQUpQXkKN60DAmTB0lrjHz/m59ttO+V2km1sWQvsZ9HvWcIu11UV2dH+6iyJEfgE4BF
         k3dnxAPJQkP7SKW8m7+kb+MPPlxCPWpqBE+O3XUVz9RFXCMHrlzxo7LTfm2knERxT8HV
         oEmoxnIxMSN/SPiVkEYGCVJwK4H0CldAnBztSpJOyR+9ro3gTgGmvv2LtQrqzJoRlW6v
         R5Ev3MyUsJ3RGKw3cX8PdaI8AQuo0VqYnFmfNrIJ8VvaAfPfQZOGbSrBaZNKWvzgs7PX
         3a6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=7ikS/qYVcv7wXWd3CVl9CZRmAH6FRtV4e+F1Li60Jxc=;
        b=Q5SZrvOZyuhSTDESeG2QGz3hYYu+sk3DuYC2aLmVUYN4ESanIdVCgOaDddJoGow7EW
         ICnCkM/oaKnZGiw5Bn7UqePMX3eUOo5cZb42nl165hqevUJ0W9Nq5m/UcV83uAqrg47R
         SjvrAJRk3sACDE5UdVp+x5PRqcTmAGoQPQZqnv5wogL5LuaJ9NaPeIdE2WbkpzcHC3fu
         bQzf8M0NRtcv/hn5n5WhvHhfS5AO4r1yMIy2Ol+W+28zAbVpwOJ1BRiwjsIIXoHHeCJB
         RQ5bmnj9vjK8zK0ycUKSmh4LAKygqusPhOwTLkNALfS4XSeEkJ0UayMle0pxXgyaLwrt
         43kA==
X-Gm-Message-State: ACgBeo2vypfaOEZU6bDvsFLLzR7V0AZak1+yclyPS+lcYgi3TvvP4GT5
        F55Y4rpuoiRLzkSTbkTD+o8=
X-Google-Smtp-Source: AA6agR7Lw1MBw+tJgYgdwzK5mbonY6/4UQ65Z9vB+nkIiXI5Yp06WH/hWfsCS6IdnqH+aleMOKyzjw==
X-Received: by 2002:a1c:4c0d:0:b0:3a5:a401:a1ed with SMTP id z13-20020a1c4c0d000000b003a5a401a1edmr1439272wmf.15.1660728021982;
        Wed, 17 Aug 2022 02:20:21 -0700 (PDT)
Received: from [44.168.19.21] (lfbn-idf1-1-596-24.w86-242.abo.wanadoo.fr. [86.242.59.24])
        by smtp.gmail.com with ESMTPSA id p27-20020a05600c1d9b00b003a35ec4bf4fsm1600645wms.20.2022.08.17.02.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Aug 2022 02:20:21 -0700 (PDT)
Message-ID: <23ba9201-f2e0-ae32-62fc-1b34c356e690@gmail.com>
Date:   Wed, 17 Aug 2022 11:20:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] rose: check NULL rose_loopback_neigh->loopback
Content-Language: en-US
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        "Bernard f6bvp@free" <f6bvp@free.fr>
References: <20220816185140.9129-1-bernard.f6bvp@gmail.com>
 <YvwSxBhoMl0ueJ3z@electric-eye.fr.zoreil.com>
From:   Bernard Pidoux <bernard.f6bvp@gmail.com>
In-Reply-To: <YvwSxBhoMl0ueJ3z@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I absolutely agree with all your remarks, suggestions and nice 
improvement to my patch.

As I am definitively an amateur and not familiar with git send-email, 
may I ask you to resubmit the modified patch for me including:

Suggested-by Francois Romieu <romieu@fr.zoreil.com>

Thanks a lot.

Bernard

Le 16/08/2022 à 23:57, Francois Romieu a écrit :
> bernard.f6bvp@gmail.com <bernard.f6bvp@gmail.com> :
>> From: Bernard <bernard.f6bvp@gmail.com>
>>
>> Since kernel 5.4.83 rose network connections were no more possible.
>> Last good rose module was with kernel 5.4.79.
>>
>> Francois Romieu <romieu@fr.zoreil.com> pointed the scope of changes to
>> the attached commit (3b3fd068c56e3fbea30090859216a368398e39bf
>> in mainline, 7f0ddd41e2899349461b578bec18e8bd492e1765 in stable).
> 
> The attachment did not follow the references from the original mail. :o/
> 
> The paragraph above may be summarized as:
> 
> Fixes: 3b3fd068c56e ("rose: Fix Null pointer dereference in rose_send_frame()")
> 
> ("Suggested-by" would be utter gourmandise)
> 
> [...]
>> IMHO this patch should be propagated back to LTS 5.4 kernel.
> 
> 3b3fd068c56e is itself tagged as 'Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")',
> i.e. 'problem exists since git epoch back in 2005'. Stable people will
> probably apply your fix wherever 3b3fd068c56e has been applied or backported,
> namely anything post v5.10, stable v5.4, stable v4.19 and stable v4.14.
> 
>> Signed-off-by: Bernard Pidoux <f6bvp@free.fr>
>> ---
>>   net/rose/rose_loopback.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
>> index 11c45c8c6c16..1c673db52636 100644
>> --- a/net/rose/rose_loopback.c
>> +++ b/net/rose/rose_loopback.c
>> @@ -97,8 +97,10 @@ static void rose_loopback_timer(struct timer_list *unused)
>>
>> 		if (frametype == ROSE_CALL_REQUEST) {
>> 			if (!rose_loopback_neigh->dev) {
>> -				kfree_skb(skb);
>> -				continue;
>> +				if (!rose_loopback_neigh->loopback) {
>> +					kfree_skb(skb);
>> +					continue;
>> +				}
> 
> FWIW, avoiding the extra indentation may be marginally more idiomatic:
> 
> @@ -96,7 +96,8 @@ static void rose_loopback_timer(struct timer_list *unused)
> 		}
> 
> 		if (frametype == ROSE_CALL_REQUEST) {
> -			if (!rose_loopback_neigh->dev) {
> +			if (!rose_loopback_neigh->dev &&
> +			    !rose_loopback_neigh->loopback) {
>   				kfree_skb(skb);
>   				continue;
> 			}
> Good night.
> 
