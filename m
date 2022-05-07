Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0303C51E9D2
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 22:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446958AbiEGUFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 16:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445283AbiEGUFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 16:05:15 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E113765C
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 13:01:26 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id i19so20047154eja.11
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 13:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2iRIY5KwU5TFEDicwkCr/QLfBwiyrI+iHIWZ5gHruS4=;
        b=snHCBvCKpyR55jcalFhSWCYn1fBYbOZqyssEwgmfTHkkwGtiqSSuzRBMQtTmB4lVCY
         f43veq6EW+xFy2KClHF7KvUHJoMiPbP8T8V3wqmhlrsyND3+J96/g545JdUozBddYfil
         TjBgnQsI7yC+OOpXUPfC92tiNjQgKYUubGRq6tDW1gROV2RVuuv4lxpFe9mIoHTNUwBJ
         Yb7sMZxiYkPe5Nq0UeORK5OEKupCkWXRoen9EcUzqty7HMM91eUPETw+M3AVHT702Mbq
         1WZqHFhXNPVMvvM7CjBR+OeARz5aAzLRchmyeOZLLzrcLo2678YSl28Wbm7VCx+PTBei
         zxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2iRIY5KwU5TFEDicwkCr/QLfBwiyrI+iHIWZ5gHruS4=;
        b=xXKsf8vzZdGorSZBquHI0pH+HKDzqn2iNndEhSfgzB8wwePZipp1Skp2ZpaYofWc9a
         x8uKWuhu6C6LQkBkgqM20udVHiGA4QAGq2eJCt+9rD6tCH3fpMlizm+bMa/9+yVYAPyJ
         REbMiuuos8eVPE8bEKnH6fCMkLc4AGXcAv+0e0MviQnYbG1t85/El+LlCtwNhcCmRDKS
         WcOWNbhcrUJmKlgCIZ0lvgaYAXf+UX9wpnWcJRO+YVoxe7prFFBB27ySSyfi+HlEmAnk
         BDKiUApB423T1VT0entbaarCrjrXY9QphdNY8JA/Gc72l2ZmqaJhlIb44kCJ3A58v73R
         H/cA==
X-Gm-Message-State: AOAM532IJC7lX+PMpdHNMNJbmza/gdjzFqCW/fmvbV+JEdNWE/fKF5Ok
        OWXHF6tb++DONjd8NLvwlfpT6g==
X-Google-Smtp-Source: ABdhPJzrbT27gssfCk2kFgbjdT1R48ywS6K9Stnziba55N4u3lcIT2GtJxAdDh00AoGTrjRkP0Tflg==
X-Received: by 2002:a17:907:3f86:b0:6db:b745:f761 with SMTP id hr6-20020a1709073f8600b006dbb745f761mr8283334ejc.610.1651953685073;
        Sat, 07 May 2022 13:01:25 -0700 (PDT)
Received: from [192.168.0.235] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id en9-20020a056402528900b00425ff691a32sm3753134edb.0.2022.05.07.13.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 13:01:24 -0700 (PDT)
Message-ID: <06157623-4b9c-6f26-e963-432c75cfc9e5@linaro.org>
Date:   Sat, 7 May 2022 22:01:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 5/6] dt-bindings: net: dsa: make reset optional and add
 rgmii-mode to mt7531
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <20220507170440.64005-1-linux@fw-web.de>
 <20220507170440.64005-6-linux@fw-web.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220507170440.64005-6-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/05/2022 19:04, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Make reset optional as driver already supports it, 

I do not see the connection between hardware needing or not needing a
reset GPIO and a driver supporting it or not... What does it mean?

> allow port 5 as
> cpu-port 

How do you allow it here?

> and phy-mode rgmii for mt7531 cpu-port.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>  .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml          | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index a7696d1b4a8c..d02faed41b2a 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -55,6 +55,7 @@ description: |
>      On mt7531:
>        - "1000base-x"
>        - "2500base-x"
> +      - "rgmii"
>        - "sgmii"


Best regards,
Krzysztof
