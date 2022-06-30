Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C629561FDB
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiF3QCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235456AbiF3QCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:02:00 -0400
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444CB38BD5;
        Thu, 30 Jun 2022 09:01:59 -0700 (PDT)
Received: by mail-io1-f49.google.com with SMTP id y18so19582691iof.2;
        Thu, 30 Jun 2022 09:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+o3JUjbEZ2d8GIwY55/i06/Xd6JE/Y6ORuEhbR7yooE=;
        b=X5wXTKxORlO+HtkwBOSgtGd1U756IiJp5u8+UNsRXtNQHsos46/Oc8C2RNZKh5V4zm
         j1z0J/UNgq8UvR3lPVIe+pY1kSJjEynbhu98OoYo8SH3F6D3ADkpkaAbd3rC74dxL+FM
         96EDZenvdVmVKyP6vbyf/q0NYZwoUU9LozPW2/eHiGbxcBPm1A1niZdcFq3Cb3F+zLDR
         MjxL6Maf1mbl6fxFkCQqfyvatPYVEUHr0wenNGfVJEVTAqWbynGhFd1kas1usEReHB+a
         2rXPAPNZCO/oZouGk8mXrto1VGtSerJ41OkzDQk5KzyHxaBKhe27mgmxtSd8OkQmSG7w
         tW/w==
X-Gm-Message-State: AJIora+p8/qe+AqSQ3UCe2tY2DVj242qmu7XuOdXpWcakqzSLDdvHqhD
        AfCABElvwgBdxF7vSZyrjOkYPRX/VA==
X-Google-Smtp-Source: AGRyM1uxZs5WtxVIfWzOHKyBflQ9kZMiZ16aOdam1lGM7UP1fNMduUCufAFdDYuFmXFqG7qgcExM1w==
X-Received: by 2002:a05:6638:22d3:b0:33c:a25e:e3ca with SMTP id j19-20020a05663822d300b0033ca25ee3camr5793171jat.191.1656604918369;
        Thu, 30 Jun 2022 09:01:58 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y9-20020a92c749000000b002d8fbf31678sm8154392ilp.82.2022.06.30.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 09:01:58 -0700 (PDT)
Received: (nullmailer pid 2801904 invoked by uid 1000);
        Thu, 30 Jun 2022 16:01:56 -0000
Date:   Thu, 30 Jun 2022 10:01:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 03/35] dt-bindings: net: fman: Add additional
 interface properties
Message-ID: <20220630160156.GA2745952-robh@kernel.org>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-4-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628221404.1444200-4-sean.anderson@seco.com>
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

On Tue, Jun 28, 2022 at 06:13:32PM -0400, Sean Anderson wrote:
> At the moment, mEMACs are configured almost completely based on the
> phy-connection-type. That is, if the phy interface is RGMII, it assumed
> that RGMII is supported. For some interfaces, it is assumed that the
> RCW/bootloader has set up the SerDes properly. This is generally OK, but
> restricts runtime reconfiguration. The actual link state is never
> reported.
> 
> To address these shortcomings, the driver will need additional
> information. First, it needs to know how to access the PCS/PMAs (in
> order to configure them and get the link status). The SGMII PCS/PMA is
> the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
> well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
> same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
> addresses, but they are also not enabled at the same time by default.
> Therefore, we can let the XFI PCS/PMA be the default when
> phy-connection-type is xgmii. This will allow for
> backwards-compatibility.
> 
> QSGMII, however, cannot work with the current binding. This is because
> the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
> moment this is worked around by having every MAC write to the PCS/PMA
> addresses (without checking if they are present). This only works if
> each MAC has the same configuration, and only if we don't need to know
> the status. Because the QSGMII PCS/PMA will typically be located on a
> different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
> for the QSGMII PCS/PMA.
> 
> mEMACs (across all SoCs) support the following protocols:
> 
> - MII
> - RGMII
> - SGMII, 1000Base-X, and 1000Base-KX
> - 2500Base-X (aka 2.5G SGMII)
> - QSGMII
> - 10GBase-R (aka XFI) and 10GBase-KR
> - XAUI and HiGig
> 
> Each line documents a set of orthogonal protocols (e.g. XAUI is
> supported if and only if HiGig is supported). Additionally,
> 
> - XAUI implies support for 10GBase-R
> - 10GBase-R is supported if and only if RGMII is not supported
> - 2500Base-X implies support for 1000Base-X
> - MII implies support for RGMII
> 
> To switch between different protocols, we must reconfigure the SerDes.
> This is done by using the standard phys property. We can also use it to
> validate whether different protocols are supported (e.g. using
> phy_validate). This will work for serial protocols, but not RGMII or
> MII. Additionally, we still need to be compatible when there is no
> SerDes.
> 
> While we can detect 10G support by examining the port speed (as set by
> fsl,fman-10g-port), we cannot determine support for any of the other
> protocols based on the existing binding. In fact, the binding works
> against us in some respects, because pcsphy-handle is required even if
> there is no possible PCS/PMA for that MAC. To allow for backwards-
> compatibility, we use a boolean-style property for RGMII (instead of
> presence/absence-style). When the property for RGMII is missing, we will
> assume that it is supported. The exception is MII, since no existing
> device trees use it (as far as I could tell).
> 
> Unfortunately, QSGMII support will be broken for old device trees. There
> is nothing we can do about this because of the PCS/PMA situation (as
> described above).
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - Better document how we select which PCS to use in the default case
> 
>  .../bindings/net/fsl,fman-dtsec.yaml          | 52 +++++++++++++++++--
>  .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
>  2 files changed, 51 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> index 809df1589f20..ecb772258164 100644
> --- a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> +++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> @@ -85,9 +85,41 @@ properties:
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description: A reference to the IEEE1588 timer
>  
> +  phys:
> +    description: A reference to the SerDes lane(s)
> +    maxItems: 1
> +
> +  phy-names:
> +    items:
> +      - const: serdes
> +
>    pcsphy-handle:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> -    description: A reference to the PCS (typically found on the SerDes)
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    minItems: 1
> +    maxItems: 3

