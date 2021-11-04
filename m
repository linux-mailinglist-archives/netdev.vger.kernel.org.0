Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C5D444D52
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 03:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhKDCgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 22:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhKDCgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 22:36:52 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DB8C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 19:34:14 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id bl27so4012995oib.0
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 19:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=0AoHX+v27LcI7PHqTRw6u0s4iBcIaXYHI1EZWfPb57w=;
        b=G/SjpAeyZPDjiSmpas7L3Q1/nd4XLsjna9LQnLu7m0847e3DXAP21p3OsVmjJwy8FO
         HvrMayNwFCT9jVy2GVYU1swbeTDe8/Ae7actIZFCe7os61VVhG39qVjsz7pEopuK5Rpw
         Gcms217x1fQUzOr4FZnE3pzorvwu7zO7YOSZlK1piykKG+4HGrvz4vXmjAR81vJTZ1wL
         Bfd2X6VJGAmED1Wp/abOuCBWvFyA6rD55Kle2DxSW6nEOqV3dBScdD54OeyxAqQilYMZ
         X3sJy8nCfe0ZO782i3aa4A5dLD+is5hQa+wna+IGGR6JgEH8sluRHRW2ZeuLPjwaa3Ui
         5C0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0AoHX+v27LcI7PHqTRw6u0s4iBcIaXYHI1EZWfPb57w=;
        b=I++sRUl8r0yjRCCnscwSY9x271nP9HAydbPpvV5nt0hirt3+xPSFnhIIQsjLah9Vo6
         5Frury5dEqiFP6KX0EFZzXYJ/voLECyviwkm256SAhW1dkfifGrwsaSdC9kPoAarplgW
         XbuONPNAltWBzhLnY99CgkC4uIxjPJsyh29wgG8nx0ch2HJKNFsiPt/0dxfx/ZwESx3S
         c+L+5DgchctNSI5teGns2chvdSrQ17McQgxc3O1X0QgHpSb/8UeFfihkrqIvJhtyXVpZ
         02YLvH/PCoMvuNo9ONbK7QPZ2n+dk64iKA7NQYlRQojHFQb0fMeH1QVYt2g+2eSSUvh3
         Gj6g==
X-Gm-Message-State: AOAM5302fjDWrjp50eClHhe6+gRCM0Ho4BRAQH6SW6Gl2T/PuZXXv7p9
        3QEa3AGZuc9b/t4pXayquhFdyjJNpEw=
X-Google-Smtp-Source: ABdhPJzcFAAIMhqOft3ylKPUchZEc8M5B7HKvXFiJREs9jB6YYQp545FLVmG09yqMdg7tX2lmSSrGA==
X-Received: by 2002:a05:6808:1814:: with SMTP id bh20mr14428844oib.0.1635993254270;
        Wed, 03 Nov 2021 19:34:14 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k2sm605473oiw.7.2021.11.03.19.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 19:34:13 -0700 (PDT)
Message-ID: <99b10575-78df-d0bc-b963-d19e08b4545c@gmail.com>
Date:   Wed, 3 Nov 2021 20:34:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH iproute-next v3] ip: add AMT support
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
References: <20211030140858.16788-1-ap420073@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211030140858.16788-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/21 8:08 AM, Taehee Yoo wrote:
> Add basic support for Automatic Multicast Tunneling (AMT) network devices.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> v1 -> v2:
>  - Remove unnecessary check
>  - Use strcmp() instead of matches().
> v2 -> v3:
>  - Remove unnecessary check
> 
>  ip/Makefile           |   3 +-
>  ip/ip.c               |   4 +-
>  ip/iplink.c           |   2 +-
>  ip/iplink_amt.c       | 200 ++++++++++++++++++++++++++++++++++++++++++
>  man/man8/ip-link.8.in |  46 ++++++++++
>  5 files changed, 251 insertions(+), 4 deletions(-)
>  create mode 100644 ip/iplink_amt.c
> 

applied to iproute2-next.

