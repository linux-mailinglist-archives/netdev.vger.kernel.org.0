Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8B065329A
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 15:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiLUOpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 09:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiLUOpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 09:45:12 -0500
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B102228E;
        Wed, 21 Dec 2022 06:45:07 -0800 (PST)
Received: by mail-oo1-f46.google.com with SMTP id e22-20020a4a5516000000b004a3d3028bafso2432841oob.3;
        Wed, 21 Dec 2022 06:45:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kxc7zdbLSHaxRWR2+Co/0ckNGsOv6s+kVwv5ktMzKsw=;
        b=odPLsXgV1RlcH9fsRKs6BqjlOGDMi1GEa6E1+e4b1gkOb9vPDeMXQiXOb7c5/icn5M
         heGk6KNH81umQxTOdO0xLhtYY1SasfZKGY5a05bkNJ1x3vWhywKhDgeaUUjA112eNYG8
         N/AxK1putmxtTiMNexI8MkE4eZzGa/qpA36NNopgTAb3pvyqmKTsNHUiIYNM1GkLgoIH
         AAlxUTvwnEFeN+XySY+o22tSGyTRq8furIQPInJEATsAGcbmhEWEI1zH5T6zUFsRL+6R
         ch+rpPOCvK3k9y4l73k3yTO1IEiAqWxHrwPtMuUYZ43WgRqyYbAX234oi+2reA4z2//t
         wm7g==
X-Gm-Message-State: AFqh2kpuEDqxVnS8uYBlS9YgtaSb0udgKHz5bhedu19YqTiJQMKaJfSE
        1kdiiLpv9rga/jntcEF+cgSOh7a1IQ==
X-Google-Smtp-Source: AMrXdXsv5ASbBtCMfNaRyWcXcFKU3H1LGLtchFwCMyAF6nfQgyphoBTb7BGZ7LP6yVCkTPqSWsZHjw==
X-Received: by 2002:a4a:ca8e:0:b0:4a3:6c91:98ab with SMTP id x14-20020a4aca8e000000b004a36c9198abmr948274ooq.2.1671633906971;
        Wed, 21 Dec 2022 06:45:06 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s26-20020a4aeada000000b0049be9c3c15dsm6168518ooh.33.2022.12.21.06.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 06:45:06 -0800 (PST)
Received: (nullmailer pid 2875796 invoked by uid 1000);
        Wed, 21 Dec 2022 14:45:05 -0000
Date:   Wed, 21 Dec 2022 08:45:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/2] dt-bindings: net: Add rfkill-gpio binding
Message-ID: <20221221144505.GA2848091-robh@kernel.org>
References: <20221221104803.1693874-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221104803.1693874-1-p.zabel@pengutronix.de>
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

On Wed, Dec 21, 2022 at 11:48:02AM +0100, Philipp Zabel wrote:
> Add a device tree binding document for GPIO controlled rfkill switches.
> The name, type, shutdown-gpios and reset-gpios properties are the same
> as defined for ACPI.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/rfkill-gpio.yaml  | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/rfkill-gpio.yaml b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> new file mode 100644
> index 000000000000..6e62e6c96456
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/rfkill-gpio.yaml
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/rfkill-gpio.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: GPIO controlled rfkill switch
> +
> +maintainers:
> +  - Johannes Berg <johannes@sipsolutions.net>
> +  - Philipp Zabel <p.zabel@pengutronix.de>
> +
> +properties:
> +  compatible:
> +    const: rfkill-gpio
> +
> +  name:

Did you test this? Something should complain, but maybe not. The problem 
is 'name' is already a property in the unflattened DT (and old FDT 
formats).

'label' would be appropriate perhaps, but why do we care what the name 
is? 

> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: rfkill switch name, defaults to node name
> +
> +  type:

Too generic. Property names should ideally have 1 type globally. I think 
'type' is already in use. 'radio-type' instead?


> +    description: rfkill radio type
> +    enum:
> +      - wlan
> +      - bluetooth
> +      - ultrawideband
> +      - wimax
> +      - wwan
> +      - gps
> +      - fm
> +      - nfc
> +
> +  shutdown-gpios:
> +    maxItems: 1
> +
> +  reset-gpios:
> +    maxItems: 1

I'm lost as to why there are 2 GPIOs.

> +
> +required:
> +  - compatible
> +  - type
> +
> +oneOf:
> +  - required:
> +      - shutdown-gpios
> +  - required:
> +      - reset-gpios

But only 1 can be present? So just define 1 GPIO name.

> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    rfkill-pcie-wlan {

Node names should be generic.

> +        compatible = "rfkill-gpio";
> +        name = "rfkill-pcie-wlan";
> +        type = "wlan";
> +        shutdown-gpios = <&gpio2 25 GPIO_ACTIVE_HIGH>;
> +    };
> -- 
> 2.30.2
> 
> 
