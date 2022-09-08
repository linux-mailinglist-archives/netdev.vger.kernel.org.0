Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391F35B1C6B
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiIHMLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiIHMKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:10:37 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FA864F3
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 05:10:34 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id f11so13364703lfa.6
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 05:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=bVFfN/0QOAoeQEvO/xXmj8KiPeuyZ35f/xifeOzWA5s=;
        b=NRSeF0Lru/4IsPPkWju4xOeeyFhe0Qb8HKox/cFl/6AOtHqkRMjuDaR+ODUbL/Ffd0
         KKR0X4RxRZlTHwawPnlpEZ++/T9BlAvMeu77WACdv+mYCxj1GJvqsF6SiC1FibIHOTTJ
         G+1KHvx1KsSLfxcXAYjQcXF+0IfubsSFO737azWXB1PC+HtDXb7WYReK6waLNzcNLaWR
         1Fs4RqwdZ+CQXRs+i3yGisXzmWgCmaUwtoUOQJRVA8ZA4/JfD53ugh2iTaKjZ34VgDOd
         d2Gx9ble9bpol+/kFpUZ8Y1aXX53HjK08RXI9fx8eeAMpezvIYQwOJiqRaoVPSfpkFh9
         Jd8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=bVFfN/0QOAoeQEvO/xXmj8KiPeuyZ35f/xifeOzWA5s=;
        b=SVCP6jUWXfA/Su+ir7tCGeIO5BipD6nX+LX56k+NBP265ShFRxU7D8kG/rZqEX4ilc
         hhTEXokuGBorys1UugBWHd0JKaowDow+s+9pQRJqdg8vFc64/jZniaZSkHP0vhmwH7Kx
         qNWRx1EpsCVmEZfb4vjTH9r/1jNLs2wiNZwzS8hczQNO7dTH8ASx9JgOvKQTKgp3AGtP
         gIHWHA52xn8Z/2T6FM5tzhrh4Om7Jwp0jHtLN6PUAhm8lVaC8tZzF/ZJLSvo8IVd7C9J
         DuXDNHRNGh2i+N1TN8n8GvyGtT7w46LcafQo5HSBIY0Llkrq4QhCLYawJnKJqMbVgWcp
         ixeg==
X-Gm-Message-State: ACgBeo2ri0DdNhvh1f2/bw0308WAZhdlKnpLdinjgRaFNNS/fz2QylUB
        YB4azWekTYVlcstQS/ni6Q95RZzFLGpBJg==
X-Google-Smtp-Source: AA6agR5mIdcRh+FAs8EMoAtW68Mdhp0fAfd3lvimm/cRWEeKfsZ5j01hjDnJI2AreVtKkuKmPJYCFg==
X-Received: by 2002:a05:6512:3406:b0:494:9e2a:cbd with SMTP id i6-20020a056512340600b004949e2a0cbdmr2667654lfr.635.1662639032477;
        Thu, 08 Sep 2022 05:10:32 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id o12-20020ac24e8c000000b0049482979fe0sm3011006lfr.179.2022.09.08.05.10.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 05:10:31 -0700 (PDT)
Message-ID: <c798e387-caf1-ab7d-305a-7f7fa8e98749@linaro.org>
Date:   Thu, 8 Sep 2022 14:10:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: fec: add fsl,s32v234-fec
 to compatible property
Content-Language: en-US
To:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220907095649.3101484-1-wei.fang@nxp.com>
 <20220907095649.3101484-2-wei.fang@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220907095649.3101484-2-wei.fang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/09/2022 11:56, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Add fsl,s32v234-fec to compatible property to support s32v234 platform.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
