Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8EF4AE811
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343955AbiBIEHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347529AbiBIDvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:51:21 -0500
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34864C061578;
        Tue,  8 Feb 2022 19:51:20 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id m10so1288243oie.2;
        Tue, 08 Feb 2022 19:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B5PZKrvUUieFothgb+vZlRFtusXfP8pySB7FuMjMx4Q=;
        b=yXb2/1f5Db0nsEZF7LBkjH8h6mnEGmixFAlx003cA3VLzs89n8CQ0PSn07LojiR5ST
         WABfP3BwggkROzLaV6boLFq12UBnQ9WGUYC5AyAMZJkHX2MpK5zI/TKn/KL2P/rXk8fE
         /niDJJ3rsfARcOr9XS2RWy1M4Ncxuzhbm07Vvi0d4oQkCyZhnuLd5VjM7rsghFuqYq6p
         I8zcPWSjhq9CoDdxgCNLdtz+NQymxVTbr5dJFZyNp8ypJYU3zszhvXFYYkhrPlzATo1i
         YDOtl/HjjPCNBRIn7HoiqAUtVjdFyARK3CU64dyTQVF1FeaRFfgnp5TjYGfx2AMTulxA
         CgYQ==
X-Gm-Message-State: AOAM532acmIyM0+C/C0sCAZGB297ZTTQ14L6ZpIQu1PG3EqpiQedV+sG
        GU5kzngugOx3wnv/OsGeAQ==
X-Google-Smtp-Source: ABdhPJxbreGzMUi6G1HWnwJEd4pBS64kXe9J+H9ATYzK8Wijsk523xyxrMpsEDFzmW/yeFuN+T4jpw==
X-Received: by 2002:a05:6808:30a4:: with SMTP id bl36mr514560oib.136.1644378679489;
        Tue, 08 Feb 2022 19:51:19 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id y15sm6106902oof.37.2022.02.08.19.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 19:51:18 -0800 (PST)
Received: (nullmailer pid 3614192 invoked by uid 1000);
        Wed, 09 Feb 2022 03:51:17 -0000
Date:   Tue, 8 Feb 2022 21:51:17 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: add "label" property
 for all usbnet Ethernet controllers
Message-ID: <YgM6NZ2pji01YeMl@robh.at.kernel.org>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127104905.899341-4-o.rempel@pengutronix.de>
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

On Thu, Jan 27, 2022 at 11:49:04AM +0100, Oleksij Rempel wrote:
> For hard wired Ethernet controllers it is helpful to assign name related
> to port description on the board. Or name, related to the special
> internal function, if the USB ethernet controller attached to the CPU
> port of some DSA switch.

Yes, so add 'label' to ethernet-controller.yaml.

Then I don't think usbnet.yaml is needed.

> 
> This patch provides documentation for "label" property, reusable for all
> usbnet controllers.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/asix,ax88178.yaml |  4 ++-
>  .../bindings/net/microchip,lan95xx.yaml       |  4 ++-
>  .../devicetree/bindings/net/usbnet.yaml       | 36 +++++++++++++++++++
>  3 files changed, 42 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/usbnet.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> index 74b6806006e3..c8ad767a2e45 100644
> --- a/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> +++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> @@ -13,7 +13,7 @@ description: |
>    Device tree properties for hard wired USB Ethernet devices.
>  
>  allOf:
> -  - $ref: ethernet-controller.yaml#
> +  - $ref: usbnet.yaml#
>  
>  properties:
>    compatible:
> @@ -58,6 +58,7 @@ properties:
>            - usb6189,182d  # Sitecom LN-029
>  
>    reg: true
> +  label: true
>    local-mac-address: true
>    mac-address: true
>  
> @@ -77,6 +78,7 @@ examples:
>          ethernet@1 {
>              compatible = "usbdb0,a877";
>              reg = <1>;
> +            label = "LAN0";
>              local-mac-address = [00 00 00 00 00 00];
>          };
>      };
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> index b185c7068a8a..259879bba3a0 100644
> --- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> +++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> @@ -14,7 +14,7 @@ description: |
>    controller.
>  
>  allOf:
> -  - $ref: ethernet-controller.yaml#
> +  - $ref: usbnet.yaml#
>  
>  properties:
>    compatible:
> @@ -40,6 +40,7 @@ properties:
>            - usb424,ec00   # SMSC9512/9514 USB Hub & Ethernet Device
>  
>    reg: true
> +  label: true
>    local-mac-address: true
>    mac-address: true
>  
> @@ -59,6 +60,7 @@ examples:
>          ethernet@1 {
>              compatible = "usb424,ec00";
>              reg = <1>;
> +            label = "LAN0";
>              local-mac-address = [00 00 00 00 00 00];
>          };
>      };
> diff --git a/Documentation/devicetree/bindings/net/usbnet.yaml b/Documentation/devicetree/bindings/net/usbnet.yaml
> new file mode 100644
> index 000000000000..fe0848433263
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/usbnet.yaml
> @@ -0,0 +1,36 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/usbnet.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: The device tree bindings for the USB Ethernet controllers
> +
> +maintainers:
> +  - Oleksij Rempel <o.rempel@pengutronix.de>
> +
> +description: |
> +  Device tree properties for hard wired USB Ethernet devices.
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible: true
> +
> +  reg:
> +    description: Port number
> +
> +  label:
> +    description:
> +      Describes the label associated with this port, which will become
> +      the netdev name
> +    $ref: /schemas/types.yaml#/definitions/string
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: true
> +
> +...
> -- 
> 2.30.2
> 
> 
