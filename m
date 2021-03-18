Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A6634098C
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbhCRQDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbhCRQDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:03:37 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46496C06174A;
        Thu, 18 Mar 2021 09:03:37 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id u19so1735956pgh.10;
        Thu, 18 Mar 2021 09:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rhf8zvCGuaBm5J6Ibe+EldzzSj1ruRZq6mnbgSjnIQg=;
        b=H0wnRXgQBJ0Qgva3WgnuRtjMytJK6ET9eomIqEz/mOgDD6uoBfFxL3E0V/xTwB17/o
         x0BSOS8+xmeTc6NhGHEeK8RTuUyGy+tjzfYU2YnJgvZ+xokGqaHJUSuQlIPy8GGJ9L8Y
         JIVNwbPzJNAgP/W7Ua+Ne0wnYSuJiQ3FSXGPcZ8QWeK+X/8xAl0uCl2qI6B5JMrGzk2z
         aqvlCK3l8oU1bsfE+Y/Hv+FLfoxXEkH/L/WSyjfFJmSsfkCHPqe73LaZXukcbJ9JLoGs
         yM6/+k3WEt+Nf5pJiK9LSthxMfrEibz81hS6DkQUdPnYe9VhlsxV6QkBHoqsaahDVc7m
         dzQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rhf8zvCGuaBm5J6Ibe+EldzzSj1ruRZq6mnbgSjnIQg=;
        b=eXoHbVRoga7cHpKTlqL3YG6cmm64NUkb6w2kHCEO3saczFBHvC/lVVVd3sykiAAPUN
         vTw94hM6THw4qAgN1SVU189ANFRjFTN/AFjn4mdM2s55a6q/gyW9kgBa/gYSi3g2VAZ9
         N1jQUqODPUpdU+J3G+hanfwgfagZP/Cxi9h3cRHBCnS6eV+ua1aLlVKHyYPhESa73i2S
         4as9WVXnu7doqns9dE6we/4GviDSoDyZUwANklehZ/5OOzJ+kwa2XQLinOyyN4mlYfic
         FnWOp43yYqT+lbiIH/rfkLtVi/X0E8ctuZb3fo4DnmpfULdHEPGY71qG2ZI4v44IEOqw
         46QA==
X-Gm-Message-State: AOAM533j4v5hGdHOXJ/wIYJ47pR4I7XUE5jbXmvwUca1O8n0troAmdDu
        cxaKOSC8HkJBH4DjdnYSefg7K1AZODU=
X-Google-Smtp-Source: ABdhPJyibwSbcBAuOX9TA5b+pRXQeJjCtCUr+rd991oEEiGA5tPWNV3sNCdVysqQiA1w1hYo0up+9A==
X-Received: by 2002:aa7:8d84:0:b029:1f8:3449:1bc6 with SMTP id i4-20020aa78d840000b02901f834491bc6mr4726500pfr.76.1616083416345;
        Thu, 18 Mar 2021 09:03:36 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i20sm2532132pgg.65.2021.03.18.09.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:03:35 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/4] net: ipa: use upper_32_bits()
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210318135141.583977-1-elder@linaro.org>
 <20210318135141.583977-3-elder@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <75a8c09b-783a-6d05-2e56-02bd02ff3ff0@gmail.com>
Date:   Thu, 18 Mar 2021 09:03:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318135141.583977-3-elder@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 6:51 AM, Alex Elder wrote:
> Use upper_32_bits() to extract the high-order 32 bits of a DMA
> address.  This avoids doing a 32-position shift on a DMA address
> if it happens not to be 64 bits wide.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: - Switched to use the existing function, as suggested by Florian.
> 
>  drivers/net/ipa/gsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 2119367b93ea9..82c5a0d431ee5 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -711,7 +711,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
>  	val = evt_ring->ring.addr & GENMASK(31, 0);

Did you want to introduce another patch to use lower_32_bits() for the
assignment above?

>  	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_2_OFFSET(evt_ring_id));
>  
> -	val = evt_ring->ring.addr >> 32;
> +	val = upper_32_bits(evt_ring->ring.addr);
>  	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_3_OFFSET(evt_ring_id));
>  
>  	/* Enable interrupt moderation by setting the moderation delay */
> @@ -819,7 +819,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
>  	val = channel->tre_ring.addr & GENMASK(31, 0);

And likewise?

>  	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_2_OFFSET(channel_id));
>  
> -	val = channel->tre_ring.addr >> 32;
> +	val = upper_32_bits(channel->tre_ring.addr);
>  	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_3_OFFSET(channel_id));
>  
>  	/* Command channel gets low weighted round-robin priority */
> 

-- 
Florian
