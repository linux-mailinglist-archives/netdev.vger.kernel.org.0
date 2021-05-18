Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E278E386F84
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346085AbhERBoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbhERBoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:44:37 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D693C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:43:19 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id d25-20020a0568300459b02902f886f7dd43so7283046otc.6
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kloj4Tq6xkxQh8oOTZxIiwcuOQ37MWHg1Kxfrhcguw0=;
        b=R/NmRQiwJquuA8YF9AH3iSSenx2FdrjU/0CZYHciAK4g/bL84WG7XUT2kKEt8F/AbP
         bxA1+r8aDdE3V3AxZVHIuwRWO1XO+g/NofVTZAxLyppIAKzIsKO7tlOBdsk+eq+/kclu
         8ys2m+94vsbhZpOK86orjawy6XS7i5gZBdtI4mrT+ypWQWf9GHQTr7v4WIZUUIu9Ygff
         qxvSKiBBQFrPoMwTFkyDM1E3m3VJiC863dLZFAxT8QaXKCiTVByO8bodPUeIWxrstulJ
         NKE3DGnejSwDUuqc7YRgfMLp0tt3eXgLKOxw4Op/SeWYnWSFBZD1c5tZMb8iOmerxRiU
         qmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kloj4Tq6xkxQh8oOTZxIiwcuOQ37MWHg1Kxfrhcguw0=;
        b=OTJZ4I8m6d5+zJfSLhGf3oA9trxom48gCTDm8c+4Wd9HhiNCzIS/FiF4lPGz8b39Ov
         FiIN4kG6slz7lfiESUyp202IQW2X9dfZK+kuiB3YkSZXatTiWTBPV+1m4PIVIDOGIWsX
         gtP7r8MIpvLgmTLSGLWqfbPl5hanwrAC/9ZNA+K6q8aWx6iHYzDZfNPNOQE76HK48cv2
         A67f4BZ77buxLUlP+Rhv9hdpCN6jwt4b/96+5ZtixGWy9TW7LxtN/KIEXuKoq9JVsmFu
         LA3gQyOQagz0JgsoDi5LJwbUSRLRLGXWVZGzsYp5T7/V5dCiUM5BGyliWmWNCrjtInyd
         YRug==
X-Gm-Message-State: AOAM5316wEA4NXcLMiXjolNe/170BTktUqbPjjjbcYxAkf9lPhraygDt
        N12UeDEtwuH4weMMd0UVGiY=
X-Google-Smtp-Source: ABdhPJwbSZxerbW0R1Jdte4uOu22mQAcWD/inRWMaWdHwH3oCBICQUbQmKu5ArJfd/TJ1SgQNZqfnA==
X-Received: by 2002:a9d:69c5:: with SMTP id v5mr2094223oto.108.1621302198556;
        Mon, 17 May 2021 18:43:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id n5sm3513494otq.69.2021.05.17.18.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:43:17 -0700 (PDT)
Subject: Re: [PATCH net-next 04/10] ipv6: Use a more suitable label name
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-5-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e8c51ab-970d-8a65-eebb-3411f487b7fe@gmail.com>
Date:   Mon, 17 May 2021 19:43:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-5-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> The 'out_timer' label was added in commit 63152fc0de4d ("[NETNS][IPV6]
> ip6_fib - gc timer per namespace") when the timer was allocated on the
> heap.
> 
> Commit 417f28bb3407 ("netns: dont alloc ipv6 fib timer list") removed
> the allocation, but kept the label name.
> 
> Rename it to a more suitable name.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv6/ip6_fib.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


