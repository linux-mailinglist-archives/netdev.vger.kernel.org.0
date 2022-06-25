Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F9355AC8A
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 22:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiFYUSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 16:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiFYUSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 16:18:22 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B57413F47
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:18:21 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id e40so7880361eda.2
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gyXE165H8su3Mb9u+C47L6hRDPnkCPdn2RUMPpfaTRA=;
        b=Mw3DJRqeQDK4Mt0csdppDgi50vOzVjUHrRN0jJ71rRxeJ6JkL9uI5nUts/unmXlZTl
         uiaagBYapoa+iNKG2j1F8/dUkMk83IZCslsFb9U4xgBJw5UhEgvpjkKnYSgmJFZEkffY
         BEmb6AGh8l4h9DD1H8+X9rFzmVxRWihZkdhhSuoEDwR/VAmBgBkHRyX2fzvCSUsHUEJC
         SKJT5l5H6Am7OE5kdCJZfqCoIC0qpW2MY1LdQ5ByeMAJw7Dit0Pll7iytdX0sNvIbWTh
         GES0zTuLla8yRDluBXyUQyUIesSz5xEv4TpYKuUIrI53OYLyQ93hlLYs9ug6XD/wlM9X
         vO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gyXE165H8su3Mb9u+C47L6hRDPnkCPdn2RUMPpfaTRA=;
        b=pmpjv3ZVXtYqu3HuygH89FBgCD7ip/9vRzIc5UB0BWKlJJcXFDi0/DogihlT17Idn9
         AhSjl9/cQQJglFFouiRTWizKdTXifvtt6iXmNFYtBFtxW127ocJjmHo3JNeaFLI1uAXx
         eJFtqVK3YWjVzqhKDv3p/KxUHbq/sUkAACuIMFvaMVxVodCDU+DpmlC4G8qRx/nS/zx1
         dlP/Sbl5ewlubiuVincU+3W6bNiS8pF8r4+2LsgH7ylh5FvzPS4IcG24baMGVYMIJliv
         /XpYCicg1qCj87NUSkWGZ+d7CxQcFCfvVRsFtwQDMmqZgRaLVww1RO3cW1Ttfqs9+PSd
         OXeA==
X-Gm-Message-State: AJIora/QerRU9+vYJfJ1RArZZfkSYHmvPExhJJZC9aMubta9bdpEELCI
        OnRCDB1NGP0to5cHqBoeNwSNaQ==
X-Google-Smtp-Source: AGRyM1tEqv+GS3AHgEL5Sw5OB74PdpfD1udvuzXpG41dMyK0U6malxhqkn1B40mgy4sTrE5KmJTs+Q==
X-Received: by 2002:aa7:c14f:0:b0:435:7b75:fd06 with SMTP id r15-20020aa7c14f000000b004357b75fd06mr7050404edp.352.1656188300195;
        Sat, 25 Jun 2022 13:18:20 -0700 (PDT)
Received: from [192.168.0.239] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id h6-20020aa7cdc6000000b00435720b7a1csm4635809edw.20.2022.06.25.13.18.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 13:18:19 -0700 (PDT)
Message-ID: <8237565f-e9a2-75ef-e9b8-060793fe42ee@linaro.org>
Date:   Sat, 25 Jun 2022 22:18:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v1 3/9] dt-bindings: memory: Add Tegra234 MGBE
 memory clients
Content-Language: en-US
To:     Bhadram Varka <vbhadram@nvidia.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, kuba@kernel.org,
        catalin.marinas@arm.com, will@kernel.org,
        Thierry Reding <treding@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
 <20220623074615.56418-3-vbhadram@nvidia.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220623074615.56418-3-vbhadram@nvidia.com>
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
> Add the memory client and stream ID definitions for the MGBE hardware
> found on Tegra234 SoCs.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Dropped from my tree.

Best regards,
Krzysztof
