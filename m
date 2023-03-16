Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DDD6BDA4C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCPUko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjCPUkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:40:42 -0400
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4528DD58BF;
        Thu, 16 Mar 2023 13:40:41 -0700 (PDT)
Received: by mail-il1-f171.google.com with SMTP id h5so1677734ile.13;
        Thu, 16 Mar 2023 13:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678999240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2MOq1ae2jmvldoEjIFleYkdU8muYIA0Owxizbdn6tU=;
        b=4rTp/gOpoCl3PFWORQnZ2F9WObJJ9Ft6PdpNi212uI24YmJl5EPz0u8YlpLTaCTfsk
         v9baAN/HoNmKslRHimc2jenMJDr1RGCVnUsOXkjmR5tfRLZ3av23a/U7/T/WySRsnf5U
         IzXG5S5UjNRqs0Min7YzdtXx+5KAD0cV4FFJgrXemOuNSFTpZ9EL++LPIwxnsXXGhRC3
         S2QQzQuqsqzw9/pTTMHNJYACR/cmomfhqn6MfzsH4jIG5dIzmqErKhmHdo7kR0RywAdL
         bIXfix6catMWXKICn2TTEKFyI2Q3O5RHXfFD8q4RVIjXvEre9xZ8a5l/xqxRQcTYjjNh
         9Qfg==
X-Gm-Message-State: AO0yUKUF23QucrG0EqPJN7ZummLuE7qOV8fbm4Te7Y6u5s92m+mH/NHI
        OE01LxLlTlLKUk/vtxuByQ==
X-Google-Smtp-Source: AK7set9VGmL4NQP8ptL/AQeYRXFeHQSoAkCWC9EhuNamHjr8AzWdzLTX5M2cZtySvCE9EkSC6peA6w==
X-Received: by 2002:a92:d090:0:b0:317:99d0:8ad1 with SMTP id h16-20020a92d090000000b0031799d08ad1mr8619161ilh.21.1678999239994;
        Thu, 16 Mar 2023 13:40:39 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id m21-20020a0566380dd500b003eac69029e5sm81952jaj.79.2023.03.16.13.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 13:40:39 -0700 (PDT)
Received: (nullmailer pid 3845579 invoked by uid 1000);
        Thu, 16 Mar 2023 20:40:37 -0000
Date:   Thu, 16 Mar 2023 15:40:37 -0500
From:   Rob Herring <robh@kernel.org>
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        Christian Marangi <ansuelsmth@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next 01/16] dt-bindings: net: dwmac: Validate PBL for
 all IP-cores
Message-ID: <20230316204037.GA3844212-robh@kernel.org>
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-2-Sergey.Semin@baikalelectronics.ru>
 <167880254800.26004.7037306365469081272.robh@kernel.org>
 <20230314150657.ytgyegi7qlwao6px@mobilestation>
 <20230314170945.6yow2i5z4jdubwgt@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314170945.6yow2i5z4jdubwgt@mobilestation>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 08:09:45PM +0300, Serge Semin wrote:
> On Tue, Mar 14, 2023 at 06:07:01PM +0300, Serge Semin wrote:
> > On Tue, Mar 14, 2023 at 09:10:19AM -0500, Rob Herring wrote:
> > > 
> > > On Tue, 14 Mar 2023 01:50:48 +0300, Serge Semin wrote:
> > > > Indeed the maximum DMA burst length can be programmed not only for DW
> > > > xGMACs, Allwinner EMACs and Spear SoC GMAC, but in accordance with [1]
> > > > for Generic DW *MAC IP-cores. Moreover the STMMAC set of drivers parse
> > > > the property and then apply the configuration for all supported DW MAC
> > > > devices. All of that makes the property being available for all IP-cores
> > > > the bindings supports. Let's make sure the PBL-related properties are
> > > > validated for all of them by the common DW MAC DT schema.
> > > > 
> > > > [1] DesignWare Cores Ethernet MAC Universal Databook, Revision 3.73a,
> > > >     October 2013, p. 380.
> > > > 
> > > > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > > 
> > > > ---
> > > > 
> > > > Changelog v1:
> > > > - Use correct syntax of the JSON pointers, so the later would begin
> > > >   with a '/' after the '#'.
> > > > ---
> > > >  .../devicetree/bindings/net/snps,dwmac.yaml   | 77 +++++++------------
> > > >  1 file changed, 26 insertions(+), 51 deletions(-)
> > > > 
> > > 
> > > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > > 
> > > yamllint warnings/errors:
> > > 
> > > dtschema/dtc warnings/errors:
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,txpbl:0:0: 1 is not one of [2, 4, 8]
> > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: snps,rxpbl:0:0: 1 is not one of [2, 4, 8]
> > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.example.dtb: ethernet@1101c000: Unevaluated properties are not allowed ('interrupt-names', 'interrupts', 'mac-address', 'phy-mode', 'reg', 'snps,reset-delays-us', 'snps,reset-gpio', 'snps,rxpbl', 'snps,txpbl' were unexpected)
> > > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> > 
> > Oops, on rebasing my work from older kernel I missed that the PBL
> > properties constraints have already been extended. I'll drop the next
> > patch in the series then and fix this one so the already defined
> > constraints would be preserved.
> 
> BTW it's strange I didn't have that bug spotted during my
> dt_binding_check run...

Perhaps because you set DT_SCHEMA_FILES?
