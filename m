Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5ACF590C88
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 09:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiHLH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 03:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbiHLH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 03:28:06 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3A289805
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 00:28:05 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id z25so246679lfr.2
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 00:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=bhgmVIMSR6aro90bfc2C/db0hRKG+K1TQjCAcAiHupc=;
        b=eIQyE6pAux7feSR/IdAkk/Xi7++Szw8nwQarhE8q7DVBWNYQ4Pn9pON6SljdEO5Z9r
         k0CwQTzAQ5WwNSgMb3Xrhhw1E6/p7a58ynGrAr9HOrVkeYdpIABSZSv4blgwVtkCwAzy
         qjoytJGtdhH7qNg1PlwzO9fnxmJZyy9KImhaXLEMP8G5BQHupljeBMYJylOEHCaL16sB
         sxzIrWVR+bz1GFf6wy/BX+klwk6ATI1/0D5qNKnZE7Lf2moeqZOah7apTmoRXS7iJ5NL
         mtNcTjQaDk8X88x5DYIeth2NvYY7NRd7KeqD+rh41+1BCSzGUQgvl1l0gUKElnKoswex
         bO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=bhgmVIMSR6aro90bfc2C/db0hRKG+K1TQjCAcAiHupc=;
        b=co2TNK79FI/G6Ibn9xGpz1oNHUgGWgtQg9Dn1x93fgbhV05KX4zLujO/1r1f3TWfy8
         /YBOXHrLbe+28H2801cMsgLPhVk2cPrGoTSckOsE4Dlp2xJGpStyY5EKFvSVKbvzRbcu
         AnApOn407+uZutxfluhXZ5fNayx7NVEVoV63/5SfCgcxdz+zNT75dA5/ehvRiY8Y/56r
         hA8gtcXIYiluJDA2kU+fdJIY/Ei6MLTvzfd5F+agAzvDek5SpZlDv8ncQDlJLBdNJcFl
         sDtbojBXxDaZEpZ5uraLFRjDXPBfyC3TXmnMfqoLsmbibvQBrQpWua93/oz9ZJPDRekA
         C0Rw==
X-Gm-Message-State: ACgBeo2c6YStb+OxPIdic99ZmNpfoy0hiqTiUEZdpbp1uReBpsj7I4GV
        68qzu/Pm4+0cCnyYgdcRul8Mkw==
X-Google-Smtp-Source: AA6agR7MHpcoF/FPKb8X8c5DMwQ/zAw+IycliLWcWOxcmjaENKaOXZ6i6JvtLLTs5eo+Tcf0nKBS5A==
X-Received: by 2002:a05:6512:3d09:b0:48b:9512:ade3 with SMTP id d9-20020a0565123d0900b0048b9512ade3mr951083lfv.390.1660289283758;
        Fri, 12 Aug 2022 00:28:03 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id r13-20020a056512102d00b0048af464559esm110538lfr.293.2022.08.12.00.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 00:28:02 -0700 (PDT)
Message-ID: <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
Date:   Fri, 12 Aug 2022 10:27:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Content-Language: en-US
To:     wei.fang@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220812145009.1229094-2-wei.fang@nxp.com>
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

On 12/08/2022 17:50, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 

Please use subject prefix matching subsystem.

> The hibernation mode of Atheros AR803x PHYs is default enabled.
> When the cable is unplugged, the PHY will enter hibernation
> mode and the PHY clock does down. For some MACs, it needs the
> clock to support it's logic. For instance, stmmac needs the PHY
> inputs clock is present for software reset completion. Therefore,
> It is reasonable to add a DT property to disable hibernation mode.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/qca,ar803x.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> index b3d4013b7ca6..d08431d79b83 100644
> --- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> +++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
> @@ -40,6 +40,12 @@ properties:
>        Only supported on the AR8031.
>      type: boolean
>  
> +  qca,disable-hibernation:
> +    description: |
> +    If set, the PHY will not enter hibernation mode when the cable is
> +    unplugged.

Wrong indentation. Did you test the bindings?

Unfortunately the property describes driver behavior not hardware, so it
is not suitable for DT. Instead describe the hardware
characteristics/features/bugs/constraints. Not driver behavior. Both in
property name and property description.

Best regards,
Krzysztof
