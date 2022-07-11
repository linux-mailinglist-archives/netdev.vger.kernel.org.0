Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5E057009A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiGKL31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiGKL2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:28:45 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E282126E
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:10:08 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a39so5749315ljq.11
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CwMzSSLpH+aj90Dwdocvfg7IdUBiIvzvhVJGANi/6ko=;
        b=udd0Bn6bYPki1268sfcfI92FafXnNcAe4yw+j/r8lCoL8KHHeD6RiFmJsUV8eQ7NMc
         5b6OemntVQBazWP4i+GeRr6J9dxi6aUi9R6zFCT2rvsdNhW5xxT1N0KsOvJk5reIw9M/
         jCC7TjrgC6YroHv1abHYGf7BESEg9dGT9sLDLyFK+avPDYJbsiQ4chaB+Y37ANvTD+S5
         VRfsoDtXAZ6DrMehY9m5pigg761UIn9I6te07GkxVsP6ZifOUdgatADNlCytw5Dfmsou
         /9+s/L2bX9/p020rQolwj990/4M/lvgc0nHhLQ1t3aw47vCsEpXnurwY73CXMeD9PSbv
         w9hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CwMzSSLpH+aj90Dwdocvfg7IdUBiIvzvhVJGANi/6ko=;
        b=pz5lKLs/CIb4P0QZdAEpA+vFf4IZ8J7/qvhfHLbYqoiiOOhqi0rCvM1lI4umRFLpsH
         /2XwW0dqcRPQFPbIHhhxTTKsqZPHe33lMOiJfE5yk62aT7KtcdrmqiAC4K4083B7Ll8A
         PnsMrHsnaMO4JHZpYwTbaiuGW73eeFng5jzXrwsO7MRoMkGVTl/3IVHjEqCt1XQBuCd5
         GvhH3R4ZvGvEQ2Vu66ifEbgy0KAh9fhfcID8eii7CzY/GQL3WOYpAdP0S/7CMHV6R34h
         7bwRseLVzvNXaxdfooGnAwaA0u9Y7hl8TU0M7xIM9VCLbv/0nGqNlSHHpAsV15H9mro9
         O3Ug==
X-Gm-Message-State: AJIora9Du53+/LPkUEw4lgJ8QbXUnPZZPn2SscWzr4+5u1Z5qJ+vvqkv
        2tdnIb5OxNDKd9er2KEkodQy1w==
X-Google-Smtp-Source: AGRyM1tUM4IBHR6wLqodtqPrZdRq4L3MNuGgWRZCbtt6l5ucx+jlCLUDkBS2b6cuADfWiiTtTIgG8g==
X-Received: by 2002:a05:651c:19ac:b0:25b:db26:55c3 with SMTP id bx44-20020a05651c19ac00b0025bdb2655c3mr10176580ljb.457.1657537806762;
        Mon, 11 Jul 2022 04:10:06 -0700 (PDT)
Received: from [10.0.0.8] (fwa5cab-55.bb.online.no. [88.92.171.55])
        by smtp.gmail.com with ESMTPSA id k16-20020a05651c10b000b0025d53872749sm1642690ljn.69.2022.07.11.04.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 04:10:06 -0700 (PDT)
Message-ID: <0558287a-1700-9d8a-c95c-9516ef86aa12@linaro.org>
Date:   Mon, 11 Jul 2022 13:10:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V2 1/3] dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items
Content-Language: en-US
To:     Wei Fang <wei.fang@nxp.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
References: <20220711094434.369377-1-wei.fang@nxp.com>
 <20220711094434.369377-2-wei.fang@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220711094434.369377-2-wei.fang@nxp.com>
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

On 11/07/2022 11:44, Wei Fang wrote:
> Add fsl,imx8ulp-fec for i.MX8ULP platform.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
> V2 change:
> Add fsl,imx6q-fec
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> index daa2f79a294f..4d2454ade3b6 100644
> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> @@ -58,6 +58,11 @@ properties:
>                - fsl,imx8qxp-fec
>            - const: fsl,imx8qm-fec
>            - const: fsl,imx6sx-fec
> +      - items:
> +          - enum:
> +              - fsl,imx8ulp-fec
> +          - const: fsl,imx6ul-fec
> +          - const: fsl,imx6q-fec


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
