Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FABF4A7E71
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 04:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347717AbiBCDrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 22:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbiBCDrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 22:47:46 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D666C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 19:47:45 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id z199so1644967iof.10
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 19:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=H0oh1C/EjF8M9KOof5Fu6tITIBMFgyO7FBozgep09RA=;
        b=Fee7UAHVI6fOl4m+UU1z850YHs7GRXUKMUMbWvkYR/RvuXsxQSOvWQ48iIploJwNBg
         yP6QmOIZm00W1p6TTsEUgWTGsxvyM/AjusUG02enV7dAbN+ez4ivmjZZn9UhIsdFIrbz
         l/8t/QeYVZvlG/oHdF6QpSMAIO5Ettg8z78kipQZbrPzu7uuqmaL7SP0g6Ud7P/s98gj
         H6xO5hb9cG8IR+QQhas2FzMSfAR64YE6AlN0UUbicqw5ov8rxnZZAkZke3WTUGDQ68Mw
         z2plbdceZdyu3ONT41y+FI1mH68bODCrr021h7wRWXKSle48VfSET0CobL5zAkitZLKZ
         G3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H0oh1C/EjF8M9KOof5Fu6tITIBMFgyO7FBozgep09RA=;
        b=5pRmYi7u02tUo7gxWYZn+HneMcP0M1VWVoQqE7rMNM9QhrVOVdKtuSLB8nvV+qbkxb
         2h9MlewQSXZt35DFlSEouQmWFlUf4rbxpwuah0tgpJmRvp6fAE7ox+svbApEuw4vL0wk
         AWEsCcTBSGYYhFTbowxUu1Of1+tK9SpmogPVrZNAPoDpveV1T1pHF2t+8JxGCbh/seyY
         IhtcdIemNgsXBB1NGnn3Ud4iu+PaUwIu54ChWAndWCv9AkICZ4g4OWKhPqt4UuX4e6Cf
         UxfVa17xSzOQ9cg0YSq1l8QxNrkCtWKZUnt5y+9qJnjS5Byib9rkRZJJNdPm911TwNE3
         lOnQ==
X-Gm-Message-State: AOAM531z4n1/OwUGrAzVVfizgyEOmZD04ukLwHclYEaUKpx2Km0EFTdB
        I/jVRm8VC8rG/ahFSmhv+qDYbLtRu/s=
X-Google-Smtp-Source: ABdhPJwZTPVSVDtRbBSw7sxu3I/9FKgO8y5USNwxRFmzU1Ll1t4rpZUf1DZR1Hx2LRhP7jVgf31YQQ==
X-Received: by 2002:a05:6638:3781:: with SMTP id w1mr17682595jal.178.1643860057068;
        Wed, 02 Feb 2022 19:47:37 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id h3sm21979302ioe.19.2022.02.02.19.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 19:47:36 -0800 (PST)
Message-ID: <387b6b6e-3813-60b1-51f2-33ce45aeaf47@gmail.com>
Date:   Wed, 2 Feb 2022 20:47:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v2 0/2] Support for the IOAM insertion frequency
Content-Language: en-US
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
References: <20220202142554.9691-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220202142554.9691-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 7:25 AM, Justin Iurman wrote:
> v2:
>  - signed -> unsigned (for "k" and "n")
>  - keep binary compatibility by moving "k" and "n" at the end of uapi
> 
> The insertion frequency is represented as "k/n", meaning IOAM will be
> added to {k} packets over {n} packets, with 0 < k <= n and 1 <= {k,n} <=
> 1000000. Therefore, it provides the following percentages of insertion
> frequency: [0.0001% (min) ... 100% (max)].
> 
> Not only this solution allows an operator to apply dynamic frequencies
> based on the current traffic load, but it also provides some
> flexibility, i.e., by distinguishing similar cases (e.g., "1/2" and
> "2/4").
> 
> "1/2" = Y N Y N Y N Y N ...
> "2/4" = Y Y N N Y Y N N ...
> 

what's the thought process behind this kind of sampling? K consecutive
packets in a row with the trace; N-K consecutive packets without it.
