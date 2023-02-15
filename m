Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D464D6985CC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBOUow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBOUov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:44:51 -0500
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB49D2A6DC;
        Wed, 15 Feb 2023 12:44:50 -0800 (PST)
Received: by mail-ot1-f49.google.com with SMTP id e12-20020a0568301e4c00b0068bc93e7e34so34845otj.4;
        Wed, 15 Feb 2023 12:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjYSoaJSwu59aHW+FhFNZJJcMSOvVpdvL5abf/3v/FA=;
        b=4FY1/CJ9JQW2cssUNCXCpu8BjNV8C+hUgQAUwQsrxRaBnwLxJQYuhd2FCBPlVdXGia
         1Nz2OPDpNfxRBZIHiCZftWC5zFYV3b9yLXEXMov0/uCQcZFNeEGsXBh///nFeVGsKrvE
         0pY+V0hp8ZFOuQkUpIqM2Pr0vSU/M3keqZ4C2t2MqEaI2D6tFitaQV5g2ZQ99+ya9OpD
         8MwBj05W031WQvmgor0U88uSqEKJE0pXhjhkx7YW4ybFsInphdBlGv/Xpvs1awW+8I+J
         HeElQ0LLHcSLON6coHViqcCyQcc1OZlx6luYdfXyTcfkzjjsFBHqGEVVaDT7/7Ow9aU6
         JF3g==
X-Gm-Message-State: AO0yUKXtjyBev5zcfWRiu5mJlIPURqiX1PlX7ql0l3GIKKd4YuSJtIhC
        0abFbrATgwevsrmDPXb5SQ==
X-Google-Smtp-Source: AK7set8sEc2kDElwfrMygyUx7E7ji1I2dSyRJfp/5XbG5mUpm8RGvjm1PzPmau0b1qFq288NTP8ddw==
X-Received: by 2002:a05:6830:22d9:b0:68b:cb3c:c924 with SMTP id q25-20020a05683022d900b0068bcb3cc924mr1787699otc.10.1676493889974;
        Wed, 15 Feb 2023 12:44:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j16-20020a9d7690000000b0068663820588sm8099720otl.44.2023.02.15.12.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 12:44:49 -0800 (PST)
Received: (nullmailer pid 523312 invoked by uid 1000);
        Wed, 15 Feb 2023 20:44:48 -0000
Date:   Wed, 15 Feb 2023 14:44:48 -0600
From:   Rob Herring <robh@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Crispin <john@phrozen.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        DENG Qingfang <dqfext@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Landen Chao <Landen.Chao@mediatek.com>, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v6 04/12] dt-bindings: arm: mediatek: sgmiisys: add
 MT7981 SoC
Message-ID: <167649388793.523273.6752500904610456591.robh@kernel.org>
References: <cover.1676323692.git.daniel@makrotopia.org>
 <0c80e1dafc55a75f3a13327005ce23efb60451eb.1676323692.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c80e1dafc55a75f3a13327005ce23efb60451eb.1676323692.git.daniel@makrotopia.org>
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


On Mon, 13 Feb 2023 21:34:58 +0000, Daniel Golle wrote:
> Add mediatek,pnswap boolean property as well as an example for the
> MediaTek MT7981 SoC making use of that new property.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

