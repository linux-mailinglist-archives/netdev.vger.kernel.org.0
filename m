Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50304E3448
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiCUX3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiCUX3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:29:21 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6C134ABAE;
        Mon, 21 Mar 2022 16:27:06 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-dacc470e03so309173fac.5;
        Mon, 21 Mar 2022 16:27:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IfOgSlFcJksxU8PubWCVTs9HLG1nJKsuup/4fqR0uJQ=;
        b=b5CcZLfMy+WlkqfABo9P2qTl6Mpt+tInviQxcVrQeHy9n8S9fYcEiVNzoRToKe+z7Q
         aecEX2Pzzj7NubXuJa66ScWGh36J1Sf23OgBqIY9VgxTc7l7Wq6D0sPXWU+bAMWSd/7d
         iLjyQOEGwVQSAUVZuBgGeAVevdK6ngEAKG7xs6fhT2jZ45E2ES2UFIraxkXIEZnwlEUJ
         YE2/pCDMB4jb1OOTvX4Vzns11fUsmgWy7h0cxjVSJhF6zuPZ7pH3FaAmh46wevZSbfeG
         QcFoNoNQEDk5vd+2X2FpcJwzuA7S0I4z0ChRgbuICK5PNjmC4V1/5n2l8F52s9HZTRJP
         FmkA==
X-Gm-Message-State: AOAM532WAiM/L7lw4/HrovploOR/lsJ9zMjFL72MxD0gWbvwCQ/Tb5ga
        i9zkeKugqnDTVBkjLj0EjmUosmwZkg==
X-Google-Smtp-Source: ABdhPJz5OurPXvO7jXlEUFzCMo8qHZUjHjGnUDgcet5Ci8hwHCOZunqcr4d4NKdhpDTI91pDLbBywA==
X-Received: by 2002:a05:6870:b390:b0:da:cf0c:17ae with SMTP id w16-20020a056870b39000b000dacf0c17aemr575810oap.94.1647905225351;
        Mon, 21 Mar 2022 16:27:05 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j145-20020acaeb97000000b002d9f37166c1sm7943323oih.17.2022.03.21.16.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 16:27:04 -0700 (PDT)
Received: (nullmailer pid 741695 invoked by uid 1000);
        Mon, 21 Mar 2022 23:27:03 -0000
Date:   Mon, 21 Mar 2022 18:27:03 -0500
From:   Rob Herring <robh@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v9 net-next 02/11] dt-bindings: net: add mdio property
Message-ID: <YjkJxykT2dQxe3d/@robh.at.kernel.org>
References: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
 <20220318085540.281721-3-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318085540.281721-3-prasanna.vengateshan@microchip.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 02:25:31PM +0530, Prasanna Vengateshan wrote:
> mdio bus is applicable to any switch hence it is added as per the below request,
> https://lore.kernel.org/netdev/1300f84832ef1c43ecb9edb311fb817e3aab5420.camel@microchip.com/

Quoting that thread:

> Yes indeed, since this is a common property of all DSA switches, it can
> be defined or not depending on whether the switch does have an internal
> MDIO bus controller or not.

Whether or not a switch has an MDIO controller or not is a property of 
that switch and therefore 'mdio' needs to be documented in those switch 
bindings.

> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> index b9d48e357e77..0f8426e219eb 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -31,6 +31,10 @@ properties:
>        switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
>        (single device hanging off a CPU port) must not specify this property
>      $ref: /schemas/types.yaml#/definitions/uint32-array
> +  
> +  mdio:
> +    $ref: /schemas/net/mdio.yaml#
> +    unevaluatedProperties: false

From a schema standpoint, this bans every switch from adding additional 
properties under an mdio node. Not likely what you want.

Rob
