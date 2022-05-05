Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190A251C447
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350459AbiEEP4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiEEP4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 11:56:02 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFA74A3E5
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 08:52:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e2so6672195wrh.7
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 08:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p4tJmjTzOdygywlYP1yY6w1fINN3MsUD0kcDgzgpI6M=;
        b=UjbGqjL9FIFq6T708yPTkxhWiRcego6swzB0e5wRzIfkAPsJvum6EyjVluqgjJfon3
         YVGKf6LDI8OJNBnfNIkzfxUDQpz0ZndfJh0dQtcF2/QeOHoa7z1pxfoqYVdETsCYnmEI
         LJEhT9ZkmsIFaXjxZfgEzDI6u5zNuAOxZXytloaByT33P5sGgrvi3m+4SsL3DaZIgUCf
         +65LXeujOhSI15I4EoJOV/bXHixHVxfJNLgbkiuo+WKzR/RmDOw5ImEVwcwRMDE28Fdm
         FeO8rIPKFNwbpDbFug4OvcTOMOeMzB/0bh2JcXLqZjugWVccPUTtuT3ucNkNLrK+FoKX
         wQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p4tJmjTzOdygywlYP1yY6w1fINN3MsUD0kcDgzgpI6M=;
        b=H2JNSuswfR66TLqHMXuwYChd7zKLf91tzsHhzuQZrYxHhAnN+XCxT7MIYiLwJm5f4/
         s4GNEXee4IbIw9T9QCwSD34bZmKftjJnWnwonVbduoVWMBfOod0ojXsP4vYO1/osYY5o
         U52nC0PvS62jaOVmLs/VkWODB0Urti2/lDXp7PNed3j9mYhrpG20xE/FR+8c+jqD4A3R
         ssx5/klQCbelAdwwLtvpD4oXgQMRx7QVN9gHkx6y1Gi+xGvi1F7O+6l2BDVGtvAw6Y1z
         EWiJRBPK5JzpL1zRm7grtLPTC7yUw/myZg1Nmo9LDdZpzaSrIIfCv7EY3HVGBSFtmKpy
         y+3A==
X-Gm-Message-State: AOAM531h1RMs1sbKnvmIq2z4HT+mhMnwwSO9U3XQU+/iKQrQ7jkX9foH
        DZ2TpJHTeRDGdZAPZoMVCKtuT31q7mOblw==
X-Google-Smtp-Source: ABdhPJwZP9yBiGLGISimyEerRTZbp+dugHH5r28q/49lxryTevbEUGW++Bqzk2T9DeP10f4dKMLlkA==
X-Received: by 2002:a05:6000:1a89:b0:20c:613f:da94 with SMTP id f9-20020a0560001a8900b0020c613fda94mr16253496wry.356.1651765940992;
        Thu, 05 May 2022 08:52:20 -0700 (PDT)
Received: from [10.100.0.58] (bzq-162-168-31-21.red.bezeqint.net. [31.168.162.21])
        by smtp.gmail.com with ESMTPSA id f186-20020a1c38c3000000b003942a244ec9sm1998120wma.14.2022.05.05.08.52.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 08:52:20 -0700 (PDT)
Message-ID: <d19efad6-16e5-0b7e-de89-97d008afff33@solid-run.com>
Date:   Thu, 5 May 2022 18:52:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 1/3] dt-bindings: net: adin: document phy clock output
 properties
Content-Language: en-US
To:     netdev@vger.kernel.org, shawnguo@kernel.org
Cc:     alvaro.karsz@solid-run.com, Andrew Lunn <andrew@lunn.ch>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-2-josua@solid-run.com>
From:   Josua Mayer <josua@solid-run.com>
In-Reply-To: <20220428082848.12191-2-josua@solid-run.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shawn,

Thank you for looking at patch 3 in this series, in case you missed it - 
the adi,phy-output-clock property does not yet exist in bindings, I am 
trying to get that one added.

Am 28.04.22 um 11:28 schrieb Josua Mayer:
> The ADIN1300 supports generating certain clocks on its GP_CLK pin, as
> well as providing the reference clock on CLK25_REF.
>
> Add DT properties to configure both pins.
>
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> V1 -> V2: changed clkout property to enum
> V1 -> V2: added property for CLK25_REF pin
>
>   .../devicetree/bindings/net/adi,adin.yaml       | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> index 1129f2b58e98..3e0c6304f190 100644
> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -36,6 +36,23 @@ properties:
>       enum: [ 4, 8, 12, 16, 20, 24 ]
>       default: 8
>   
> +  adi,phy-output-clock:
> +    description: Select clock output on GP_CLK pin. Three clocks are available:
> +      A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
> +      The phy can also automatically switch between the reference and the
> +      respective 125MHz clocks based on its internal state.
> +    $ref: /schemas/types.yaml#/definitions/string
> +    enum:
> +    - 25mhz-reference
> +    - 125mhz-free-running
> +    - 125mhz-recovered
> +    - adaptive-free-running
> +    - adaptive-recovered
> +
> +  adi,phy-output-reference-clock:
> +    description: Enable 25MHz reference clock output on CLK25_REF pin.
> +    $ref: /schemas/types.yaml#/definitions/flag
> +
>   unevaluatedProperties: false
>   
>   examples:
- Josua Mayer
