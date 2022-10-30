Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617C661295F
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 10:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ3JWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 05:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiJ3JWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 05:22:36 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956F8CE31
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 02:22:22 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v1so12033630wrt.11
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 02:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nmx3+cw3jUw/TPguLAWk9l3G+B4sCuP3PNuypRYou9g=;
        b=Ak2BA8nGx0hA6ofbHr0abJu2m2fzdoFWPbKkLh3Q5QmiSVSwD98jPMISKziX7eL/Xp
         cPmqQwv1koehSAkbsNNns6x6BNFx93sxt+GEfP1G8VhrYTAE5ak1CxeJAtcR5TGjSJtZ
         HK/U/SEK4gCDSTzsiGh27CTKMrwbCuVyo99yCDbRSFo5D5tJ1WyiNWGvXh8EZLBl3NgO
         qQXGZfFU17SHQtE++UnTe+X1w/BQYZ9qBtLsDH+MN7yQjDeEitfCcrem31gNVOR4CJUF
         NV17Byvvbf4tAFS8h1XPvEspoP5wBwNC1Ldj3F6zdKYn4fKnR5+H6bW2U6mGprELcx+V
         Z8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmx3+cw3jUw/TPguLAWk9l3G+B4sCuP3PNuypRYou9g=;
        b=UDKbdsg6i//VvZJ6bHYVJUjyU4ZXEfuoJ38oAnTe3XdUI2qaRxnFOaOj51MxIueQvl
         m0HsKldC/w0+pc9N7CghgjaadRphSewLvX6Iw/j0iE3Fee6JbQyIWuI7XSyndi7MxGA2
         9sRK2qI8QC2CwSFNJMKRo8SCAv40JorUg1esLmLbXiDQKUBEiBOK+lguyd5raqFA1GnM
         A5UjyqgP3+FP1QE3BXi1uhYlsZn7UE5g/vWhFPZM0/YzSDVlbOu2BVTZq07Wv/TLuj+F
         i+A+Ucpb407Qksz0tU0RkFupgKAGPWplgluhW6luRYuDrv6tJQDpwBnAlh/3kHd3a5fD
         NoiQ==
X-Gm-Message-State: ACrzQf284tqrRl6PW7Fdfm0hyQzyp7cIixngUFxaZ7+E7hiG4bWN4jgg
        jHhWSsSbetRIlKrGKhfLgpQ=
X-Google-Smtp-Source: AMsMyM4GX4ItzJGGuAlJUqetfYCp7J8nLGk9QyOzFApHZvUi96duqGJCsKXdh9r9hC2SYk8fRkJvsg==
X-Received: by 2002:a5d:64ee:0:b0:236:8f54:f180 with SMTP id g14-20020a5d64ee000000b002368f54f180mr4276986wri.559.1667121729974;
        Sun, 30 Oct 2022 02:22:09 -0700 (PDT)
Received: from [192.168.0.106] ([77.126.16.127])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d420f000000b0022da3977ec5sm3603988wrq.113.2022.10.30.02.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Oct 2022 02:22:09 -0700 (PDT)
Message-ID: <10d234a5-5200-c52f-1ab0-d1a3e0c731ad@gmail.com>
Date:   Sun, 30 Oct 2022 11:22:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH net-next v3 4/9] ptp: mlx4: convert to .adjfine and
 adjust_by_scaled_ppm
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20221028110420.3451088-1-jacob.e.keller@intel.com>
 <20221028110420.3451088-5-jacob.e.keller@intel.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221028110420.3451088-5-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/28/2022 2:04 PM, Jacob Keller wrote:
> The mlx4 implementation of .adjfreq is implemented in terms of a
> straight forward "base * ppb / 1 billion" calculation.
> 
> Convert this driver to .adjfine and use adjust_by_scaled_ppm to perform the
> calculation.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_clock.c | 29 +++++++------------
>   1 file changed, 11 insertions(+), 18 deletions(-)
> 


Thanks for your patch.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
