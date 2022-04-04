Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E604F0F24
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 08:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377386AbiDDGKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 02:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377361AbiDDGKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 02:10:46 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAEA13CFA
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 23:08:49 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id l7-20020a05600c1d0700b0038c99618859so7051042wms.2
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 23:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fn7+Axbb3oHFzu0IUSF5oGWWmKgpBpA2rKaZa34mQMA=;
        b=IgcR+Kf+++ogtqVkxEujQCdza7utQVaho1jIlzn05axtUFLeYUGxIIRscndLroe904
         vQWSO+3aLR1hAxgk9P4Q2zPJKMlx8BkDvocOLlVCawAo4iCzhkGOwCZhSVOkTyR3iEHJ
         q89+iuT/8y4Ksf22WkB4jrRWeMXcMYVP87M0JmEYFckMOTS+XHuRH5G0soLOgrNQ5m0B
         dGn5whIMRNlJjZq+nGmnOE1CT8Lm59porbmKINiPJbzxdO1mmexDQj2hvw6ZqNZ/gi9j
         5rfdDYDWCUilYib/g1WNkNRzMetqbbPZXhuKnPm54Rjk405RNfkW74w4Ns1MgJlQmtaS
         JeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fn7+Axbb3oHFzu0IUSF5oGWWmKgpBpA2rKaZa34mQMA=;
        b=HbikOAJV4fERhZv1PA4Uexp5+6UhtAFsD5sAQah+Ez5tvHbFKtITyiLzzC9NENY9Ua
         2/65T21pZkFuT492/p3HbzuaXQAs76GpI2w1BO5UT62YOgvjgfIfewZxpseVVFbTyCQq
         FaCF2S5lfYXzlQUVzwbFvT2QUyTwKcb44y2ExvXEY5H+zfxZL75imiWU17AePH25Fsmb
         YNtuYPp1eYsT5OjybCzJMyOZv9j1FrDXATyvtPeiRiKKEUNrrxwqO0RboZf/+UCBSs/K
         byjZSbR9PH8glWIaigSPs1T6lPv0Wpdq/utVvWqV0xFjB55fSAsVGBkMPJI/sNhY514L
         uTfQ==
X-Gm-Message-State: AOAM532LZlFqBjNqEz5ijF65xIsLn8DVPnzuB7ubfj5AVMc/zNOqHRiz
        8Yg9JCgPL4YSQTASiY9mD+zzBA==
X-Google-Smtp-Source: ABdhPJytCL+ChARui3ZMXV7R6knVdh/akY8c5Kio/IkxV6qS4h16j8/oNLsBp6+Ha5L4N17tE73F2Q==
X-Received: by 2002:a05:600c:4241:b0:38c:ec66:7c8f with SMTP id r1-20020a05600c424100b0038cec667c8fmr17793672wmm.179.1649052528247;
        Sun, 03 Apr 2022 23:08:48 -0700 (PDT)
Received: from [192.168.0.172] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id b15-20020adfc74f000000b001e888b871a0sm8521783wrh.87.2022.04.03.23.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 23:08:47 -0700 (PDT)
Message-ID: <edeb1037-e28a-a2c5-5dcf-d1f1686f6d7e@linaro.org>
Date:   Mon, 4 Apr 2022 08:08:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] dt-bindings: net: snps: remove duplicate name
Content-Language: en-US
To:     dj76.yang@samsung.com, "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Moon-Ki Jun <moonki.jun@samsung.com>
References: <CGME20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
 <20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220404022857epcms1p6e6af1a6a86569f339e50c318abde7d3c@epcms1p6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/04/2022 04:28, Dongjin Yang wrote:
> snps,dwmac has duplicated name for loongson,ls2k-dwmac and
> loongson,ls7a-dwmac.
> 
> Signed-off-by: Dongjin Yang <dj76.yang@samsung.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

This is a v2, so please version in the subject + some changelog under ---.

You missed my comment about fixes tag, please add it, do not ignore.

Fixes: 68277749a013 ("dt-bindings: dwmac: Add bindings for new Loongson
SoC and bridge chip")

Best regards,
Krzysztof