What determines how many entries?

> +    description: |
> +      A reference to the various PCSs (typically found on the SerDes). If
> +      pcs-names is absent, and phy-connection-type is "xgmii", then the first
> +      reference will be assumed to be for "xfi". Otherwise, if pcs-names is
> +      absent, then the first reference will be assumed to be for "sgmii".
> +
> +  pcs-names:
> +    $ref: /schemas/types.yaml#/definitions/string-array
> +    minItems: 1
> +    maxItems: 3
> +    contains:
> +      enum:
> +        - sgmii
> +        - qsgmii
> +        - xfi

This means '"foo", "xfi", "bar"' is valid. I think you want to 
s/contains/items/.

> +    description: The type of each PCS in pcsphy-handle.
> +

> +  rgmii:
> +    enum: [0, 1]
> +    description: 1 indicates RGMII is supported, and 0 indicates it is not.
> +
> +  mii:
> +    description: If present, indicates that MII is supported.

Types? Need vendor prefixes.

Are these board specific or SoC specific? Properties are appropriate for 
the former. The latter case should be implied by the compatible string.

>  
>    tbi-handle:
>      $ref: /schemas/types.yaml#/definitions/phandle
> @@ -100,6 +132,10 @@ required:
>    - fsl,fman-ports
>    - ptp-timer
>  
> +dependencies:
> +  pcs-names: [pcsphy-handle]
> +  mii: [rgmii]
> +
>  allOf:
>    - $ref: "ethernet-controller.yaml#"
>    - if:
> @@ -117,7 +153,11 @@ allOf:
>              const: fsl,fman-memac
>      then:
>        required:
> -        - pcsphy-handle
> +        - rgmii
> +    else:
> +      properties:
> +        rgmii: false
> +        mii: false
>  
>  unevaluatedProperties: false
>  
> @@ -138,7 +178,11 @@ examples:
>              reg = <0xe8000 0x1000>;
>              fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
>              ptp-timer = <&ptp_timer0>;
> -            pcsphy-handle = <&pcsphy4>;
> +            pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
> +            pcs-names = "sgmii", "qsgmii";
> +            rgmii = <0>;
>              phy-handle = <&sgmii_phy1>;
>              phy-connection-type = "sgmii";
> +            phys = <&serdes1 1>;
> +            phy-names = "serdes";
>      };
> diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
> index b9055335db3b..bda4b41af074 100644
> --- a/Documentation/devicetree/bindings/net/fsl-fman.txt
> +++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
> @@ -320,8 +320,9 @@ For internal PHY device on internal mdio bus, a PHY node should be created.
>  See the definition of the PHY node in booting-without-of.txt for an
>  example of how to define a PHY (Internal PHY has no interrupt line).
>  - For "fsl,fman-mdio" compatible internal mdio bus, the PHY is TBI PHY.
> -- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY,
> -  PCS PHY addr must be '0'.
> +- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY.
> +  The PCS PHY address should correspond to the value of the appropriate
> +  MDEV_PORT.
>  
>  EXAMPLE
>  
> -- 
> 2.35.1.1320.gc452695387.dirty
> 
> 
