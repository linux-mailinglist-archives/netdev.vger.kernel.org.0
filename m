Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC3761A047
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiKDSub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKDSu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:50:29 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA375F70;
        Fri,  4 Nov 2022 11:50:28 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id g10so6069001oif.10;
        Fri, 04 Nov 2022 11:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFZemGAiz+864ig6tHEwR4+zzxKN7GhJUHozYh5QjjI=;
        b=GG/jE/pffRQmCB2QL+cRGeYDbEZl+QSXz2A9L2QDFJu4PZ9xgrYD3bxMrKiLGzpD+F
         YZyBUpUrQUFB/Ls6E8l20JhgLbQaN3D5Bcyw9pFMFvGi8uE/eIcZbM0pmYfum8Z1P62p
         lu8sgIRGS6q+Rm0He2A10M7ABFDM4ow7jQurenkvpoe7AnCcjAAvLVjbUysKo515yneZ
         cCNqy4S983rHpUizGQFR4LA0Mj5nkONR+PdlJIwLomTVxFx7COl5bIwQtj2A1CriKkoe
         bbm53k3rX7s1FcZugzTw27xdNrG4G9TApeKU66V/RO/4PNAmcotoQ0huYsISZwvez8NG
         mPLw==
X-Gm-Message-State: ACrzQf39tKJwsCG8/B6/Sne7Es9oBBe+lNVYl1y14Ddf0Wv2vTvdEiZT
        mI6hfwt6a+0fSHjiVdop5w==
X-Google-Smtp-Source: AMsMyM4NoyUsswYjaKUMH0fuD+Uj0sffbrFfd4AIvYQU1cWGLEOTRHBHp8TuRNKoTVHgwGqgdiwtkw==
X-Received: by 2002:a54:4016:0:b0:35a:3878:f22a with SMTP id x22-20020a544016000000b0035a3878f22amr9656904oie.47.1667587827748;
        Fri, 04 Nov 2022 11:50:27 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 2-20020aca2102000000b0035173c2fddasm1726258oiz.51.2022.11.04.11.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 11:50:27 -0700 (PDT)
Received: (nullmailer pid 2243197 invoked by uid 1000);
        Fri, 04 Nov 2022 18:50:28 -0000
Date:   Fri, 4 Nov 2022 13:50:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?iso-8859-1?Q?n=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v2 net-next 5/6] dt-bindings: net: add generic
 ethernet-switch-port binding
Message-ID: <20221104185028.GB2133300-robh@kernel.org>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
 <20221104045204.746124-6-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104045204.746124-6-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:52:03PM -0700, Colin Foster wrote:
> The dsa-port.yaml binding had several references that can be common to all
> ethernet ports, not just dsa-specific ones. Break out the generic bindings
> to ethernet-switch-port.yaml they can be used by non-dsa drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> 
> v1 -> v2
>   * Remove accidental addition of
>     "$ref: /schemas/net/ethernet-switch-port.yaml" which should be kept
>     out of dsa-port so that it doesn't get referenced multiple times
>     through both ethernet-switch and dsa-port.
> 
> ---
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 27 +-----------
>  .../bindings/net/ethernet-switch-port.yaml    | 44 +++++++++++++++++++
>  .../bindings/net/ethernet-switch.yaml         |  4 +-
>  MAINTAINERS                                   |  1 +
>  4 files changed, 49 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 10ad7e71097b..d97fb87cccb0 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Ethernet Switch port Device Tree Bindings
> +title: DSA Switch port Device Tree Bindings
>  
>  maintainers:
>    - Andrew Lunn <andrew@lunn.ch>
> @@ -14,13 +14,7 @@ maintainers:
>  description:
>    Ethernet switch port Description
>  
> -allOf:
> -  - $ref: /schemas/net/ethernet-controller.yaml#
> -
>  properties:
> -  reg:
> -    description: Port number
> -
>    label:
>      description:
>        Describes the label associated with this port, which will become
> @@ -57,25 +51,6 @@ properties:
>        - rtl8_4t
>        - seville
>  
> -  phy-handle: true
> -
> -  phy-mode: true
> -
> -  fixed-link: true
> -
> -  mac-address: true
> -
> -  sfp: true
> -
> -  managed: true
> -
> -  rx-internal-delay-ps: true
> -
> -  tx-internal-delay-ps: true
> -
> -required:
> -  - reg
> -
>  # CPU and DSA ports must have phylink-compatible link descriptions
>  if:
>    oneOf:
> diff --git a/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> new file mode 100644
> index 000000000000..cb1e5e12bf0a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> @@ -0,0 +1,44 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ethernet Switch port Device Tree Bindings
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Vivien Didelot <vivien.didelot@gmail.com>
> +
> +description:
> +  Ethernet switch port Description
> +
> +$ref: ethernet-controller.yaml#
> +
> +properties:
> +  reg:
> +    description: Port number
> +
> +  phy-handle: true
> +
> +  phy-mode: true
> +
> +  fixed-link: true
> +
> +  mac-address: true
> +
> +  sfp: true
> +
> +  managed: true
> +
> +  rx-internal-delay-ps: true
> +
> +  tx-internal-delay-ps: true

I know this is just copied, but these have no effect on validation. I 
assume what they are meant to be is these are the subset of 
ethernet-controller.yaml which are allowed, but that would only work 
with 'additionalProperties: false'. That wouldn't work because we also 
want to users to extend this with custom properties. What's needed here 
is a list of properties not allowed:

disallowed-prop: false

Or we can just allow anything from ethernet-controller.yaml and drop 
this list.

> +
> +required:
> +  - reg
> +
> +additionalProperties: true
> +
> +...
