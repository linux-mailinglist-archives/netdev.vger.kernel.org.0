Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB294B2B0A
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351835AbiBKQvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:51:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351780AbiBKQvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:51:15 -0500
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5F3D7D;
        Fri, 11 Feb 2022 08:51:14 -0800 (PST)
Received: by mail-qk1-f180.google.com with SMTP id b22so8735298qkk.12;
        Fri, 11 Feb 2022 08:51:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AYgiI7gkn9v+ZSarCY0jNpEEoK+dhB0sJ5++Eou/Ao4=;
        b=e1hxhV/oUgk0O/+7kTFPdGI0hXq4NiLvHLgGscT35tw5H85nf8JNnU57LZjGKavbVb
         QnLRTOTcHxrjSpJ/2c0hSLZYvmv5p6olWIwonbLKfsXKGi03s9y7cbajemtW3tcwsTng
         zZq7UzU/HL3GOprqO6wMYZ9TKCcxKVoBvGVJdI2hsi80ob47xwXbCFOgQZN+G0pJVa4x
         qKJ2P1ks8DcJQ1AH6OFCborSSocR2GrLLIIuLc8HsKZLjvhka8/WvgFyEe2Pn2BAgMYh
         Yla8UwjrU6RZZmWl6utE2EPXUkxo7r9JKgxQ5QDyDv7QZziC3SDElEbskGhklAnUHF0B
         XLlA==
X-Gm-Message-State: AOAM532BcUrO/L3SO37696MfRtWkhN2v35riJKo2gkTfkzznqhNxEAkQ
        C3iugSLxyYz+SUt0icuNsMdjfGcweA==
X-Google-Smtp-Source: ABdhPJwiuw34Dp61RI8Kcr7Ko5xtI464qx96udW7XA4hfaR8FjIE/I4ihHBD6OWA9HOmFHeVvxFFww==
X-Received: by 2002:a05:620a:4154:: with SMTP id k20mr1218053qko.293.1644598273159;
        Fri, 11 Feb 2022 08:51:13 -0800 (PST)
Received: from robh.at.kernel.org ([2607:fb90:5fee:dfce:b6df:c3e1:b1e5:d6d8])
        by smtp.gmail.com with ESMTPSA id i12sm11595792qko.105.2022.02.11.08.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:51:12 -0800 (PST)
Received: (nullmailer pid 505758 invoked by uid 1000);
        Fri, 11 Feb 2022 16:51:10 -0000
Date:   Fri, 11 Feb 2022 10:51:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: add schema for ASIX
 USB Ethernet controllers
Message-ID: <YgaT/vgTflPBP99k@robh.at.kernel.org>
References: <20220209081025.2178435-1-o.rempel@pengutronix.de>
 <20220209081025.2178435-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209081025.2178435-2-o.rempel@pengutronix.de>
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

On Wed, Feb 09, 2022 at 09:10:24AM +0100, Oleksij Rempel wrote:
> Create initial schema for ASIX USB Ethernet controllers and import all
> currently supported USB IDs form drivers/net/usb/asix_devices.c
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/asix,ax88178.yaml | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88178.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> new file mode 100644
> index 000000000000..2337a1a05bda
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> @@ -0,0 +1,68 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/asix,ax88178.yaml#
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
> +  compatible:
> +    items:
> +      - enum:
> +          - usbb95,1720   # ASIX AX88172
> +          - usbb95,172a   # ASIX AX88172A
> +          - usbb95,1780   # ASIX AX88178
> +          - usbb95,7720   # ASIX AX88772
> +          - usbb95,772a   # ASIX AX88772A
> +          - usbb95,772b   # ASIX AX88772B
> +          - usbb95,7e2b   # ASIX AX88772B
> +
> +  reg: true
> +  local-mac-address: true
> +  mac-address: true
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    usb {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethernet@1 {
> +            compatible = "usbdb0,a877";

This isn't one of the above compatibles.

> +            reg = <1>;
> +            local-mac-address = [00 00 00 00 00 00];
> +        };
> +    };
> +  - |
> +    usb {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        usb1@1 {
> +            compatible = "usb1234,5678";
> +            reg = <1>;
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            ethernet@1 {
> +               compatible = "usbdb0,a877";
> +               reg = <1>;
> +            };
> +        };
> +    };
> -- 
> 2.30.2
> 
> 
