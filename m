Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2362D5A023C
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiHXTo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHXTo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:44:58 -0400
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1496A2D1F5;
        Wed, 24 Aug 2022 12:44:57 -0700 (PDT)
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-11dca1c9c01so5274729fac.2;
        Wed, 24 Aug 2022 12:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=GGbTiH5MlwiXaRbgDFTCR8WHSkMV+X8PO6SJOF3rCjU=;
        b=wSp+vyBHWsXKfDv03XgmUgTZVRdH9F2o9+i42RGg1pXtRTNkWmKo5H+/wHvypB++SD
         k+kEYR3rTMQpVVciI5VXWwpy9hz0k09SZ5skVg0Nb4Y3ql4+yPjqAcMA+K+aToLEKmOy
         DSrA61Pmoi9jVeW32xTRDcEP9DZ9pjfKcdkCjMm4heHAQMIf/5Hmv0FmNFQG7cV8HNVm
         LcTM0vCd+TjglWaVjOdLJT1u3UO8I2e4hwvlQ42FsbMq4CeeiBhNMASt+80eoH7SXg9r
         3+k1lOwJUCjcD5r6ShhpkPMPynPhXM2u61PRCebpXHyoi6hFEScZwOaDJwaz602FmCHe
         GFYQ==
X-Gm-Message-State: ACgBeo31gImf7eHZ9QdUAZESo9oEQXQAOoJCwwoepG6CPs4i0Mfehw5N
        4ajTGH7iRYQnd8/ljTSiog==
X-Google-Smtp-Source: AA6agR7g9enQ2VOPXxjiBBaQyiivB97fu0ajQpyomq4xaBUyjmklH9YO+Uml4yuCLV96TFgcFbgd0g==
X-Received: by 2002:a05:6870:f6a3:b0:11d:1ca9:ed55 with SMTP id el35-20020a056870f6a300b0011d1ca9ed55mr4500889oab.121.1661370296312;
        Wed, 24 Aug 2022 12:44:56 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p1-20020a544601000000b00344cc0c4606sm4284544oip.58.2022.08.24.12.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 12:44:55 -0700 (PDT)
Received: (nullmailer pid 2768602 invoked by uid 1000);
        Wed, 24 Aug 2022 19:44:54 -0000
Date:   Wed, 24 Aug 2022 14:44:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sander Vanheule <sander@svanheule.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        devicetree@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com
Subject: Re: [PATCH v5 1/7] dt-bindings: net: dsa: mediatek,mt7530: make
 trivial changes
Message-ID: <20220824194454.GA2768100-robh@kernel.org>
References: <20220824104040.17527-1-arinc.unal@arinc9.com>
 <20220824104040.17527-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220824104040.17527-2-arinc.unal@arinc9.com>
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

On Wed, 24 Aug 2022 13:40:34 +0300, Arınç ÜNAL wrote:
> Make trivial changes on the binding.
> 
> - Update title to include MT7531 switch.
> - Add me as a maintainer. List maintainers in alphabetical order by first
> name.
> - Add description to compatible strings.
> - Stretch descriptions up to the 80 character limit.
> - Remove lists for single items.
> - Remove quotes from $ref: "dsa.yaml#".
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 39 +++++++++++--------
>  1 file changed, 23 insertions(+), 16 deletions(-)
> 


Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

