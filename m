Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C3025825B
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 22:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729953AbgHaUTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 16:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgHaUTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 16:19:12 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB776C061573;
        Mon, 31 Aug 2020 13:19:11 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p13so2333457ils.3;
        Mon, 31 Aug 2020 13:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YRjF6Eq2TP9aDmiLjqgyK845GcDUN+gIq21VnRpOcC0=;
        b=O5Nnh7qElgwDH7pXdLmaFcO/9UjxqFj87RgJXxiJke1VB4l9JV5aijyyP2Qa9JRk3Y
         1L48XceM3IH5KUTq7LSs7zGXCvT4YFkK+8TJ0XS3tLbO0uXWP8IUHbKJqVeoSvbELxvn
         sfeRF1+eaOm0ibOcOV/cuQNYMhbrOJh1pRQTTmW/lZALc4mYGW2f18ZCYE6qPCNs2t4w
         UP7Z60CKDzFpnVv8jcm3WH35soA8AsKCxiHW39ueraqLkpkZqVQYE5ZCdkIS5WVdbwj9
         cSZhSCKyXt4nY7MfHLfGrUK5NlJzkDr/ThuFc561unuApjtCx79jK8GFEcx2z6rzUG54
         Lw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YRjF6Eq2TP9aDmiLjqgyK845GcDUN+gIq21VnRpOcC0=;
        b=ZufdlghPWdFOeuDZKcsfjvaiWX8LnLRiihqb2d8nhMIUZvLGrlcGipjjaZQGhKsvmo
         jcsown4Mkaom6CxmN0G+oKWCrkp/+YXhRtCfPjVH+eRdtV3AVs1Gil+bC46/kuund8F3
         DFuHR466VBf32GpL4MC+RKk0ncX6Q0r7AxG1HGq/wtaDnN4rNtHNYcu/mtC7NM9KEEgo
         4aXmN2FJozHa+CZ9qMQq7EnBejnXlQBCovrMX27K9x7BlMayvj1wKkYGJWHn659ISTC9
         iC7HkcmWI3MjCrdWK6O25NgZMGR/NZNUFhIZZSMt1f5Vtj42mYt/J4JKu/ojcK7jFpCA
         7I3g==
X-Gm-Message-State: AOAM532gPTZz6x9jwh3IS3uBtK0hFjfVZHgOTsyXOZVQdUo7+NkDWdBT
        gI0aff+lRl7+svFilzyEXK3zdIp2zDQjLg==
X-Google-Smtp-Source: ABdhPJxIffX+ONmiYmLW7Q+My19L36VNZ2RYsKhdtSoKODMUIrJxiKBV5BsNMQkrGLxOKJjwwYuJQA==
X-Received: by 2002:a05:6e02:e08:: with SMTP id a8mr2742901ilk.55.1598905151183;
        Mon, 31 Aug 2020 13:19:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:4c46:c3b0:e367:75b2])
        by smtp.googlemail.com with ESMTPSA id x185sm4440606iof.41.2020.08.31.13.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 13:19:10 -0700 (PDT)
Subject: Re: [PATCH v2] net: ipv6: remove unused arg exact_dif in
 compute_score
To:     Miaohe Lin <linmiaohe@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200831062610.8078-1-linmiaohe@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <25f5e65e-4eef-80ea-d399-7452f7f53b80@gmail.com>
Date:   Mon, 31 Aug 2020 14:19:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831062610.8078-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 12:26 AM, Miaohe Lin wrote:
> The arg exact_dif is not used anymore, remove it. inet6_exact_dif_match()
> is no longer needed after the above is removed, remove it too.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  include/linux/ipv6.h        | 11 -----------
>  net/ipv6/inet6_hashtables.c |  6 ++----
>  2 files changed, 2 insertions(+), 15 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


