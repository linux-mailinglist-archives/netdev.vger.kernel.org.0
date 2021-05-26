Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26C539194F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhEZN5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58851 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbhEZN5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:35 -0400
Received: from mail-ua1-f71.google.com ([209.85.222.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1llu0w-00065P-Un
        for netdev@vger.kernel.org; Wed, 26 May 2021 13:56:02 +0000
Received: by mail-ua1-f71.google.com with SMTP id m11-20020a9f3fcb0000b029021dec910e95so794215uaj.13
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gZn8h8gkilkZaN7gS01tsrUP7HzVUTqYj/r9HNxu8z0=;
        b=fbz7ZZ5LkCdm9yjKT6Ptny+JnU6s72XCb3N3TwouO7CkUk50yPKug939JfhP8mKCaT
         Q9BeO528JyqnB6KLdQqNJtQbECNUY76nNpVULQOBUNvDvY8URAIvfZ+AtvJyi9o2Wpgu
         uwaWLw6dAYSz3bUrJEqRWsBdpHQ7YNIgXoN2lfTuVB9K8OzuHXavzhO5+AUjd0Z8G/mf
         EOUSkmXn1bQ9IcB4/zlrnoN9aEGTNG0ddkcqf+QCgZtgNrcDHG2dK/lFvtts7eC50dZj
         rQ4mrDMy/N7cyCG8tf6f34kx2FxnB+3UNS0VQIBLpCB5NKg7jsT51CHhMe+6mB/JNUjo
         gBHA==
X-Gm-Message-State: AOAM53087/Jt+hsKYPM8GX1CbtM5AqMFpfzWwatit3JbhT7L1jxo5R1B
        Kp2xUGQz22KEKO4GC0MMkl0jPHuqxDveqQQFWg6ORAS6ClgWv0bOiWN/rGLD3M6FcPbLZm7VguZ
        CtdVYqi7ZUmYykXH0ah7CizOtFcuLnTLY6w==
X-Received: by 2002:ab0:14ce:: with SMTP id f14mr32867638uae.50.1622037362157;
        Wed, 26 May 2021 06:56:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJtF7d3KZ3MenrDN2pRpX/m5oT/p1wrFd4tXmL69qgbesK0af5Jah5586fDe1vLhqceDDxUw==
X-Received: by 2002:ab0:14ce:: with SMTP id f14mr32867618uae.50.1622037362034;
        Wed, 26 May 2021 06:56:02 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id f6sm2100014vsh.31.2021.05.26.06.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 06:56:01 -0700 (PDT)
Subject: Re: [PATCH v2] nfc: st95hf: remove unnecessary assignment and label
To:     samirweng1979 <samirweng1979@163.com>, davem@davemloft.net,
        dinghao.liu@zju.edu.cn
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210526005651.12652-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <1aecd37b-88e8-e00d-d0b1-2fd989514c19@canonical.com>
Date:   Wed, 26 May 2021 09:56:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210526005651.12652-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2021 20:56, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In function st95hf_in_send_cmd, the variable rc is assigned then goto
> error label, which just returns rc, so we use return to replace it.
> Since error label only used once in the function, so we remove error label.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
> ---
>  drivers/nfc/st95hf/core.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Best regards,
Krzysztof
