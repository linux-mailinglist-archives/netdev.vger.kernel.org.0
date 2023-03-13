Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED84C6B7CF1
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjCMQAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCMQAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:00:38 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3453F64AB8;
        Mon, 13 Mar 2023 09:00:37 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32DG0Jnj063002;
        Mon, 13 Mar 2023 11:00:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678723219;
        bh=+iXu+QwUaS/FNlboJGJIEUHApVIyYjVUJPVX3JIXH+I=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=SlmsOiYPM7TBUkWXBYj9KpuxFJ8bQ334o1X1Ka/N8fK+AHcwELu4TtBzU+4A7c5Si
         w2ENVwGW+8uJhAbdVWLH4j3MozR4/LRzSp1Q3TZrqdh+rlxPgfUG8pKji6Tvp3Hi66
         TXJ/NofbP89DLpPz+qMWKlxAA/KtOvmrHcxsQv48=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32DG0Jj7009948
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Mar 2023 11:00:19 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Mon, 13
 Mar 2023 11:00:19 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Mon, 13 Mar 2023 11:00:19 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32DG0JXb040911;
        Mon, 13 Mar 2023 11:00:19 -0500
Date:   Mon, 13 Mar 2023 11:00:19 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH 2/2] dt-bindings: pinctrl: Move k3.h to arch
Message-ID: <20230313160019.vask6atfs6qwphml@twerp>
References: <20230311131325.9750-1-nm@ti.com>
 <20230311131325.9750-3-nm@ti.com>
 <71c7feff-4189-f12f-7353-bce41a61119d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <71c7feff-4189-f12f-7353-bce41a61119d@linaro.org>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16:46-20230311, Krzysztof Kozlowski wrote:
> On 11/03/2023 14:13, Nishanth Menon wrote:
> > Move the k3 pinctrl definition to arch dts folder.
> > 
> > While at this, fixup MAINTAINERS and header guard macro to better
> > reflect the changes.
> > 
> > Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> > Link: https://lore.kernel.org/all/c4d53e9c-dac0-8ccc-dc86-faada324beba@linaro.org/
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> > 
> > There is no specific case I can think of at the moment to create a
> > pinctrl.dtsi for the SoCs.. So, unlike other SoCs, I had not done that
> > in the series, if folks have a better opinion about this, please let us
> > discuss.
> > 
> >  MAINTAINERS                                                 | 1 -
> >  arch/arm64/boot/dts/ti/k3-am62.dtsi                         | 3 ++-
> >  arch/arm64/boot/dts/ti/k3-am62a.dtsi                        | 3 ++-
> >  arch/arm64/boot/dts/ti/k3-am64.dtsi                         | 3 ++-
> >  arch/arm64/boot/dts/ti/k3-am65.dtsi                         | 3 ++-
> >  arch/arm64/boot/dts/ti/k3-j7200.dtsi                        | 3 ++-
> >  arch/arm64/boot/dts/ti/k3-j721e.dtsi                        | 3 ++-
> >  arch/arm64/boot/dts/ti/k3-j721s2.dtsi                       | 3 ++-
> >  arch/arm64/boot/dts/ti/k3-j784s4.dtsi                       | 3 ++-
> >  .../pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h     | 6 +++---
> 
> Bindings are separate from other changes (also DTS). Split the patches.
> 
> (...)
> 
> >  / {
> >  	model = "Texas Instruments K3 J784S4 SoC";
> >  	compatible = "ti,j784s4";
> > diff --git a/include/dt-bindings/pinctrl/k3.h b/arch/arm64/boot/dts/ti/k3-pinctrl.h
> > similarity index 94%
> > rename from include/dt-bindings/pinctrl/k3.h
> > rename to arch/arm64/boot/dts/ti/k3-pinctrl.h
> > index 469bd29651db..6004e0967ec5 100644
> > --- a/include/dt-bindings/pinctrl/k3.h
> > +++ b/arch/arm64/boot/dts/ti/k3-pinctrl.h
> 
> Dropping this file is going to break existing code and I would say is
> also a break of the ABI. You need to keep the header for at least one
> cycle, you can add there a warning for coming deprecation.
> 
> See for example:
> https://lore.kernel.org/all/20220605160508.134075-5-krzysztof.kozlowski@linaro.org/


Makes complete sense. Thanks. will follow the lead and redo the series.

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
