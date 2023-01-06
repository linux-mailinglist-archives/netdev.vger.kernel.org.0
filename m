Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A0A66005B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjAFMiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjAFMio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:38:44 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9953F687AC
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:38:43 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so3445678wmb.2
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OJ7xr6hqaFunxstN9Frwa743d6EY0RYUMvbu/BvcENU=;
        b=k533u49JmlzI9E0GmLi1/SbA4DHKKnuJLwcWPrk5dQCS8t7rkz+MHy08ABQhin/X/6
         JgRoDBIY7EFHGJgc9dMEvwbhzTO0xbC3ALki8QJnhibyoI2nI9CwYpQcqCg9P/fjNqCs
         KOGaNGKYtv0TvGzekX+Rn0gYaHJa96u63r2TCFFwoG5i49iv8XvbV92w7kwe2FydP22z
         7kn9AMzHk5eFhxiflGGLIWTzivhLMwSi6yQQpqwWwpjbXoQKRkw2MZsgbtZZ9iOmr5Qb
         IH6h6ZmVnSg3H5JJ2/HvwbK0bBIk4wLbn/xXWxNANNI6X1Kc37/4U42ZwinHarOws8PY
         bAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OJ7xr6hqaFunxstN9Frwa743d6EY0RYUMvbu/BvcENU=;
        b=osqMCVhE+Yrid5F7miD8Dp/3gW7aupAs9ttgVdTYqo9xamZC79b5EN2MrYm4z/Qf6U
         nb7ruI3SQo8DjEHmuRMQ34/tDReyqYmsX7NPtTye1Lqhk/mP4QTE4XbaYeIDQU4N0lPi
         SkC8ksIbaoPwePA5+0rB521LFA8DlF3v5v2fV2C9/HE934hzB4hSPcYJCGbd/QPUhCcc
         txLzXCynFm63gR9uCa5uWlu+aVCvTBYIdsDXXGh4GD+ga54aVVA33hj5d4kT7dBsy/fD
         QoebC69GXfk8TcaIgBDTKRWz9Chju6FEhxiPceqjgHyqhySKwcwm4F6MtRWFWzS0sBOF
         p0Pg==
X-Gm-Message-State: AFqh2kqtxqRIN6p9sVhpHZAHNb1HEg+Uv/1FwrFmTiPnNZMCl8lBBziw
        YcTGWqY9vK/N7caGygTbF6jneQ==
X-Google-Smtp-Source: AMrXdXuDF8odo1Q4/ENstUcn7M+3KtSn24l85y5PF2Bz6Wp1IzYdkylooKFh18FcHa+t5fjNy1Ng1A==
X-Received: by 2002:a05:600c:5012:b0:3d3:5a4a:9103 with SMTP id n18-20020a05600c501200b003d35a4a9103mr38570557wmr.31.1673008722161;
        Fri, 06 Jan 2023 04:38:42 -0800 (PST)
Received: from [192.168.1.102] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id s2-20020adff802000000b00241bd7a7165sm1025445wrp.82.2023.01.06.04.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 04:38:41 -0800 (PST)
Message-ID: <80c9fac7-36fe-293e-62f0-945515b8f481@linaro.org>
Date:   Fri, 6 Jan 2023 13:38:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
 <20230106030001.1952-3-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230106030001.1952-3-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2023 03:59, Yanhong Wang wrote:
> Some boards(such as StarFive VisionFive v2) require more than one value
> which defined by resets property, so the original definition can not
> meet the requirements. In order to adapt to different requirements,
> adjust the maxitems number definition.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 36 ++++++++++++++-----
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e26c3e76ebb7..f7693e8c8d6d 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -132,14 +132,6 @@ properties:
>          - pclk
>          - ptp_ref
>  
> -  resets:
> -    maxItems: 1
> -    description:
> -      MAC Reset signal.
> -
> -  reset-names:
> -    const: stmmaceth

Do not remove properties from top-level properties. Instead these should
have widest constraints which are further constrain in allOf:if:then.

Here you should list items with minItems: 1.

> -

Best regards,
Krzysztof

