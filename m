Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960B968FB83
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjBHXsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjBHXsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:48:13 -0500
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213A22110;
        Wed,  8 Feb 2023 15:48:13 -0800 (PST)
Received: by mail-ot1-f47.google.com with SMTP id r34-20020a05683044a200b0068d4a8a8d2dso63945otv.12;
        Wed, 08 Feb 2023 15:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=50e1Whr1p5O5BfXr1b5aKvoRaix0X3o5rBbjLfH/hl0=;
        b=UBnrTj8PzT2s+pFjfM3tsstgyxxzRijs6Rwe4ZJejP/Gqx/ZkRJZ1VBtDWa+C4CVSQ
         az9GBUtZ2icLOIZZK7Kw5QxOVMvxH4SUX0G/6iCECfWmvHriod04y5lsZk6dts+eZZ4j
         gjbd+zxjy6/7k7wlM6Vsw2NZNGAV4AGQNV+TtX9WG5dtQEvRRWslAu6d1dOGZ1pD1R6c
         Y49gzCKoDL9uOuvKNPfBk8XrFbspWrw0UKkes5G7uSrRrk23nrW/k/6a7THYenLQXf5i
         QZd50sPisQK4NPG8Oyhw23X6MGVDasBSo+E7MQ4PseBuYo3jdtSMUm1uQ6c3t4AU3eIc
         zTzg==
X-Gm-Message-State: AO0yUKVV4TgKg5Cu95PpI8YfRmPK7TTD1MA/A8X6cwmgFfHib7CGl3mA
        I++Y3g75/2X/0cGGZo+1KA==
X-Google-Smtp-Source: AK7set/MAs5BubHgfwo8YE/1H72/fOatEqJB6vH4FwLOvCDTyVaWJ99UtL9xSLK4cD2uvjP9j1qy6Q==
X-Received: by 2002:a05:6830:2008:b0:68b:d347:2457 with SMTP id e8-20020a056830200800b0068bd3472457mr4177424otp.21.1675900092263;
        Wed, 08 Feb 2023 15:48:12 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z3-20020a05683010c300b0068d542f630fsm8717770oto.76.2023.02.08.15.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 15:48:11 -0800 (PST)
Received: (nullmailer pid 2936796 invoked by uid 1000);
        Wed, 08 Feb 2023 23:48:10 -0000
Date:   Wed, 8 Feb 2023 17:48:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: mt76: allow up to 4 interrupts for mt7986
Message-ID: <20230208234810.GA2935682-robh@kernel.org>
References: <20230207171512.35425-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207171512.35425-1-linux@fw-web.de>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 06:15:12PM +0100, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Mt7986 needs 4 interrupts which are already defined in mt7986a.dtsi.
> Update binding to reflect it
> 
> This fixes this error in dtbs_check (here only bpi-r3 example):
> 
> arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: wifi@18000000:
> interrupts: [[0, 213, 4], [0, 214, 4], [0, 215, 4], [0, 216, 4]] is too long
> 	From schema: Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: wifi@18000000:
> Unevaluated properties are not allowed ('interrupts' was unexpected)
> 	From schema: Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>  .../devicetree/bindings/net/wireless/mediatek,mt76.yaml      | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> index 212508672979..222b657fe4ea 100644
> --- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
> @@ -38,7 +38,10 @@ properties:
>        MT7986 should contain 3 regions consys, dcm, and sku, in this order.
>  
>    interrupts:
> -    maxItems: 1
> +    minItems: 1
> +    maxItems: 4
> +    description:
> +      MT7986 should contain 4 items.

The schema and the description don't match.

You need to define what each interrupt is.

Rob
