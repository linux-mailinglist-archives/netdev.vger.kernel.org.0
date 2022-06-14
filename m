Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8901854BDAE
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345189AbiFNWcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiFNWcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:32:46 -0400
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16D92458C;
        Tue, 14 Jun 2022 15:32:45 -0700 (PDT)
Received: by mail-io1-f48.google.com with SMTP id d123so10911324iof.10;
        Tue, 14 Jun 2022 15:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CVcb2QfZlvcldcNaLh32HL82gx/d45G76khp2L61DK4=;
        b=k2z8c1Ql6YRckD67sG5vg0H8W5KdWiHxpWEmNd+mUTZRHn5H1nQhhRfMVpXmsRiPQi
         xs9P/50JPDbgt7cKuemq/mwaNNInitla0629rmapxi8B5QJCkFQ2vvAzk/xSSmpvG/qa
         qN/uZvDqDbuthgC3FJfqFwjEC8+FayOZemHzA4MCbtvZu1oo0DsyLyz6MmCxzkqKor2S
         VOIoGRyfd4qOVU1qmLe6ZFYJpdNxISn0x8okkTBEoMcEnSisb2LB8NbIkHlAsyvOan1k
         OYiyaw/OoLd1r2qDCgwtvyWED/aXzXlAaN/NXoI5693aCVAyHK7Wnthw6zEETMqqVdEr
         tXFg==
X-Gm-Message-State: AOAM533rYT5nrNdj2TCx3AA5PFZjmtnNIzsLFTFc8/2Av7Dt9k0W+WUq
        v8+yErT7n9oCSD8eaFrUM3+ei5I+kg==
X-Google-Smtp-Source: ABdhPJyq0EVA3Gxzc2qJ8HO4/M8DLzAPSmeeI6l+hyZb/y7hNm8hyd6w4gg3LC5iya2L+50YOqknZg==
X-Received: by 2002:a05:6638:1411:b0:331:ac08:5ae3 with SMTP id k17-20020a056638141100b00331ac085ae3mr4141226jad.162.1655245964991;
        Tue, 14 Jun 2022 15:32:44 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id u9-20020a92da89000000b002d4032b41casm5974649iln.32.2022.06.14.15.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 15:32:44 -0700 (PDT)
Received: (nullmailer pid 2848738 invoked by uid 1000);
        Tue, 14 Jun 2022 22:32:42 -0000
Date:   Tue, 14 Jun 2022 16:32:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     devicetree@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Peter Geis <pgwipeout@gmail.com>,
        linux-rockchip@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-mediatek@lists.infradead.org,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Ungerer <gerg@kernel.org>
Subject: Re: [PATCH v4 1/6] dt-bindings: net: dsa: convert binding for
 mediatek switches
Message-ID: <20220614223242.GA2848631-robh@kernel.org>
References: <20220610170541.8643-1-linux@fw-web.de>
 <20220610170541.8643-2-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610170541.8643-2-linux@fw-web.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 19:05:36 +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Convert txt binding to yaml binding for Mediatek switches.
> 
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
> v4:
> - fix squash of port 5 as cpu-port
> - drop type from interrupt-controller and add depency for this
> - use ethernet-ports in examples
> - drop address-/size-cells
> 
> v3:
> - include standalone patch in mt7530 series
> - drop some descriptions (gpio-cells,reset-gpios,reset-names)
> - drop | from descriptions
> - move patternProperties above allOf
> 
> v2:
> - rename mediatek.yaml => mediatek,mt7530.yaml
> - drop "boolean" in description
> - drop description for interrupt-properties
> - drop #interrupt-cells as requirement
> - example: eth=>ethernet,mdio0=>mdio,comment indention
> - replace 0 by GPIO_ACTIVE_HIGH in first example
> - use port(s)-pattern from dsa.yaml
> - adress/size-cells not added to required because this
>   is defined at mdio-level inc current dts , not switch level
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 406 ++++++++++++++++++
>  .../devicetree/bindings/net/dsa/mt7530.txt    | 327 --------------
>  2 files changed, 406 insertions(+), 327 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
