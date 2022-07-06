Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1D7567FF1
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiGFHf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiGFHf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:35:26 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F60722523
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:35:25 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id bx13so17374327ljb.1
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 00:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a7SBBN/6Q+yYGFLJGBFyvXLFrv4d27155jl/U2Ur7OU=;
        b=F1H6LB8Y6yov5/czicr7HsJnGPkDH06fqWNhCEVV7n84eMzbdFz4E1J+iwIlM54OGz
         XYqaqAknMiiuAxR4G+1mTV95uJNT0lmYpXIY9bGcIC8oPAFNKuE+qkAZywYdW+bubuG2
         ufH/miJCv7ZU668lxDjY3qFGpmcm4qLHutXldBciUO5W4CrLgTI9V04QbNlX1LvVbHpz
         kwWKvGJnTCGzVj5Gb5/MbD7OWnikjIsZxmJkv9T1f/mEVdMUA4ZytftP6iGl1J05o+w/
         D00o9VMooe1JwRbYenhN//RUBN12zaQXvtp9zaO4tUq3gvpmDg54E5j9IIvTCh5pf97C
         pi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a7SBBN/6Q+yYGFLJGBFyvXLFrv4d27155jl/U2Ur7OU=;
        b=0CDA+t4NkBdXDFp9BeylCZDS4FLQYq39vgiL2+hWjkjTFv9IR8q4xCh1W8RMgPj6dc
         dKbB8xrfvIV3/AengkHYZe2kz1ejqDtBddyAnYqmaOzi4y/bVn2xoYZEZNzFxCNkuzlU
         x0n0bwJfUQInI0g4nySZrvv1FODmM639xVAxubRfMZBI29MJnbWf/E3Dg+h/6C+Oe5+1
         QGqVdgXXFX5gGoCusp6/uGI9zsMSxfT4kqrGw36yIzHUmeknIAxWFNkSS00bUqQk0PjY
         vTd0AxjZmmcwca8omR22oxNDFfsQTA5VocQAX1Lyj4VZ+5JRzh7hfjpsoV0QtMkwGDYp
         CSCw==
X-Gm-Message-State: AJIora+cjoRRI5m5hZywsZSaA4LpCVvSVKS5HTFVs7KcvoyNluH7qgm6
        utfDXNTnu5N510pc82KqEhVUYg==
X-Google-Smtp-Source: AGRyM1tIy92y3ezGklgrGYEunVuaUNyqnih+pWX3z3d8xNohinEwVOLDFyHAYMksSn+6bCvc1o481g==
X-Received: by 2002:a05:651c:10b8:b0:25a:9bc0:2110 with SMTP id k24-20020a05651c10b800b0025a9bc02110mr22950012ljn.234.1657092923638;
        Wed, 06 Jul 2022 00:35:23 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id o18-20020ac24bd2000000b004811dae391fsm4662801lfq.48.2022.07.06.00.35.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 00:35:22 -0700 (PDT)
Message-ID: <708c4a86-731a-c2a6-e3d3-df23ae7c35b1@linaro.org>
Date:   Wed, 6 Jul 2022 09:35:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 1/9] dt-bindings: power: Add Tegra234 MGBE
 power domains
Content-Language: en-US
To:     Bhadram Varka <vbhadram@nvidia.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com, kuba@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com,
        Thierry Reding <treding@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
 <20220706031259.53746-2-vbhadram@nvidia.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220706031259.53746-2-vbhadram@nvidia.com>
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

On 06/07/2022 05:12, Bhadram Varka wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add power domain IDs for the four MGBE power partitions found on
> Tegra234.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
> ---


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
