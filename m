Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518205B33C6
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiIIJ0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIIJZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:25:32 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5B7136CCF
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 02:24:06 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bt10so1709842lfb.1
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 02:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9J+1WVQD1UcE//aSEEupORtrrjIRZETKOH4UIIsXOJI=;
        b=XCY5gMtWw7aLwpv5gw1nT5n68ipmXfzivFfReqqTMOffy4NH6etHk19DSTjdCRxKTY
         mgylasdXOECYvaTv9YvsbjUHLYPvaHSFTAZt+CSzGoDOFOSz39v0/8jTpyWsGeJe6sO2
         18iV899t1OE1jf5czA31WaezmmOwDT2w/Xvp7dqoi7SKmfruVmheAqnnm9adNqef26E9
         LVbhM5BV2JtJPyl8K3wJtGFMpw+KNKOfaqsminVmAOeU+mE9nYV3SzTWYo5xrkGwRzF4
         drl9Y7jfP+gFoJ2mjjAxXGCK3FEFiKdpp+6fsCsqWJJduyzkZ3RXU2w3FmJdM59D3Hea
         +MsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9J+1WVQD1UcE//aSEEupORtrrjIRZETKOH4UIIsXOJI=;
        b=IQR7KhPRe9ntgZ5KWbkGJ+9j3Hc3CGFS0K8Ukn+EnCQ1iG9JdkSncvRYu2jBNvsaBj
         7X2gBnlDQOynQt0FD6YCmDgA4aw/wGk/9VS+6+OijEXcrS9dAwLVbQ1oII0Xz4+gCEIp
         S+6YfzyG0HVaTUmnI/2m22f11XDEP/jRkLQoFBXK/RIN8izOZDS+K6Qxzhbf0YIgbsaH
         SjbzhprwnKVVowECeQcbsI1kYZ5WIjSP0TQ7iPR13wKliotXjNFeZEzJgKVZoXqSIWvZ
         MU8YzxY+yT9JHjaTOI80SdxdjBlFXtMhppvSzUeWnwmUsKpdfZLzoz2OaoZld2YDit+9
         Co5Q==
X-Gm-Message-State: ACgBeo08aRUNHaWsNpISxoNpf36+2bCD0Jg8Cy/sVXgPv0Xl6pzK+IcD
        hm3oU0qGJBhBlUTWM65IKfmTXw==
X-Google-Smtp-Source: AA6agR5i8c0/xAwQZyOfpFUjiFgAMSXV5aQ5pKCB2wihwd5NwkJz0K5hc4cJqAMVHTz5mCxWyznk4w==
X-Received: by 2002:ac2:5f1a:0:b0:497:e106:e597 with SMTP id 26-20020ac25f1a000000b00497e106e597mr2911296lfq.135.1662715440655;
        Fri, 09 Sep 2022 02:24:00 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id u18-20020a05651220d200b0049771081b10sm12139lfr.31.2022.09.09.02.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 02:24:00 -0700 (PDT)
Message-ID: <d670b3b1-8347-7131-6bed-4c946645c883@linaro.org>
Date:   Fri, 9 Sep 2022 11:23:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] dt-bindings: net: renesas,etheravb: R-Car V3U is
 R-Car Gen4
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <cover.1662714607.git.geert+renesas@glider.be>
 <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2022 11:13, Geert Uytterhoeven wrote:
> Despite the name, R-Car V3U is the first member of the R-Car Gen4
> family.  Hence move its compatible value to the R-Car Gen4 section.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> index acf347f3cdbe2284..cd5998e08e2195be 100644
> --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> @@ -40,9 +40,13 @@ properties:
>                - renesas,etheravb-r8a77980     # R-Car V3H
>                - renesas,etheravb-r8a77990     # R-Car E3
>                - renesas,etheravb-r8a77995     # R-Car D3
> -              - renesas,etheravb-r8a779a0     # R-Car V3U
>            - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
>  
> +      - items:
> +          - enum:
> +              - renesas,etheravb-r8a779a0     # R-Car V3U
> +          - const: renesas,etheravb-rcar-gen4 # R-Car Gen4
> +


Don't you need changes in allOf:if:then section?

Best regards,
Krzysztof
