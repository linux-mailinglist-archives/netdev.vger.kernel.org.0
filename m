Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2A2C7B37
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 21:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgK2UuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 15:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgK2UuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 15:50:14 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B00C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 12:49:33 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id z5so9765234iob.11
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 12:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b2e3fqOjcS+Zq+vsJ8baYO9TNcLlXNXc307T8IyWJoc=;
        b=NObBXoduTy39OSeWbJLBKh8KdJT8pVKoEWJxTTX19D7vfY0V7OI8Q2Gostv2K5gJQB
         bA0AzPkVUbND760MQFuTq3MpXPFL4c+Xh+OfSqQCOAYp1oJG9wCM6AtCE9KLbULIpzfq
         Ff3JeZRKSybh2ieDOooqnRnZrwpmYyJPvbvrf0fXLf/K7xGBIuOrrewr0s/q2L3NjPQP
         RvcvDMKH+ttZ1SJtzq+WeZkiQIaWuaxWuhYL9UZ60HmUSRRc+9HQgoeOoDFRFcZA9sSv
         Rbk/OmBm9QM85dm+f2ENcXUAvO03WPwuncX93XrHy+8M3ScB+SRQtV/ukPCwAaKDs9oc
         UjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b2e3fqOjcS+Zq+vsJ8baYO9TNcLlXNXc307T8IyWJoc=;
        b=DSoU2ptGzA2YQfd7iwfMa2GEQSSBEn6SLuvEEHXb3WKFnmeRYC3nvGmvP5a1K2NHlL
         k4n05Eu+jZTwmUhujRwuFQNHVqk7/UTGDyonFwkAyfgKqYZ9oJ23RFX3BmfoJxXuPYaD
         bLOGqvtsKmEMUrNZjQ1AOJ+3lNL5U0S4sDzgfGwI7r9f+hvTryIa5mn2w1GnwtU6VKQE
         7CjK/Je6ybjcN4fNxk/MrVyrO/YDGMxfNx34t/xXLK1RBRCbl4y8uzgyGG6h+2Tnxh0B
         5Icons+VOaQPXkukn8GfzDJiYq8/JPo/qwvugFJIt83goZIU2zbHXtA1+C9OR08hUtgm
         36PQ==
X-Gm-Message-State: AOAM533Lb9CUb9yJF0rj1b23Q8T+dngFXxusaRVGI3tKcY/4uxHwuHei
        SXG80ITPAQFAOKB4ZbSW/HkIugRaQu0=
X-Google-Smtp-Source: ABdhPJxeGVaZQ0U48lbbWyMGgLMoQ5Wx6qE8bnql+8M188X7+QEzROU/9KCT3ufnFxihdaUVA7LR1w==
X-Received: by 2002:a02:862a:: with SMTP id e39mr16203816jai.95.1606682973270;
        Sun, 29 Nov 2020 12:49:33 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:4896:3e20:e1a7:6425])
        by smtp.googlemail.com with ESMTPSA id e18sm9599283ilc.52.2020.11.29.12.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 12:49:32 -0800 (PST)
Subject: Re: [PATCH iproute2] Add dcb/.gitignore
To:     Luca Boccassi <bluca@debian.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20201127152731.62099-1-bluca@debian.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3e94e04a-48cf-df9c-8562-939a66a892bd@gmail.com>
Date:   Sun, 29 Nov 2020 13:49:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201127152731.62099-1-bluca@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/20 8:27 AM, Luca Boccassi wrote:
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
>  dcb/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 100644 dcb/.gitignore
> 
> diff --git a/dcb/.gitignore b/dcb/.gitignore
> new file mode 100644
> index 00000000..3f26856c
> --- /dev/null
> +++ b/dcb/.gitignore
> @@ -0,0 +1 @@
> +dcb
> 

applied to iproute2-next. Thanks, Luca
