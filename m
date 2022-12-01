Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729C363F58C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLAQqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLAQqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BDFAE4DB;
        Thu,  1 Dec 2022 08:46:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADE5AB81F99;
        Thu,  1 Dec 2022 16:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AFAC433C1;
        Thu,  1 Dec 2022 16:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669913161;
        bh=3Q6iXy/xYg6uP/f+JVE/FhVqO1PPrAY0s5KAVCFBU0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ke+Hjq9YiFRCq0yj/GyKBDUTWPJJXuzvkPYM6eNdRTdgw64OYUqJr+o8gbjct6hO0
         KHqXt1PFL/Hi3ew9rfbkn5emIOR1tvOitOauyeQMezokvwd3MpWvclih1D+uFSpxOp
         AE452lttx1oA67YxwbpLo+ajBFISI3fZrZalrzJ93hE1WIBvjiudYrEjiG6JS75tWb
         njDOwYF1aO2oT6t0B0JLVXF+0gW8sYglf+w27YexYvrZViwcDlly24fG+eQCZE1FDE
         LRPcEHtL3fGsE9fvmbMHRLkUHTZl4OG+nxIBerYWMzFfN1qKvjhfiY8AWlc/gjRoEu
         qQzg9kaJXzxSQ==
Date:   Thu, 1 Dec 2022 16:45:55 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Rob Herring <robh@kernel.org>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 3/7] dt-bindings: net: Add bindings for StarFive dwmac
Message-ID: <Y4jaQ4snp6x1oU6k@spud>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-4-yanhong.wang@starfivetech.com>
 <166990139276.476262.15116409959152660279.robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166990139276.476262.15116409959152660279.robh@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Yanhong,

On Thu, Dec 01, 2022 at 07:36:29AM -0600, Rob Herring wrote:
> 
> On Thu, 01 Dec 2022 17:02:38 +0800, Yanhong Wang wrote:
> > Add bindings for the StarFive dwmac module on the StarFive RISC-V SoCs.
> > 
> > Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> > ---
> >  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
> >  .../bindings/net/starfive,dwmac-plat.yaml     | 106 ++++++++++++++++++
> >  MAINTAINERS                                   |   5 +
> >  3 files changed, 112 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml
> > 
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> ./Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml:30:16: [warning] wrong indentation: expected 14 but found 15 (indentation)
> 
> dtschema/dtc warnings/errors:
> ./Documentation/devicetree/bindings/net/starfive,dwmac-plat.yaml: $id: relative path/filename doesn't match actual path or filename
> 	expected: http://devicetree.org/schemas/net/starfive,dwmac-plat.yaml#
> Documentation/devicetree/bindings/net/starfive,dwmac-plat.example.dts:21:18: fatal error: dt-bindings/clock/starfive-jh7110.h: No such file or directory
>    21 |         #include <dt-bindings/clock/starfive-jh7110.h>

Perhaps, rather than putting a long list of "prerequisite-patch-id" in
your cover letters etc, you drop the need for headers from your bindings
entirely? Otherwise, you need to wait for the clock bindings to be applied
before any of your other peripherals etc can have drivers/bindings upstream.

AFAIU, and Rob/Krzk please correct me, the example in a dt-binding
really is an *example* and there's no requirement for it to match the
jh7110 dts exactly. Because of that you can drop the header & just do
something like `clocks = <&clk 7>, <&clk 77>;` etc and the example is
still valid. Same goes for all of the other driver patchsets for new
StarFive stuff, like the pmu or crypto, that also have dt-bindings.

The only person who has to worry then about dependencies is me when I
apply the .dts patches :)

>       |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> make[1]: *** [scripts/Makefile.lib:406: Documentation/devicetree/bindings/net/starfive,dwmac-plat.example.dtb] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:1492: dt_binding_check] Error 2
> 
> doc reference errors (make refcheckdocs):
> 
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20221201090242.2381-4-yanhong.wang@starfivetech.com
> 
> The base for the series is generally the latest rc1. A different dependency
> should be noted in *this* patch.
> 
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
> 
> pip3 install dtschema --upgrade
> 
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your schema.
> 
