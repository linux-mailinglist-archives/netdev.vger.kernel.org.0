Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99C84F85B4
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346032AbiDGRTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241991AbiDGRT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:19:28 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7891B12B75B;
        Thu,  7 Apr 2022 10:17:03 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-d6ca46da48so7020656fac.12;
        Thu, 07 Apr 2022 10:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5EG0rJLTD+MbvhnF4oQMsvQXhv9+LU3aJVkGQ/n7roQ=;
        b=4b6UcrOrQdEUlTZtFQ6iU0ip8n9gBe+v687a1udsFePLy8TOoYPFg7/3IfiwzkiO+d
         ksa7pauJSQcpd7lInAdfv+kWnzZ1vL3Q1TWdzE34v/AGQsWNZonkoRIbtpL0w2aGz4n+
         SyfQnRIAZfJHiUxcEsEUjrHzSuduj66aRd1Dmu4tCnCYGxkUdMXiyL+DUHgyRyOrX1Uy
         alZ81CFUCKR0KnS91fv3mTRNGNTG2xS34tbrXv3i257w7f91hjBno7lX+wSMrCFStlXa
         XDJVNyWY5qywNELRmnsQI4Xg9WVVucYC+3fD60vLjQpeweSR92X0WC8nbuH/x1GyWQpF
         1obQ==
X-Gm-Message-State: AOAM530bqNf9/8g4kInyu6sesUqlvbRdVnnsBQuTm+Uv/KoX/hzVOBiB
        E3vHc2k5dGJ7LdCZA4Rf+A==
X-Google-Smtp-Source: ABdhPJwAwF992HhuCgRfD4AbhjABaBZXkoVS6JYTmRcVMCykjLHu4LCaNf8nJMk6mYL3QdIrniYUkA==
X-Received: by 2002:a05:6870:d14d:b0:e1:e253:99e8 with SMTP id f13-20020a056870d14d00b000e1e25399e8mr6484169oac.23.1649351816358;
        Thu, 07 Apr 2022 10:16:56 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id pn22-20020a0568704d1600b000e27271d76fsm531821oab.58.2022.04.07.10.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:16:55 -0700 (PDT)
Received: (nullmailer pid 1462273 invoked by uid 1000);
        Thu, 07 Apr 2022 17:16:55 -0000
Date:   Thu, 7 Apr 2022 12:16:55 -0500
From:   Rob Herring <robh@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/14] dt-bindings: arm: mediatek: document the pcie
 mirror node on MT7622
Message-ID: <Yk8chzNBsRZR8e1q@robh.at.kernel.org>
References: <20220405195755.10817-1-nbd@nbd.name>
 <20220405195755.10817-6-nbd@nbd.name>
 <4bafe244-6a3d-d0ec-59d3-3f3f00e71caf@linaro.org>
 <318163cb-c771-c7eb-73ba-35c66f7d0e68@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <318163cb-c771-c7eb-73ba-35c66f7d0e68@nbd.name>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 01:01:06PM +0200, Felix Fietkau wrote:
> 
> On 06.04.22 10:20, Krzysztof Kozlowski wrote:
> > On 05/04/2022 21:57, Felix Fietkau wrote:
> > > From: Lorenzo Bianconi <lorenzo@kernel.org>
> > > 
> > > This patch adds the pcie mirror document bindings for MT7622 SoC.
> > > The feature is used for intercepting PCIe MMIO access for the WED core
> > > Add related info in mediatek-net bindings.
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > ---
> > >  .../mediatek/mediatek,mt7622-pcie-mirror.yaml | 42 +++++++++++++++++++
> > 
> > Eh, I wanted to ask to not put it inside arm/, but judging by your usage
> > - you did not create drivers for both of these (WED and PCIe mirror).
> > 
> > You only need them to expose address spaces via syscon.
> > 
> > This actually looks hacky. Either WED and PCIe mirror are part of
> > network driver, then add the address spaces via "reg". If they are not,
> > but instead they are separate blocks, why you don't have drivers for them?
> The code that uses the WED block is built into the Ethernet driver, but not
> all SoCs that use this ethernet core have it. Also, there are two WED
> blocks, and I'm not sure if future SoCs might have a different number of
> them at some point.
> The WED code also needs to access registers of the ethernet MAC.
> One reason for having a separate device is this:
> As long as WED is not in use, ethernet supports coherent DMA for increased
> performance. When the first wireless device attaches to WED, IO coherency
> gets disabled and the ethernet DMA rings are cleaned up and allocated again,
> this time with the struct device of WED (which doesn't have the dma-coherent
> property).

I'm pretty sure there are assumptions in the driver core that coherency 
is not changing on the fly. In any case, if it is, using 'dma-coherent' 
is not appropriate. You obviously have another method to determine 
whether you are coherent or not.

Rob
