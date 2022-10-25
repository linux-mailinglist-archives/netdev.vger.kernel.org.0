Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3325960D618
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiJYVXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 17:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiJYVXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 17:23:35 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF72A487A;
        Tue, 25 Oct 2022 14:23:35 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id 16-20020a9d0490000000b0066938311495so330542otm.4;
        Tue, 25 Oct 2022 14:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MiZtEq0TnMZ6dVYNj/YFe/ZDFlT7YjxhP5A2iXKUkoA=;
        b=mb0aISV+srSpQwSZcCCRT0amRdAvsKnc64HX4Bfs0ti+bhutFLXMDgD9r/Nzxa85lO
         HhAFGAN9Ixgz9ywZqqUZm3Lj4Rn3hruuhzGLOY0JYhtVGQ8y0+GS3N5LnPfA/2ah/Pcd
         e9U6ET4Ee5slmHJ53rh0WDI16Dz9vtZ5ZhniAWB7tcPC1tBfoeqOy9s31JQPfy44qtlC
         ghk3fvZZsHCONCaX57cVH6d6vDYlGdSHESAVjmVeuFh2BlqDeOg3Y7+DmMJqBk64qMDJ
         98iJPh1EQ7hGfPvtrLhi2qXoMOQ/aFbFR0OwC2S+P9g5VPEyqfjFm5KkkG93HCo8qjmW
         CQhQ==
X-Gm-Message-State: ACrzQf0aEAXVGLlPxS2rQczqyAGPmsmH8OyxEAkETErsvhPA37jv0zcw
        VC+J4Cbz+Oeg68IVGkjI6Q==
X-Google-Smtp-Source: AMsMyM4bAY+2dLYm8jZ/uFm3kd9aGE6c3QFn2578otqhf/JxJGpRVle2a9mLUPqcMdF3F83SFeG3/A==
X-Received: by 2002:a9d:5907:0:b0:665:c301:2f1c with SMTP id t7-20020a9d5907000000b00665c3012f1cmr4332788oth.375.1666733014290;
        Tue, 25 Oct 2022 14:23:34 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d22-20020a4ad356000000b004805e9e9f3dsm1563131oos.1.2022.10.25.14.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:23:33 -0700 (PDT)
Received: (nullmailer pid 3336858 invoked by uid 1000);
        Tue, 25 Oct 2022 21:23:34 -0000
Date:   Tue, 25 Oct 2022 16:23:34 -0500
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Landen Chao <Landen.Chao@mediatek.com>,
        John Crispin <john@phrozen.org>,
        DENG Qingfang <dqfext@gmail.com>,
        linux-mediatek@lists.infradead.org,
        =?iso-8859-1?Q?n=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next 7/7] dt-bindings: net: mscc,vsc7514-switch:
 utilize generic ethernet-switch.yaml
Message-ID: <20221025212334.GB3322299-robh@kernel.org>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-8-colin.foster@in-advantage.com>
 <166672723302.3138577.18331816371776997839.robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166672723302.3138577.18331816371776997839.robh@kernel.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 03:05:02PM -0500, Rob Herring wrote:
> On Mon, 24 Oct 2022 22:03:55 -0700, Colin Foster wrote:
> > Several bindings for ethernet switches are available for non-dsa switches
> > by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
> > the common bindings for the VSC7514.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  .../bindings/net/mscc,vsc7514-switch.yaml     | 36 +------------------
> >  1 file changed, 1 insertion(+), 35 deletions(-)
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> ./Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/net/ethernet-switch.yaml
> Documentation/devicetree/bindings/net/mscc,vsc7514-switch.example.dtb:0:0: /example-0/switch@1010000: failed to match any schema with compatible: ['mscc,vsc7514-switch']

This one you can ignore. The base tree is reset if a prior patch failed.

Rob
