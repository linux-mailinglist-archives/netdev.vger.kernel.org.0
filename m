Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD8F61073F
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 03:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiJ1B2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 21:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbiJ1B2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 21:28:19 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A327AA99D7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:28:18 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id g11so2695555qts.1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 18:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQ/Ipt22j5aHIq5r1kAyzN5xaRx2BsZw/TMCHCAQ0qw=;
        b=RLrYoc/hs+jtC6QNt+Zz14C3HPgCX2cekOQzCuYq/iEA65WE2tRR9tFJut3R5ECK2s
         dWxi5YhVqCc+pkVu1bJvjvWbtmMEnYv8iMDATYo2jN0hXceGnFVXB/lB5K+s/EhLz5L0
         XNUdo3/fHmtD0crnUZpFTwWVOKsaY8q5er7n7ljM15ORYecu3OGlKGO5Vwt2w5ReS66Z
         7XCYgfIgNhiPYY0epaxLLA3Nvzl+fRLv2Yxt6mqGACmFmZQMUsgrrCZuLGK5o8PrEuPP
         Dt49KfPPtPDrQtiKjML6KV9kyF1IREMCOL/ictcyBTh9/a9QMTcmzTb36hnH0RQ5Ob9R
         wV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ/Ipt22j5aHIq5r1kAyzN5xaRx2BsZw/TMCHCAQ0qw=;
        b=mr+oObbwwipNkyneJ2zC/yVfphemJ9aYSCcOE1VquHO/9oP5UP4P9zZWSnUrSCihJ3
         CjcRPYLgKBs73/1KWzIFx1Z4XJKRZ6slDort7v/DagryUlUk/f9wZHFCNcq6ygZuwxD0
         qzF2AmOPxKueMgDtqYNkreWG7JOfsoAc0HSSzS4Gl8Fp7CbC1c+2V14T3RbOKlL5GqCU
         rjGYYmXJpVLf8/124zz11cyfLGq7DUlquRK37irwe6wRiVql7YOVb5cPVztCC9mbLZoz
         epGqzxbQaq1lYHsOQpXsxLexspw3p22ZC/4a2GOjlIqiYNjL+lXCmcGkejJSPEuqJvrz
         fqTA==
X-Gm-Message-State: ACrzQf0PcfpyCczB8+AzJ3+pRgebx7JaeZaajZ83f8xeCwIcd8edtMAr
        zNDxsoBY7yHhvY+zivsTKndxKQ==
X-Google-Smtp-Source: AMsMyM6wiLjQD5dYl5ZDyBqbCDv9dpT9xao43RBi2tdneNrrIH2NZkFipEKs/0u2YMm/2ZnfHx0sQg==
X-Received: by 2002:ac8:7d0b:0:b0:39d:90d:601b with SMTP id g11-20020ac87d0b000000b0039d090d601bmr37235040qtb.278.1666920497798;
        Thu, 27 Oct 2022 18:28:17 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id f18-20020a05620a409200b006cbe3be300esm2049175qko.12.2022.10.27.18.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 18:28:17 -0700 (PDT)
Message-ID: <bb23a9e0-1264-702e-a646-8de5afedb23e@linaro.org>
Date:   Thu, 27 Oct 2022 21:28:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v5 1/3] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20221027134034.2343230-1-yoshihiro.shimoda.uh@renesas.com>
 <20221027134034.2343230-2-yoshihiro.shimoda.uh@renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221027134034.2343230-2-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2022 09:40, Yoshihiro Shimoda wrote:
> Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---

> +
> +  ethernet-ports:
> +    type: object
> +    additionalProperties: false
> +
> +    properties:
> +      '#address-cells':
> +        description: Port number of ETHA (TSNA).
> +        const: 1
> +
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object
> +        $ref: /schemas/net/ethernet-controller.yaml#
> +        unevaluatedProperties: false
> +
> +        properties:
> +          reg:
> +            description:
> +              Port number of ETHA (TSNA).

I think you need here "maxItems: 1" as no schema sets the limit. I did
not notice it before.

> +
> +          phys:
> +            maxItems: 1
> +            description:
> +              Phandle of an Ethernet SERDES.
> +

Best regards,
Krzysztof

