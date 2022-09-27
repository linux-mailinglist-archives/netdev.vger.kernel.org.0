Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45995EC7D0
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiI0Pdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiI0Pde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:33:34 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371F11C00FB;
        Tue, 27 Sep 2022 08:33:33 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id r13-20020a056830418d00b0065601df69c0so6545124otu.7;
        Tue, 27 Sep 2022 08:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=zjI6ubeIbgQT2Yf0aGxPciDY+P2liDNjOEnL2+LkAyE=;
        b=cN3Bg1R7tKngsluouxTcd9k3VeYyD9sY7FjN6G5SWlngQRuZUpmrBYK9MkKBJ6dkTh
         E9v+2vvW6/dVwS2ArzV1xzzH5CiiE6Jdxj2Of+qUBVZk4rwgG7u11DV0pkdpF+bQ/Czv
         eHhn7Jb3eiIbrPRn+voZ3I1EwbOIHkkhS6qWSpj6OjOuBCXoy8aESrM6RsGA+nJ3RCKu
         lTaGXckJSOF9z7TqbBNtlx9vu+2/IOSHlp5N932ryCDxG4J/8fv31BwujvuxF3lOy3Cu
         dMMXjdopz2Ztk91BkhkaTjftDIfc7uGEApkqmUfCcU76B4gCMAM5i5wvhx0Xo438gvTr
         izqA==
X-Gm-Message-State: ACrzQf0BQaiJlFgBCbbzFcFB8iQ7A7A+AtwpF59PwUKMTuaNcZrusjVb
        Yz+AwY7BCTbs/vFRqo30Ug==
X-Google-Smtp-Source: AMsMyM5eq9K8ICY6X0Mr3tOx3IJ4dvoj1unYKLRLY6r5PgzFpoQnkpXjPvXns1r165xN5VFsaDkAWw==
X-Received: by 2002:a05:6830:1d4c:b0:65b:5ca1:3c5c with SMTP id p12-20020a0568301d4c00b0065b5ca13c5cmr12714674oth.77.1664292812364;
        Tue, 27 Sep 2022 08:33:32 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id o11-20020a4ae58b000000b00425678b9c4bsm744517oov.0.2022.09.27.08.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:33:32 -0700 (PDT)
Received: (nullmailer pid 4069847 invoked by uid 1000);
        Tue, 27 Sep 2022 15:33:31 -0000
Date:   Tue, 27 Sep 2022 10:33:31 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/9] dt-bindings: net: Expand pcs-handle to
 an array
Message-ID: <20220927153331.GA4057163-robh@kernel.org>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
 <20220926190322.2889342-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926190322.2889342-2-sean.anderson@seco.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 03:03:13PM -0400, Sean Anderson wrote:
> This allows multiple phandles to be specified for pcs-handle, such as
> when multiple PCSs are present for a single MAC. To differentiate
> between them, also add a pcs-handle-names property.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This was previously submitted as [1]. I expect to update this series
> more, so I have moved it here. Changes from that version include:
> - Add maxItems to existing bindings
> - Add a dependency from pcs-names to pcs-handle.
> 
> [1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/
> 
> (no changes since v4)
> 
> Changes in v4:
> - Use pcs-handle-names instead of pcs-names, as discussed
> 
> Changes in v3:
> - New
> 
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml           |  1 +
>  .../devicetree/bindings/net/ethernet-controller.yaml   | 10 +++++++++-
>  .../devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml    |  2 +-
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> index 7ca9c19a157c..a53552ee1d0e 100644
> --- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> @@ -74,6 +74,7 @@ properties:
>  
>          properties:
>            pcs-handle:
> +            maxItems: 1

Forgot to remove the $ref here.

>              description:
>                phandle pointing to a PCS sub-node compatible with
>                renesas,rzn1-miic.yaml#
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 4b3c590fcebf..5bb2ec2963cf 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -108,11 +108,16 @@ properties:
>      $ref: "#/properties/phy-connection-type"
>  
>    pcs-handle:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> +    $ref: /schemas/types.yaml#/definitions/phandle-array

'phandle-array' is really a matrix, so this needs a bit more:

items:
  maxItems: 1

Which basically says this is phandles with no arg cells.

>      description:
>        Specifies a reference to a node representing a PCS PHY device on a MDIO
>        bus to link with an external PHY (phy-handle) if exists.
>  
> +  pcs-handle-names:
> +    $ref: /schemas/types.yaml#/definitions/string-array

No need for a type as *-names already has a type.

> +    description:
> +      The name of each PCS in pcs-handle.
> +
>    phy-handle:
>      $ref: /schemas/types.yaml#/definitions/phandle
>      description:
> @@ -216,6 +221,9 @@ properties:
>          required:
>            - speed
>  
> +dependencies:
> +  pcs-handle-names: [pcs-handle]
> +
>  allOf:
>    - if:
>        properties:
> diff --git a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
> index 7f620a71a972..600240281e8c 100644
> --- a/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
> +++ b/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml
> @@ -31,7 +31,7 @@ properties:
>    phy-mode: true
>  
>    pcs-handle:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> +    maxItems: 1
>      description:
>        A reference to a node representing a PCS PHY device found on
>        the internal MDIO bus.
> -- 
> 2.35.1.1320.gc452695387.dirty
> 
> 
