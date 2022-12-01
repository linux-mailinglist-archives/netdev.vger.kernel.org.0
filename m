Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A692363F635
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 18:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiLARfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 12:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiLARfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 12:35:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3594792A0F;
        Thu,  1 Dec 2022 09:35:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDA5EB81FC0;
        Thu,  1 Dec 2022 17:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C493C433D6;
        Thu,  1 Dec 2022 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669916143;
        bh=N41KtYO2yiNFGuVtHGyIzgY5vlpL+NViLtcBnbs2M+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P0Is98dJX/lEgrNKidWd4r3R/aj903gZv/tXDECOvOQ/Ds9yKmdrWjovT+No78TD+
         1PW+hXNH/unwb/zQOZLQ69XKTJ5z7n15ji1SiaFT0jdBWPrEf5+0rCDyWKF++/Bym3
         44jDukzrqEsw2FCSw0r1N26vzQh9cfMQ8tuEG0bAvkkNiJMR6siOcOSyRLNvB+yGFe
         E58qh8XwHnv2eAZRslaPjzfYyHhTz+NSrJ5bDEOg1ZXutsfpWNbP4oU4dDJQgScVli
         AkvVNHZ+aGf+mPFBmaY7MTc1FWMmBLyHKue5SEq5/s6dAIymImJ0ZZkHCCMa4BBcc0
         nIOPBZXf/HENQ==
Date:   Thu, 1 Dec 2022 17:35:37 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Message-ID: <Y4jl6awCMFgZsQGC@spud>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
 <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36565cc1-3c48-0fa8-f98b-414a7ac8f5bf@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 05:21:04PM +0100, Krzysztof Kozlowski wrote:
> On 01/12/2022 10:02, Yanhong Wang wrote:
> > Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
> 
> Subject: drop second, redundant "bindings".
> 
> > 
> > Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> > ---
> >  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
> > +properties:
> > +  compatible:
> > +    oneOf:
> 
> Drop oneOf. You do not have more cases here.
> 
> > +      - items:
> > +          - enum:
> > +               - starfive,dwmac
> 
> Wrong indentation.... kind of expected since you did not test the bindings.
> 
> > +          - const: snps,dwmac-5.20

Disclaimer: no familiarity with the version info with DW stuff

Is it a bit foolish to call this binding "starfive,dwmac"? Could there
not be another StarFive SoC in the future that uses another DW mac IP
version & this would be better off as "starfive,jh7110-dwmac" or similar?

Thanks,
Conor.

