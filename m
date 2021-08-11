Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69293E97A1
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhHKS3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhHKS3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:29:21 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE1FC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:28:57 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v10-20020a9d604a0000b02904fa9613b53dso4451048otj.6
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 11:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q3UOthGtcv3WjBvzkxGZiDURtWRi2EHI0sJYtpr+hSY=;
        b=slqz+LC+UuqPx3KqSIWVi4zgDdXczzQMDWp5yjEfHyiMRAs0W5uEXuaU+M1f7Yhfay
         2k6/dnF3bM3CiV3AvsQSYCje0o5xr/edEmOi+zXYL+JFq+Sn7QvEKuap/bLmP8NNMOsM
         C5mBY+YcabA9qqKO5+eZEnFxfY7c+H7JX14qOsQ3h5EKUnuFLuKlinFGj30+AqH0QYHl
         HQUkaUd/tPVsW2MsdDZ95mDLLm11olOH7urzSUzMvR8A487Hl8qfyT6ljvZnXi/N7bX5
         Pk7YeN2lZjwz+7fmlZpUQNBi1TEVF5sPbXRWGRBU0yk2gIcqeJVxGGPc7xubjAkAhaEG
         woeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q3UOthGtcv3WjBvzkxGZiDURtWRi2EHI0sJYtpr+hSY=;
        b=doIdlKDJMuLYm7iLRtcDF6YP+gbJjr6CyVqWc7j3B3x8XjaXmzkQ1tj9f0U9+LiGdI
         wyjLeYdGD7+SjbHZf9vBSB0dZg/SUdqSVSzWupu5WlrHzkIx2516O2XFF5Lzn8+4G2da
         YIGYD9xc74Lk9VDgXR5v3GhAx3BsZtcYrxy1UvHZRFUXr6S2iIk8npinNmoh6KEPxFMi
         YiKTqOloZUju+EtCgOJSsz670v0B7at2QNsY7UApLA6n94oFYxM+n1Z9aRXeOZdYhNws
         O0qxrkSFdAuGYB3NJcCq7oDP3bRSVeqQYV0cuxIx0mG3R0kH9gd0p0sp7R+SYdY7nVX3
         bsdg==
X-Gm-Message-State: AOAM530PT6/6sXmrYgZthZDMfaOmBKDebtwVzRwcSwIMiI9faFaq3O6o
        hLAzOKvCSF+nZC+D5GPUbx4=
X-Google-Smtp-Source: ABdhPJx0F1YaYDPT1vwuTxukiPYRsz9WlQU+3m1FFR27YeH3pT3PSuu887fHwFgRR9IYdO8pIJQZQA==
X-Received: by 2002:a9d:86e:: with SMTP id 101mr287368oty.114.1628706537177;
        Wed, 11 Aug 2021 11:28:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id f3sm55013otc.49.2021.08.11.11.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 11:28:56 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ipioam6: use print_nl instead of print_null
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210811101356.13958-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0c1f2466-6af5-5299-6aa9-4479cef7bd76@gmail.com>
Date:   Wed, 11 Aug 2021 12:28:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210811101356.13958-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 4:13 AM, Justin Iurman wrote:
> This patch addresses Stephen's comment:
> 
> """
>> +        print_null(PRINT_ANY, "", "\n", NULL);
> 
> Use print_nl() since it handles the case of oneline output.
> Plus in JSON the newline is meaningless.
> """
> 
> It also removes two useless print_null's.
> 
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  ip/ipioam6.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 


applied to iproute2-next


