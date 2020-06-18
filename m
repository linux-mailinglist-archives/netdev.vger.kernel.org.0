Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD201FFEAF
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgFRXfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgFRXfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:35:41 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40831C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 16:35:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id i12so3290734pju.3
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 16:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wcssVOUJXmM7Zmp5vAiMUvwH4GA7FuuW4C0wJ1i5p1A=;
        b=M1/ZwbmfQ5rJZ5zTXQw62pH5gU06MaG/cptHeRaHjMMYUiuCGVEzdBm+ohQqpU4VHI
         3DUeOGUy2xpWCU4z4S+zPbudCYi/Yg7cAFxUgrjB4TY17RuO2OMjXQDZ95oLP1tRUFoq
         uenN7CKEo3zXfHB+6ucYcQOnvY3YTj9wWwOqDXGxZ2Wv2GMKec6ECfG9sKWcqY5CGE8/
         7ln/rHDA9CHMIa5Xa41q+Lg92OOlWsrikKXq57uBQ2E/sdMLzlAqumuwqu+wLrJY0Qs0
         kEE8NdKMTQ+AkFg6xFnlT7zmWkHF1Am1Y5/gMtpNIhBIMYr8glopXOb1BvuoZ+eWKEdQ
         W1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wcssVOUJXmM7Zmp5vAiMUvwH4GA7FuuW4C0wJ1i5p1A=;
        b=MMnTypQE0+Tz6TcLD5VzbYDtDXXOR3v+Hi/JH0k5KIUNZpiOvMPuJpGRLgX7UG4TjF
         deFav0d6dBscp03N+apVBsYMhVEBS4bLI3goX/zOCBYdHNAnUnUUdRw60h/s1oXrgsOJ
         0Bw4ktULnTa5+ppur+Euk45+nm7YxPj8kXkHn0S/W4CenLNDqykaB2C4qib7Hl3t7y4d
         rrj00vVeHIqOq/UAD9j5Wk4nu35J4Xnjtag1ZfojhIij6Lz5oSyR8cb5YURVbaeBger6
         9WGsfVl9gSrDO7av1/4A7OG+0+DxGDnQ1D+ViYP+jajU/+yUxOqTclB6LROjMUAfeswj
         +5Yg==
X-Gm-Message-State: AOAM532lQV5PE8gwCzEb8LG8vpc7hOuSbDdfMejSXq+70uAUONq1e+bk
        xJNtXbyBo4hHENjyDESX0p6W6OFI
X-Google-Smtp-Source: ABdhPJyHJI3XJl3pewaH5D7EzASfjAQtnrsBfrUSszaP+grL4sNs3TAwxO7fFf/MSNzHFzI3KNXzCQ==
X-Received: by 2002:a17:90a:a40b:: with SMTP id y11mr805719pjp.54.1592523340859;
        Thu, 18 Jun 2020 16:35:40 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 200sm3998600pfb.15.2020.06.18.16.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 16:35:39 -0700 (PDT)
Subject: Re: af_decnet.c: missing semi-colon and/or indentation?
To:     Randy Dunlap <rdunlap@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <4649af05-ac31-4c57-a895-39866504b5fb@infradead.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <407fa160-aec6-3135-1579-f833bebe59a2@gmail.com>
Date:   Thu, 18 Jun 2020 16:35:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <4649af05-ac31-4c57-a895-39866504b5fb@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/20 4:19 PM, Randy Dunlap wrote:
> 
> Please see lines 1250-1251.
> 
> 
> 	case TIOCINQ:
> 		lock_sock(sk);
> 		skb = skb_peek(&scp->other_receive_queue);
> 		if (skb) {
> 			amount = skb->len;
> 		} else {
> 			skb_queue_walk(&sk->sk_receive_queue, skb)     <<<<<
> 				amount += skb->len;                    <<<<<
> 		}
> 		release_sock(sk);
> 		err = put_user(amount, (int __user *)arg);
> 		break;
> 
> 
> 
> or is this some kind of GCC nested function magic?
> 

I do not see a problem

for (bla; bla; bla)
        amount += skb->len;

Seems good to me.

> 
> commit bec571ec762a4cf855ad4446f833086fc154b60e
> Author: David S. Miller <davem@davemloft.net>
> Date:   Thu May 28 16:43:52 2009 -0700
> 
>     decnet: Use SKB queue and list helpers instead of doing it by-hand.
> 
> 
> 
> thanks.
> 

Also decnet should not be any of our concerns in 2020 ?

