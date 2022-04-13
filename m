Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54F24FED00
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 04:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiDMCgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 22:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiDMCgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 22:36:40 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C691828E09;
        Tue, 12 Apr 2022 19:34:20 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id 3so422149qkj.5;
        Tue, 12 Apr 2022 19:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqB+e2xT6Yv8MpPTnOJ+2E7n6YyjIMzpIJ4iHfGOxzQ=;
        b=MiGg6bcAs91xkbp2RAUHsNccXGOyhvPuMSn82Wa1gSKILPMKoQG5P3Nl6kIPR+N5J+
         zVXOLkNpjaDHn+waq32rztY1uH6Ltt+sjAJ0nV2d/w1hp6PgqHrypZf+6wnGN6+VoZhA
         Gqm9ac5gX/HqIda6RlWEEWZA5aB3xxReNhoT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqB+e2xT6Yv8MpPTnOJ+2E7n6YyjIMzpIJ4iHfGOxzQ=;
        b=t7fBsECdTn7A+wWRmrPxbNn52y/e/rvmTo4iyTOJAOMhiEGdM0QBSgjnDqYpVKBp2q
         uuOyUOnzUgNNZ39xdcWuvW2IVezSFQFUFTRMDGy30x9jIG2tSyqD+5dAvuE7xoKz2KsZ
         3znyBWE8H+5fU7kijyFqRUDb+vcEyQSmYUOAsOUZ6U0dGhksUiJPzFshnEtf+3FOBBMo
         Ryd8juNhX01VC7Qwzdpim0dwEafUeVUn/k6+kJtl5FMITimGd2XKh9OK0inx7ujbJFFK
         6rEDSL/FZsXtCTe/GIBHxXAq6N8rg0kSBOCySPqom8//9Tpix57wX5uU88l9f9O67IrX
         B7bA==
X-Gm-Message-State: AOAM531/UGpyveGOSjyQHSpXkK5Drkq1WOLQ9yGlq9jXe3XBuyw3DtAo
        4ptVkW+NWEM3y7hQmyxSA+WWf3yXX8lqB3xVCSd14xzDK3Q=
X-Google-Smtp-Source: ABdhPJywZYFb5Kxa0f4hpEMdUjYMwcNEQCHYq0m2mmEOdorMP1FM/4Q5J9SAQdd/0fyvytzb+Axet0s98+c5ArMZPco=
X-Received: by 2002:a37:f903:0:b0:648:ca74:b7dc with SMTP id
 l3-20020a37f903000000b00648ca74b7dcmr5261283qkj.666.1649817259877; Tue, 12
 Apr 2022 19:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220412065611.8930-1-dylan_hung@aspeedtech.com> <20220412065611.8930-2-dylan_hung@aspeedtech.com>
In-Reply-To: <20220412065611.8930-2-dylan_hung@aspeedtech.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 13 Apr 2022 02:34:08 +0000
Message-ID: <CACPK8Xd0gh5pDafP3ysu7odhnP=YPNSYPV9u36CEoMPDtQxEJw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: add reset property for aspeed,
 ast2600-mdio binding
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Andrew Jeffery <andrew@aj.id.au>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        devicetree <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 at 06:55, Dylan Hung <dylan_hung@aspeedtech.com> wrote:
>
> The AST2600 MDIO bus controller has a reset control bit and must be
> deasserted before manipulating the MDIO controller. By default, the
> hardware asserts the reset so the driver only need to deassert it.
>
> Regarding to the old DT blobs which don't have reset property in them,
> the reset deassertion is usually done by the bootloader so the reset
> property is optional to work with them.
>
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> index 1c88820cbcdf..1174c14898e1 100644
> --- a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> @@ -20,10 +20,14 @@ allOf:
>  properties:
>    compatible:
>      const: aspeed,ast2600-mdio
> +
>    reg:
>      maxItems: 1
>      description: The register range of the MDIO controller instance
>
> +  resets:
> +    maxItems: 1
> +
>  required:
>    - compatible
>    - reg
> @@ -39,6 +43,7 @@ examples:
>              reg = <0x1e650000 0x8>;
>              #address-cells = <1>;
>              #size-cells = <0>;
> +            resets = <&syscon ASPEED_RESET_MII>;

You will need to include the definition for ASPEED_RESET_MII at the
start of the example:

#include <dt-bindings/clock/ast2600-clock.h>

You can test the bindings example by doing this:

pip install dtschema

make dt_binding_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml

Cheers,

Joel

>
>              ethphy0: ethernet-phy@0 {
>                      compatible = "ethernet-phy-ieee802.3-c22";
> --
> 2.25.1
>
