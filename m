Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7960C633B32
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbiKVLVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiKVLUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:20:41 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB14311A03
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:16:20 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id u2so17589255ljl.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JKvNIqtJJoziS2PU4jrCDFbOU8Mp2coPwVqeIhe+rk0=;
        b=okkFIaM7+0Mvh/KCkMWNjBjMq1JBY6CUEKU0tK39Si1PxhytV061cLghpHYhV3xoOm
         c4ZmlkdQCRLyXj/G5OUnS98HYJGosmySex2EQh9O6hhcGOrsB8gIGP/OOV5tPESbizYD
         itYBBm9OlK+DUNStHFkZaG80jKfKFkeLIV1kVbf5n3aSVdRf3uU0ERg1V0pD95Lg97bT
         BqVpHitV/t7bN5NePN3bkWuKCDWgNjNcHZrh6iMs5MtoRYueYJ6mPc2240tHut2nrUmO
         GI+OrAdmTWAbLy9OlOnXvhrJOtDV530wJoJTwEmHHLQxxT4epRlnIzHzwpUW87Rn4A32
         gXkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JKvNIqtJJoziS2PU4jrCDFbOU8Mp2coPwVqeIhe+rk0=;
        b=1atrR/b6qn2Vf1GFh2TjXUkDer3L1F4knn32ZVGrliEiQTifFnY5jOxq8qTRUehvDw
         9ms5yg2u8nyQCAXQr0K6sawTcnEAilFKct2L7OovnDxS8MCQMQPWXrWamlCAaH0IF4NO
         /rwRVHF50a0yJK++fhyIhDWuVo3qu4PMCOH9H3383QfduNy2EEfFi6Nt08lEci60+6Gg
         ZSVlmee2zoDPMUnVeet/A+FlAxfwPW7gJVFL+xOptdzjBMbkSB2wFcNJcgdg1B5CBtgj
         u1FPCF5Dksi/vSuvIQyYgzpHF/ez/ZfYZWjL9j5tm5Higq+VmRvGWw50QsYchIqZ3fE/
         ke2g==
X-Gm-Message-State: ANoB5pkfIiUAyIRacYLOf4xfjB0TuYO9BYetOlsJHMXO08tRuoZU67Wo
        GLA4HUVgTW0GcRY6j/raSftrXw==
X-Google-Smtp-Source: AA0mqf68tplXdKwK4DxvYDgno0eR7cLvgAlDket0NKtk1pb5SqvhEn48MghZUrYZTCK5dplnhhh+qw==
X-Received: by 2002:a05:651c:2050:b0:278:eef5:8d17 with SMTP id t16-20020a05651c205000b00278eef58d17mr7417802ljo.205.1669115779159;
        Tue, 22 Nov 2022 03:16:19 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id q30-20020a19431e000000b0049735cec78dsm2427871lfa.67.2022.11.22.03.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 03:16:18 -0800 (PST)
Message-ID: <9087a472-19a5-f8c2-3d2b-a838bb1c6d96@linaro.org>
Date:   Tue, 22 Nov 2022 12:16:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net v2 1/3] nfc: st-nci: fix incorrect validating logic in
 EVT_TRANSACTION
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@google.com>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-nfc@lists.01.org, davem@davemloft.net
Cc:     martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        sameo@linux.intel.com, theflamefire89@gmail.com,
        duoming@zju.edu.cn, Denis Efremov <denis.e.efremov@oracle.com>
References: <20221122004246.4186422-1-mfaltesek@google.com>
 <20221122004246.4186422-2-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221122004246.4186422-2-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2022 01:42, Martin Faltesek wrote:
> The first validation check for EVT_TRANSACTION has two different checks
> tied together with logical AND. One is a check for minimum packet length,
> and the other is for a valid aid_tag. If either condition is true (fails),
> then an error should be triggered. The fix is to change && to ||.
> 
> Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
> Reviewed-by: Guenter Roeck <groeck@google.com>
> Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

