Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B31955AC87
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 22:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbiFYUSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 16:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiFYUSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 16:18:37 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72C613F7B
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:18:35 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id e40so7880361eda.2
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vzewte8MtMWVwJWHnEGSEVk2W35vpxyGLjDSNXmoDZ8=;
        b=hhq6jEDvAOzm1zWMH7z/JMsPL8YRvwUjxT6pXMKfdtDi+xFDCwLaylzHRKcZz9k5i9
         fN9XteIpHlwkIOkMtZ9PuKIgW6FbR7C/wARqoRt0nw6kLRVryGznLOav1I3A31MpX0Kv
         fZv9VdY9EMlIo5iIvru6rC5bujBnEstciEImtvDpuNAVrfFKGUXQ6sWoyg1JztZ/b4dN
         XEiDDE8HmZpMcnlw8yCrv6RJdF93s68yokt5qGPch6VGIQaLcrz4veawt4HrycS0d1Sv
         mop5INBTe7HlaRmftTLPc625baTj6gvQQO6Iog75Z7Yqr09zmm7+/i0ls5oNkt/kOmim
         rI1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vzewte8MtMWVwJWHnEGSEVk2W35vpxyGLjDSNXmoDZ8=;
        b=UcOrOcVOUgLq7266Qy4pTz9HJC6jg9V9WhkpzZXOP99WdvLJonGpQKTuQCrHnxdsdQ
         rb0rW+37U5UyhzMLYT04GoY8eESu7Xi2497vghfA1Svtp4CYc3RwnoIUATMtqLgAllPv
         SsuDdkcSFm7SXvGhFqjpLWkymZSh6T13nmTXXVN50YtjI6q5wo6INY5QjUNumtjAb4A4
         kR4wj+ayoKi5PIDAJ7YsBijjGMmHKxYSj8FydktNadIoiegBTh9bN6P6aI8K/mODniNy
         x3s/CvMpt5iYRzeO16VBCeMLBPuJdvCulaS3HZw5wpufGDf9RHzxmTq3NdVs9GrURk26
         cTvA==
X-Gm-Message-State: AJIora/CJt/1nTNttI4QEFxWIIx1YJU1Hl7Hg4Nm6tIRLaUoThfvQ5ZH
        eROekNpuLvnmi2qYIRLjaEV6f48HZpN11A==
X-Google-Smtp-Source: AGRyM1s3rVR9cr96dysg7bldvesEoN5+h0nXdLSHlyd9fQnHdIwlEKHbfFROnfIHwVIWoPcOeqiQ4w==
X-Received: by 2002:a05:6402:2422:b0:435:6707:7f1f with SMTP id t34-20020a056402242200b0043567077f1fmr7184415eda.38.1656188315414;
        Sat, 25 Jun 2022 13:18:35 -0700 (PDT)
Received: from [192.168.0.239] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id r19-20020a1709062cd300b006ff802baf5dsm2986752ejr.54.2022.06.25.13.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 13:18:35 -0700 (PDT)
Message-ID: <a37a344f-88f6-19b2-96ae-df46bc901b9b@linaro.org>
Date:   Sat, 25 Jun 2022 22:18:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v1 4/9] memory: tegra: Add MGBE memory clients
 for Tegra234
Content-Language: en-US
To:     Bhadram Varka <vbhadram@nvidia.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, kuba@kernel.org,
        catalin.marinas@arm.com, will@kernel.org,
        Thierry Reding <treding@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-4-vbhadram@nvidia.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220623074615.56418-4-vbhadram@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/06/2022 09:46, Bhadram Varka wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Tegra234 has multiple network interfaces with each their own memory
> clients and stream IDs to allow for proper isolation.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> ---
>  drivers/memory/tegra/tegra234.c | 80 +++++++++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Dropped from my tree.

Best regards,
Krzysztof
