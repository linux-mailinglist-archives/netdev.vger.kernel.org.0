Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705B360E6B5
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 19:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiJZRoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 13:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiJZRoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 13:44:22 -0400
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56D2FE930;
        Wed, 26 Oct 2022 10:44:21 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1322d768ba7so21092429fac.5;
        Wed, 26 Oct 2022 10:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yZ+i/SF4l9FMWNRr/cPA8I6Wy/mpZ+a7Vqb6QMxr248=;
        b=k0qFmGW3kHlOmc8RgEe5/cXD1Wyw9auZRYcvUGlacdBZYofm39ATEs+VCEI1TfxUx8
         nHGPylX2rR3X9AmziqfLj2ir3PjZDgfLkfZ+qAkCsORUEvULzZgevtTA3A3ibQ+8oQh+
         Kbz1jgrqd//L7RcQs6jrRmA1/S9UOu5F1v6Dox7lTmjxfeBlY6PLmC/s293DZI813ITr
         oJ3JOFv+cQV8HLOVtQQTgFzC7rnEWop+AOeNKZlJ30vRYVqIM+48ZZsXm44SeDZP7mjN
         0VMNMHcaR07CC5A9ypVvHS7eFkwxHr4rIhPWeqZcmF0UgAITBAT6CGSlQW34j3/BaFtx
         Onyw==
X-Gm-Message-State: ACrzQf3jBiI9SyhTphSgrvR6PSx+W7Jcem4wfultv91ltZGNk0lLoCHw
        2Hh7+6H203R147h/piFh1g==
X-Google-Smtp-Source: AMsMyM67Pw/bp++Kwpi4bAgdItQrAnVSBhLzRwXb2hhebp/wuZMaR60Sn/XNDJMCXdMpka6OF32FZw==
X-Received: by 2002:a05:6870:e98e:b0:12b:8d8d:1116 with SMTP id r14-20020a056870e98e00b0012b8d8d1116mr2981248oao.165.1666806260917;
        Wed, 26 Oct 2022 10:44:20 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b6-20020a4ae206000000b0044b125e5dabsm2360665oot.35.2022.10.26.10.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 10:44:20 -0700 (PDT)
Received: (nullmailer pid 808914 invoked by uid 1000);
        Wed, 26 Oct 2022 17:44:21 -0000
Date:   Wed, 26 Oct 2022 12:44:21 -0500
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
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 6/7] dt-bindings: net: add generic
 ethernet-switch-port binding
Message-ID: <20221026174421.GA794561-robh@kernel.org>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025050355.3979380-7-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 10:03:54PM -0700, Colin Foster wrote:
> The dsa-port.yaml binding had several references that can be common to all
> ethernet ports, not just dsa-specific ones. Break out the generic bindings
> to ethernet-switch-port.yaml they can be used by non-dsa drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/dsa-port.yaml | 26 +----------
>  .../bindings/net/ethernet-switch-port.yaml    | 44 +++++++++++++++++++
>  .../bindings/net/ethernet-switch.yaml         |  4 +-
>  MAINTAINERS                                   |  1 +
>  4 files changed, 50 insertions(+), 25 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 10ad7e71097b..c5144e733511 100644
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
> @@ -15,12 +15,9 @@ description:
>    Ethernet switch port Description
>  
>  allOf:
> -  - $ref: /schemas/net/ethernet-controller.yaml#
> +  - $ref: /schemas/net/ethernet-switch-port.yaml#
>  
>  properties:
> -  reg:
> -    description: Port number
> -
>    label:
>      description:
>        Describes the label associated with this port, which will become
> @@ -57,25 +54,6 @@ properties:
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
> +
> +required:
> +  - reg
> +
> +additionalProperties: true
> +
> +...
> diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> index fbaac536673d..f698857619da 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
> @@ -36,7 +36,9 @@ patternProperties:
>          type: object
>          description: Ethernet switch ports
>  
> -        $ref: /schemas/net/dsa/dsa-port.yaml#
> +        allOf:
> +          - $ref: /schemas/net/dsa/dsa-port.yaml#
> +          - $ref: ethernet-switch-port.yaml#

dsa-port.yaml references ethernet-switch-port.yaml, so you shouldn't 
need both here.

I imagine what you were trying to do here was say it is either one of 
these, not both. I don't think this is going work for the same reasons I 
mentioned with unevaluatedProperties.

Rob
