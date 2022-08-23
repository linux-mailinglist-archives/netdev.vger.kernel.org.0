Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F2A59E49A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiHWNn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiHWNnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:43:04 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A549CCDC
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:47:27 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id m3so13430304lfg.10
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=RN/LOwAs0mnCfns8ZqSzFQO5l9T587JWTtmjgOoDJU0=;
        b=Py0wMtQJoUAEqHG39bdO2l0BFyd5gIb/rukM60FnZ1hchbdZcz/+uZHBv+PwZYsYHD
         KPwGaoEP4kJMY7TN5kh0S2PbU/GtEAZFI6/GWecCyniqreT6ulMrcaAexk8rNouQW+pC
         r2mpDu584TwrHqn6lCYfsCPZwrvgPTkIImrUO6nDjdM3TUwkrCUnEZ4JeI+Y7RDYZR4L
         9/nnSDO1kK59WzFrgxbHwSPItaD3vOteBcPpxjbHQlyhLUNEWJGEX904OANzDvl/GJx3
         XZgFnoOeWES7ce7ypMcQRWjqXoYyvB83wxa1ANQHzbjoC8isWgnJ+MVhgQkN8od+6iNh
         LUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=RN/LOwAs0mnCfns8ZqSzFQO5l9T587JWTtmjgOoDJU0=;
        b=OJJFISjTexTfsmBwq5FUg1p+cwPolV3SA1iq7oSPqS4SxTXvBcPS6Y4h3O1iu7c69Q
         HMVp72rMQ1maG1j38WxBUuiLPVz4dtHK+9vQT5eMJQxQSc/zXj1OZBzJOz/x9q52c5G/
         o6pp6FuiNwMLD4OkiF/IY3OzKVKgb7qs4qtNJJvSvL8w1VS9+zozRQv4Bhq2KIgobnCr
         gJ9haQsYGm6GOwa+ihpdE1QSeJKrELJNXvDwSHxqz00WfEY66FfW23Low0aABwv0q/bt
         hzXkrWNX8p6hxcEgPvx69j4aYmyM+XcEz951eTm3ZDxsvyOO4fdvMVp2Gbk3J7OjM45w
         Jc9g==
X-Gm-Message-State: ACgBeo1iGc9uYJpF07Fvdgrxv2CpGGOvkE36GbRnP0vBigvM8UEITiJh
        xUXjRhtU6qLHytQJtrqzJz8nug==
X-Google-Smtp-Source: AA6agR7X5sSiNq/i+Hdcr45vvYQkfwChkiEwFRHa/+jS1NGRNkHqhXgoDdJQhIB3VWwSaYKrwvZ2Ew==
X-Received: by 2002:a05:6512:22d5:b0:492:cf78:59b7 with SMTP id g21-20020a05651222d500b00492cf7859b7mr5862437lfu.504.1661251564314;
        Tue, 23 Aug 2022 03:46:04 -0700 (PDT)
Received: from [192.168.0.11] (89-27-92-210.bb.dnainternet.fi. [89.27.92.210])
        by smtp.gmail.com with ESMTPSA id t14-20020a2e8e6e000000b00261af4754bbsm2299173ljk.41.2022.08.23.03.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 03:46:03 -0700 (PDT)
Message-ID: <019d8f8a-cff1-4539-dc9f-8a0073b6ab32@linaro.org>
Date:   Tue, 23 Aug 2022 13:46:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 3/6] dt-bindings: net: dsa: mediatek,mt7530: update
 examples
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220820080758.9829-1-arinc.unal@arinc9.com>
 <20220820080758.9829-4-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220820080758.9829-4-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2022 11:07, Arınç ÜNAL wrote:
> Update the examples on the binding.
> 
> - Add examples which include a wide variation of configurations.
> - Make example comments YAML comment instead of DT binding comment.
> - Add interrupt controller to the examples. Include header file for
> interrupt.
> - Change reset line for MT7621 examples.
> - Pretty formatting for the examples.
> - Change switch reg to 0.
> - Change port labels to fit the example, change port 4 label to wan.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 402 +++++++++++++++---
>  1 file changed, 347 insertions(+), 55 deletions(-)


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
