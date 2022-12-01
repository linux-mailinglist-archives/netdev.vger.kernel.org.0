Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC6563FBE7
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 00:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbiLAXXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 18:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiLAXXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 18:23:03 -0500
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1784B99E;
        Thu,  1 Dec 2022 15:23:01 -0800 (PST)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-13bd2aea61bso4006642fac.0;
        Thu, 01 Dec 2022 15:23:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWHREg3K9q2Uq2ob8YkTAtl0cbLjNrJW4Aev5O+DjTk=;
        b=ZRk8Y+ljFgcdZUFC9Z491YanklEXBiUWLo28SJuoHdeL0A6HnMVADfQ/KIOwhVWQR9
         U9zMI6/EIlcbuCrQP2Eo2FoOlekewFSMMkD8clEOPzWgsfiPUh0BQG8Klchj80cTIy93
         /rr9xGPiqKL119ZQvegzxpXYBadZ/0tDSdf9CYka+6Rd7mjhWjbCRWGpA14X9vM8tXOh
         oaGsGkzZjGQtnXu5UfPXcunDq57sdmN/lEZyJ+9KvbjO4jgeET0dXawnyh7hdwKJHyLr
         nG86gnINqS4RfzeurPSWPGGRoXhso6+TS1bgVcDUQFE2pCdovG9bFXcQny6zgVVmRuTK
         /HZg==
X-Gm-Message-State: ANoB5plg1H3fLeKsLlXwI5FMwrvLN2eHk7QcfCoeAEuYnl0294bx1zEe
        lJnwaIOV6CLD2UOa8VC9pg==
X-Google-Smtp-Source: AA0mqf7DmRJSFtG8dcbg49pfVMbnv1yJ+mEa1tNolTW9KSHVjM4y2+6Ho9iGfbmZXERvKMU+zCeNLQ==
X-Received: by 2002:a05:6870:d7a5:b0:142:80e3:1dbd with SMTP id bd37-20020a056870d7a500b0014280e31dbdmr39257160oab.253.1669936981101;
        Thu, 01 Dec 2022 15:23:01 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id ay19-20020a056808301300b00354b0850fb6sm2381703oib.33.2022.12.01.15.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:23:00 -0800 (PST)
Received: (nullmailer pid 1671892 invoked by uid 1000);
        Thu, 01 Dec 2022 23:22:59 -0000
Date:   Thu, 1 Dec 2022 17:22:59 -0600
From:   Rob Herring <robh@kernel.org>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568 xpcs
 compatible
Message-ID: <20221201232259.GA1668339-robh@kernel.org>
References: <20221129072714.22880-1-amadeus@jmu.edu.cn>
 <4692527.5fSG56mABF@diego>
 <8eb78282-08c2-24bf-4049-5c610dd781fc@linaro.org>
 <3689593.Mh6RI2rZIc@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3689593.Mh6RI2rZIc@diego>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 11:22:28AM +0100, Heiko Stübner wrote:
> Am Dienstag, 29. November 2022, 10:59:34 CET schrieb Krzysztof Kozlowski:
> > On 29/11/2022 10:56, Heiko Stübner wrote:
> > > Am Dienstag, 29. November 2022, 09:49:08 CET schrieb Krzysztof Kozlowski:
> > >> On 29/11/2022 08:27, Chukun Pan wrote:
> > >>> The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
> > >>> This patch adds a compatible string for the required clock.
> > >>>
> > >>> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
> > >>> ---
> > >>>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
> > >>>  1 file changed, 6 insertions(+)
> > >>>
> > >>> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> > >>> index 42fb72b6909d..36b1e82212e7 100644
> > >>> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> > >>> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> > >>> @@ -68,6 +68,7 @@ properties:
> > >>>          - mac_clk_rx
> > >>>          - aclk_mac
> > >>>          - pclk_mac
> > >>> +        - pclk_xpcs
> > >>>          - clk_mac_ref
> > >>>          - clk_mac_refout
> > >>>          - clk_mac_speed
> > >>> @@ -90,6 +91,11 @@ properties:
> > >>>        The phandle of the syscon node for the peripheral general register file.
> > >>>      $ref: /schemas/types.yaml#/definitions/phandle
> > >>>  
> > >>> +  rockchip,xpcs:
> > >>> +    description:
> > >>> +      The phandle of the syscon node for the peripheral general register file.
> > >>
> > >> You used the same description as above, so no, you cannot have two
> > >> properties which are the same. syscons for GRF are called
> > >> "rockchip,grf", aren't they?
> > > 
> > > Not necessarily :-) .
> > 
> > OK, then description should have something like "...GRF for foo bar".
> 
> Actually looking deeper in the TRM, having these registers "just" written
> to from the dwmac-glue-layer feels quite a bit like a hack.
> 
> The "pcs" thingy referenced in patch2 actually looks more like a real device
> with its own section in the TRM and own iomem area. This pcs device then
> itself has some more settings stored in said pipe-grf.
> 
> So this looks more like it wants to be an actual phy-driver.

There's a PCS binding now. Seems like it should be used if there is 
also a PHY already. PCS may be part of the PHY or separate block AIUI.

Rob
