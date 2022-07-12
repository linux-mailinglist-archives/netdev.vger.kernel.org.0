Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7549571507
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 10:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiGLIrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 04:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiGLIrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 04:47:51 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8284A6F20
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:47:49 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id m16so9065491ljh.10
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 01:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BoX+rp4PoiS5Atec4w7HqPMg4nXltL8P8j6D72BzscY=;
        b=sMoxnxlbxggNYM8BAq2Lcy19LzB6d3G+PJ0RClZQVELEnW4CL9uBpEkIPB9Ijg0XTj
         xrvFU4Fp+xf5KzAG5/YmhTAHbgd6nxxhaj7oY2XoAGi3zDqrolEC4MAjDU3hxPioaLlX
         F7TE0AMpMwjTPwRXFlXuXuQFY524HfhbYHo+Vb4WeaptAATCfJFtr7ZA6xL+KLJKgJpH
         JNcO9XyTNzXxf0LoF+6vvFgOyqqdLnamHLmLvfiBjgYHO4cLSTe9jVs5AA6pYPoAdoD/
         plB2usym8nVYcM+zQoWxtpcSeWef7tI3LuMUDk4xKDqxLU3HBsq/LJEBepaaBXbrecF/
         vscA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BoX+rp4PoiS5Atec4w7HqPMg4nXltL8P8j6D72BzscY=;
        b=XMa5PnaaPb0h39H4GL6XLn/QjdR1m7Fg4TkT+LCKVHwAWx0PNec6ooe1QNeGt3DbI2
         OEj8GgnMpPIiSsJrUARZkfIca4SfxS9CjpG1Det+YKaaOYOcDSmWHYtNLtUBKykE61Qk
         eYvEpa4JFy+2TDfD0ubgYx9LqB81Fju6Z+5q11AGX+2Tk8kLFci9S55L9u5YuMKBqINm
         AVYPout5ZmTlE+BA2St1yr/Z6vEryZW5ECjo5ZJLtkNrM55FidGeaLmNvpox6XzrhvEg
         aSyp9NHTfpYbnfNrbiI9C7YwydyCrPHqyw6xcmj3IPkcChdlkoqez3VBQbXlak1fB8Sp
         EFQw==
X-Gm-Message-State: AJIora8aejha2w9zkfdPGuQKONUcJAW9ZgNq5PHMfy6/xTKoGzAU3j5r
        iYCdFNJ0X/utvsuO6IlBiZlwAw==
X-Google-Smtp-Source: AGRyM1vNKk2hrAz+F5i8IgmeZ6aMdIA8yvFym7dtAAyKnTQEQaOnXisA+5/D71f6YI3DToiYzV6C8A==
X-Received: by 2002:a2e:8303:0:b0:25b:d18a:75d9 with SMTP id a3-20020a2e8303000000b0025bd18a75d9mr11995412ljh.495.1657615668155;
        Tue, 12 Jul 2022 01:47:48 -0700 (PDT)
Received: from [10.0.0.8] (fwa5cab-55.bb.online.no. [88.92.171.55])
        by smtp.gmail.com with ESMTPSA id b40-20020a0565120ba800b004785b66a9a4sm2063432lfv.126.2022.07.12.01.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 01:47:47 -0700 (PDT)
Message-ID: <4584120c-8e6f-6943-1bd3-aa6942525eda@linaro.org>
Date:   Tue, 12 Jul 2022 10:47:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: Add lynx PCS
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-2-sean.anderson@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220711160519.741990-2-sean.anderson@seco.com>
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

On 11/07/2022 18:05, Sean Anderson wrote:
> This adds bindings for the PCS half of the Lynx 10g/28g SerDes drivers.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  .../devicetree/bindings/net/fsl,lynx-pcs.yaml | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml
> new file mode 100644
> index 000000000000..49dee66ab679
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/fsl,lynx-pcs.yaml

Shouldn't this be under net/pcs?

Rest looks good to me:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
