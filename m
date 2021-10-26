Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5FA43BDE9
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240295AbhJZXfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:35:19 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:37561 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbhJZXfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 19:35:15 -0400
Received: by mail-ot1-f41.google.com with SMTP id b4-20020a9d7544000000b00552ab826e3aso1038714otl.4;
        Tue, 26 Oct 2021 16:32:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kSLSvsmgrH+vviFSMmPGSEilGiuI7PFaSyj8CApF5fU=;
        b=m8vDReP/TXnOHvvV49uo6Rw3NFirB6qO/ZfT3kSsFSxqR5Vlvn4mrV3B4KbNvdMcPU
         fJaWNk8SATdxkaQ4bgrPt7Xp2kwTU+kXpLBl+x3X6+k1JlL8pnSrjPb92THUyb5hLDzI
         DVYNwvdjjpRc0FnRW0PeaEJsBpFp2IgW5GSN6sDGV+u1XdMvLAWxK6B+X5daD2GGcbMB
         k9gP91VJKhWVXqW4aHv1Q2xu/4qydK3YxS2D2/iQ618nqCvd5pA2YxDBZOadwgrNhYJs
         f1ZNy9c+8MqPY3bcY1bPa63M5HnoS617MGzS9D9YAx0e2x3C7tqe0ApFuUCZCQ/sY65X
         rCDw==
X-Gm-Message-State: AOAM533QK92Nqo0ao+CkMo7RQkjtNyYLzLKArIbrA9fdVRJbgEb6Oyf0
        HGuorCm+spGL7opsAQqDiw==
X-Google-Smtp-Source: ABdhPJwB98USJC1MLEdS7c69Ku7Zf4yf+11kHPSUyZPG8lunaaHwG07kPy2N58Ow6F4CUnTHOTZ8hg==
X-Received: by 2002:a05:6830:1af0:: with SMTP id c16mr21717179otd.16.1635291169019;
        Tue, 26 Oct 2021 16:32:49 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id c17sm596350oom.33.2021.10.26.16.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 16:32:48 -0700 (PDT)
Received: (nullmailer pid 3523336 invoked by uid 1000);
        Tue, 26 Oct 2021 23:32:47 -0000
Date:   Tue, 26 Oct 2021 18:32:47 -0500
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~okias/devicetree@lists.sr.ht
Subject: Re: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt
 bindings to yaml
Message-ID: <YXiQH9ssI088xLuM@robh.at.kernel.org>
References: <20211017160210.85543-1-david@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211017160210.85543-1-david@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 17, 2021 at 06:02:10PM +0200, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> v2
>  - Krzysztof is a maintainer
>  - pintctrl dropped
>  - 4 space indent for example
>  - nfc node name
> v3
>  - remove whole pinctrl
> v4
>  - drop clock-frequency, which is inherited by i2c bus
> 
>  .../bindings/net/nfc/nxp,pn544.yaml           | 56 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
>  2 files changed, 56 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
> new file mode 100644
> index 000000000000..4592d1194a71
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
> @@ -0,0 +1,56 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nfc/nxp,pn544.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP Semiconductors PN544 NFC Controller
> +
> +maintainers:
> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> +
> +properties:
> +  compatible:
> +    const: nxp,pn544-i2c
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  enable-gpios:
> +    description: Output GPIO pin used for enabling/disabling the PN544
> +
> +  firmware-gpios:
> +    description: Output GPIO pin used to enter firmware download mode

*-gpios needs to say how many (maxItems: 1). I'll fix when applying.

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - enable-gpios
> +  - firmware-gpios
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    i2c {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        nfc@28 {
> +            compatible = "nxp,pn544-i2c";
> +            reg = <0x28>;
> +
> +            interrupt-parent = <&gpio1>;
> +            interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
> +
> +            enable-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
> +            firmware-gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/nfc/pn544.txt b/Documentation/devicetree/bindings/net/nfc/pn544.txt
> deleted file mode 100644
> index 2bd82562ce8e..000000000000
> --- a/Documentation/devicetree/bindings/net/nfc/pn544.txt
> +++ /dev/null
> @@ -1,33 +0,0 @@
> -* NXP Semiconductors PN544 NFC Controller
> -
> -Required properties:
> -- compatible: Should be "nxp,pn544-i2c".
> -- clock-frequency: I²C work frequency.
> -- reg: address on the bus
> -- interrupts: GPIO interrupt to which the chip is connected
> -- enable-gpios: Output GPIO pin used for enabling/disabling the PN544
> -- firmware-gpios: Output GPIO pin used to enter firmware download mode
> -
> -Optional SoC Specific Properties:
> -- pinctrl-names: Contains only one value - "default".
> -- pintctrl-0: Specifies the pin control groups used for this controller.
> -
> -Example (for ARM-based BeagleBone with PN544 on I2C2):
> -
> -&i2c2 {
> -
> -
> -	pn544: pn544@28 {
> -
> -		compatible = "nxp,pn544-i2c";
> -
> -		reg = <0x28>;
> -		clock-frequency = <400000>;
> -
> -		interrupt-parent = <&gpio1>;
> -		interrupts = <17 IRQ_TYPE_LEVEL_HIGH>;
> -
> -		enable-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
> -		firmware-gpios = <&gpio3 19 GPIO_ACTIVE_HIGH>;
> -	};
> -};
> -- 
> 2.33.0
> 
> 
