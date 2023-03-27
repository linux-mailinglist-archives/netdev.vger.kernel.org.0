Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF8F6CAE6C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 21:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbjC0TTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 15:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjC0TTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 15:19:22 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139C1FF;
        Mon, 27 Mar 2023 12:19:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id x15so8674388pjk.2;
        Mon, 27 Mar 2023 12:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679944760;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cEkusteTCwDKEBTVV3xCwC/kfjYPRfGUw+a3FX5ZwvQ=;
        b=VnMzSKRHkGQ2F/1Qlw8a1//zhs7+0iNWB2nGlemtBy84Ho48i/cq1Hobv6NM96R+As
         4gyZ6BZTmXOGaJhdpgRtci1kjrgXsPypn9ENPuGKjmAPxd80GPkWJA108NLSeISHFjPI
         3zinFav0jBjl9Rk1fvHIcBsrbJx1ws2gH3w4KNjFHgyymCm2OpoCgL7pUGpYfE00/PoH
         Naifw8HjeekgmNMW9+SMaX4hMok2vY6IjJyExkvHTi7JWrccVjn+QWzUa1sHjfFMAieH
         D23CMPUEL+eAQLKud4oHIUEQHjbCskl+AQkWuRZQfJ15jFIklGUyzAKZefO+ctZCyXSq
         4Pzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944760;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cEkusteTCwDKEBTVV3xCwC/kfjYPRfGUw+a3FX5ZwvQ=;
        b=ymg9vvTAOblxVeFWpSjiwf4e6OIHsqFFAB1T5YjcAjfLAfTPmcwZCDyD2XhQv/VhKn
         pHblsqFGvRHOZm8PKnGkyIoOANyq/1z19bS5yatsAvI061b6+91SPYXRPuwNDpYnWG7h
         lE6wVc3AOoBR6inUBgJ5l1H12wRWhtHbXUlTcqHBDPC/rEUm7Iek+4gC279loilqUK7L
         mRCGcw0mDOkuYG/Nm2Hmp9xE3TtRJ48YQg5mGrjdpFj3Be6U57UyYgWfcpQl/P9divcO
         s+sGNVylniEMGyKSv/OjE83dkUcYfWxB+mgFc66hLjD6TpwLDyLaP4bKxn5lumvhZJMj
         WopQ==
X-Gm-Message-State: AAQBX9fJsaNVNzS9jJU49xRMAw6qaom9d+2FYIvec2vca9vWi4KOy2NG
        3krofGPzgJHimaABKV/mjJKB6zdnvZ4=
X-Google-Smtp-Source: AKy350Y1d7IcYtthJ5wrpgwsqCrUj3040jTnkKRMa1iUXhp3SBw6zzkp8EfejSdE9+zdinFv4DQQcQ==
X-Received: by 2002:a17:90a:c402:b0:234:656d:2366 with SMTP id i2-20020a17090ac40200b00234656d2366mr14314177pjt.42.1679944760470;
        Mon, 27 Mar 2023 12:19:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ce19-20020a17090aff1300b002367325203fsm4743777pjb.50.2023.03.27.12.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 12:19:19 -0700 (PDT)
Message-ID: <7975a642-965b-81c7-d0e7-21e499b152ea@gmail.com>
Date:   Mon, 27 Mar 2023 12:19:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] docs: netdev: clarify the need to sending
 reverts as patches
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org
References: <20230327172646.2622943-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327172646.2622943-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/23 10:26, Jakub Kicinski wrote:
> We don't state explicitly that reverts need to be submitted
> as a patch. It occasionally comes up.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> ---
>   Documentation/process/maintainer-netdev.rst | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
> index e31d7a951073..f6983563ff06 100644
> --- a/Documentation/process/maintainer-netdev.rst
> +++ b/Documentation/process/maintainer-netdev.rst
> @@ -184,11 +184,18 @@ Handling misapplied patches
>   
>   Occasionally a patch series gets applied before receiving critical feedback,
>   or the wrong version of a series gets applied.
> -There is no revert possible, once it is pushed out, it stays like that.
> +
> +Making the patch disappear once it is pushed out is not possible, the commit
> +history in netdev trees is stable.

I would write immutable instead of stable here to convey the idea that 
there are no history rewrites once the tree is pushed out. With that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

