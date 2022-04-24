Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6850D256
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbiDXOoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 10:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbiDXOoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:44:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E71B506CB
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 07:41:09 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i27so25020402ejd.9
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 07:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RZeD7VZeCx2JfogRYjFn59CVQqv5yT2Ex57lPtVonrM=;
        b=GDOnFK53Lyz6+WpoTaj42rYsc+OyWpyddPpETFYQEHaaCDUl2915QVrDP3Yyqp8HuJ
         KYuPrGLvvfMWGw+u9El0tNbZ0SlcHWvtSBig2aAHZ8+62cFyGH9imSA8+B8Dab+r8Qg7
         i0nVRi0MUBvZYMuEjjAiB+fB0Y+BGx1OQdpFSt5advOo4lWOXOfWfAmvXQy4roS7namK
         2kVL1DNTPgB5b4LHAiA9xQQYEkpVzOmOT5bCvb/mTfs5g2EUbUgvVlFNYg3NmNx3UyfJ
         FlfhqOte5ah5NZ6F1zHvEbs+H7ve+Qne8pAvROKbtHQ5+8lxv7esUAShzfOqNygDy/v4
         4pGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RZeD7VZeCx2JfogRYjFn59CVQqv5yT2Ex57lPtVonrM=;
        b=vvAQjM3rOVnXRgaE0e2fEw8rDwiirRLQrnpgsqf/poyWDPas7ATo7GvQQS5LJSCqZa
         hom43go3ZkLzCpohfOAu/FoWeLRN//g7p5zT1PP7PaOXjYX4oSPFErG7BZoycTEddn3G
         sunjwi5s+456w/VnKE9/FpfyDWwXIcyxnEOzwHUiKyoZlAFkL6Q1SRmHihj435JGGiHu
         XzsQf+iuW018IM7mi6HCZ5O/TbAozuUwDExc5XPiUKQyL3lYJkdpy0CFeoP1M09d72DS
         KE5mm398Giu6i6PWwOYPeX2a6jpLUpYPVBzSxQC/9wOah9gO0wWsPx4UYeUUpD4JV0sq
         vQXQ==
X-Gm-Message-State: AOAM530fGbqpMFhM/OZlts7jrteuwAUCZ58h7y/qgIUq67ndNUZpw0e/
        q2T04Nhrbc6LGKZtzWGjcmv06w==
X-Google-Smtp-Source: ABdhPJz7Ncqwo2BgPXvbIAy2wgLUD3MtUq3yFRoyLm0iwljhuBrfg6w+G3XuREblHM8OGKifSld2qQ==
X-Received: by 2002:a17:907:9710:b0:6f3:6e7e:d5bd with SMTP id jg16-20020a170907971000b006f36e7ed5bdmr7302793ejc.252.1650811267684;
        Sun, 24 Apr 2022 07:41:07 -0700 (PDT)
Received: from [192.168.0.235] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id s14-20020aa7cb0e000000b00410bf015567sm3279398edt.92.2022.04.24.07.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 07:41:07 -0700 (PDT)
Message-ID: <f19273c8-a8be-1bc2-d5aa-2f131822b4cd@linaro.org>
Date:   Sun, 24 Apr 2022 16:41:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/3] dt-bindings: net: qcom,ipa: fix example for
 upcomming smp2p conversion
Content-Language: en-US
To:     David Heidelberg <david@ixit.cz>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220424131522.14185-1-david@ixit.cz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220424131522.14185-1-david@ixit.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2022 15:15, David Heidelberg wrote:
> Example of mpss was missing required properties.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 5 +++++

This needs rebasing on linux-next and then probably won't be
correct/necessary.


Best regards,
Krzysztof
