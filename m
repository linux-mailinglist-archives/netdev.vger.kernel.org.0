Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4162B59C6E5
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237664AbiHVSoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237662AbiHVSoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:44:16 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9868E3ECCE;
        Mon, 22 Aug 2022 11:41:39 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id bb16so13240813oib.11;
        Mon, 22 Aug 2022 11:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=nSpbooGUn1Mt7oSof4jzbbiXRG+FuCsB5diR7kREr48=;
        b=I3bAS+z4rQrKcYjEmnf3bZkofjfffokWqkz6TaRIEY73pi1507fZRw3gCYdS+HxYTE
         GvQgSePvH3T25LOae6yyFGNFU7SZdFuPraiH2Oi4tJLsPuQiHam6d/HbCiDWl15af3YR
         blqI5nTU0AtBznd+EzDyHgfIi89Uj1MU4RvXV4yt4hGyeGDMsmEJd9hbOqHyAG783ckH
         p0uJGUhSjMlO9I7pCawRtohvVNC+GuIX4Wb0wNsZpcNa2mGGcAZku+q1Gq2Low4DaT2v
         jQXh23M5ryRgD/Yb+o6mVaUbXSXh7TxjfGNEFhLWx0sdZiu+FPzT8Qf7ysZJzo0bLqRf
         4n9A==
X-Gm-Message-State: ACgBeo3VabRSyc4gl44VmVHMWzHkSiu+nmTFXTWCZ5G5uKUvCspXsl/3
        xGiDJhQcPbaypsbYixJNyg==
X-Google-Smtp-Source: AA6agR56Nf3RD5BXTvurqe0XPNuGN69wHgFFLG1esBh4D4BkW2owp82251e0iwnFwwCq/maIkstmrQ==
X-Received: by 2002:a05:6808:1892:b0:344:d066:5171 with SMTP id bi18-20020a056808189200b00344d0665171mr9439150oib.195.1661193673435;
        Mon, 22 Aug 2022 11:41:13 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id kw37-20020a056870ac2500b0011c6b9abb67sm3043748oab.46.2022.08.22.11.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 11:41:13 -0700 (PDT)
Received: (nullmailer pid 138889 invoked by uid 1000);
        Mon, 22 Aug 2022 18:41:12 -0000
Date:   Mon, 22 Aug 2022 13:41:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 1/7] dt-bindings: net: pse-dt: add bindings
 for generic PSE controller
Message-ID: <20220822184112.GA113650-robh@kernel.org>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-2-o.rempel@pengutronix.de>
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

On Fri, Aug 19, 2022 at 02:01:03PM +0200, Oleksij Rempel wrote:
> Add binding for generic Ethernet PSE controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../bindings/net/pse-pd/generic-pse.yaml      | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
> new file mode 100644
> index 0000000000000..64f91efa79a56
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/pse-pd/generic-pse.yaml
> @@ -0,0 +1,40 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/pse-pd/generic-pse.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Generic Power Sourcing Equipment
> +
> +maintainers:
> +  - Oleksij Rempel <o.rempel@pengutronix.de>
> +
> +description: |
> +  Generic PSE controller. The device must be referenced by the PHY node
> +  to control power injection to the Ethernet cable.

Isn't this separate from the PHY other than you need to associate 
supplies with ethernet ports?

Is there a controller here? Or it is just a regulator consumer 
associated with an ethernet port?

> +
> +properties:
> +  compatible:
> +    const: ieee802.3-podl-pse-generic

Is this for 802.3bu only (which is where PoDL comes from) or all the 
flavors? If all, do they need to be distinguished?

'generic' is redundant.

> +
> +  '#pse-cells':

What's this for? You don't have a consumer.

> +    const: 0
> +
> +  ieee802.3-podl-pse-supply:

Seems a bit long

> +    description: |

Don't need '|' if no formatting to maintain.

> +      Power supply for the PSE controller
> +
> +additionalProperties: false
> +
> +required:
> +  - compatible
> +  - '#pse-cells'
> +  - ieee802.3-podl-pse-supply
> +
> +examples:
> +  - |
> +    ethernet-pse-1 {
> +      compatible = "ieee802.3-podl-pse-generic";
> +      ieee802.3-podl-pse-supply = <&reg_t1l1>;
> +      #pse-cells = <0>;
> +    };
> -- 
> 2.30.2
> 
> 
