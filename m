Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337BE25C6E7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgICQdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:33:02 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:32787 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgICQdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:33:00 -0400
Received: by mail-io1-f68.google.com with SMTP id g14so3609438iom.0;
        Thu, 03 Sep 2020 09:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zxzBApJ5KdRi8hWz3FNz3FFzLEhPh42Wou2wnFa7YfU=;
        b=TK5VuTMRYOw86qU0gO8O6UJSoruMd9F1r9W457PnQMYVEd6Y7ZYDHrh/uAybBNqIV5
         9kUCyEznKivedtDbnrr8W0enwqrejc+s8JcEQqTOAyPt9QsYT1xSkX2WaQMaqmMZeSdG
         XyoEHAlGvOoP9ic2y47SW09Ty5k3zsEycqSkQ92CUq78txkWmpPPKwveTw2TPa+YadNE
         Bko6lCLAzDftx7jB7SwKpA8zirxG+dZleTceyfbVFKiUyUz2UrbZjgRIY7wnTHVZp7wq
         Hg7AraX8AgGt0+uMzCkD3R8GB1x1p2BCENn93MLIVHJXc5nKqeWfj96UvYo4U+Wp43fW
         oF7g==
X-Gm-Message-State: AOAM531Xu8tpasiFgwvKd5Kc5QH79J8BYQpPeaKMrj/X+IAZ1h/uc6M6
        4uDev9H1xrJbg9YJMOzd7RUZ6j9z53bm
X-Google-Smtp-Source: ABdhPJwb4QjscCLAUy2dOLiBqPEoCf+BWTEEjA5ReP4tKBT6R+EYCWo+61Blszf0fFDKVqwWI0mFaQ==
X-Received: by 2002:a05:6638:22ba:: with SMTP id z26mr4084019jas.55.1599150779501;
        Thu, 03 Sep 2020 09:32:59 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id f141sm1689841ilh.65.2020.09.03.09.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 09:32:57 -0700 (PDT)
Received: (nullmailer pid 2906919 invoked by uid 1000);
        Thu, 03 Sep 2020 16:32:55 -0000
Date:   Thu, 3 Sep 2020 10:32:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: Re: [PATCH 1/4] dt-bindings: net: nfc: s3fwrn5: Convert to dtschema
Message-ID: <20200903163255.GA2903619@bogus>
References: <20200829142948.32365-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829142948.32365-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 29, 2020 at 04:29:45PM +0200, Krzysztof Kozlowski wrote:
> Convert the Samsung S3FWRN5 NCI NFC controller bindings to dtschema.
> This is conversion only so it includes properties with invalid prefixes
> (s3fwrn5,en-gpios) which should be addressed later.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  .../devicetree/bindings/net/nfc/s3fwrn5.txt   | 25 --------
>  .../devicetree/bindings/net/nfc/s3fwrn5.yaml  | 59 +++++++++++++++++++

Please rename to samsung,s3fwrn5-i2c.yaml.

>  MAINTAINERS                                   |  1 +
>  3 files changed, 60 insertions(+), 25 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
> deleted file mode 100644
> index f02f6fb7f81c..000000000000
> --- a/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -* Samsung S3FWRN5 NCI NFC Controller
> -
> -Required properties:
> -- compatible: Should be "samsung,s3fwrn5-i2c".
> -- reg: address on the bus
> -- interrupts: GPIO interrupt to which the chip is connected
> -- s3fwrn5,en-gpios: Output GPIO pin used for enabling/disabling the chip
> -- s3fwrn5,fw-gpios: Output GPIO pin used to enter firmware mode and
> -  sleep/wakeup control
> -
> -Example:
> -
> -&hsi2c_4 {
> -	s3fwrn5@27 {
> -		compatible = "samsung,s3fwrn5-i2c";
> -
> -		reg = <0x27>;
> -
> -		interrupt-parent = <&gpa1>;
> -		interrupts = <3 0 0>;
> -
> -		s3fwrn5,en-gpios = <&gpf1 4 0>;
> -		s3fwrn5,fw-gpios = <&gpj0 2 0>;
> -	};
> -};
> diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml
> new file mode 100644
> index 000000000000..c22451dea350
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml
> @@ -0,0 +1,59 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nfc/s3fwrn5.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Samsung S3FWRN5 NCI NFC Controller
> +
> +maintainers:
> +  - Krzysztof Kozlowski <krzk@kernel.org>
> +  - Krzysztof Opasiak <k.opasiak@samsung.com>
> +
> +properties:
> +  compatible:
> +    const: samsung,s3fwrn5-i2c
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  reg:
> +    maxItems: 1
> +
> +  s3fwrn5,en-gpios:
> +    maxItems: 1
> +    description:
> +      Output GPIO pin used for enabling/disabling the chip
> +
> +  s3fwrn5,fw-gpios:
> +    maxItems: 1
> +    description:
> +      Output GPIO pin used to enter firmware mode and sleep/wakeup control
> +
> +required:
> +  - compatible
> +  - interrupts
> +  - reg
> +  - s3fwrn5,en-gpios
> +  - s3fwrn5,fw-gpios

additionalProperties: false

> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    i2c4 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        s3fwrn5@27 {
> +            compatible = "samsung,s3fwrn5-i2c";
> +            reg = <0x27>;
> +
> +            interrupt-parent = <&gpa1>;
> +            interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
> +
> +            s3fwrn5,en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
> +            s3fwrn5,fw-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ac79fdbdf8d0..91b3d5c349d8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15273,6 +15273,7 @@ M:	Robert Baldyga <r.baldyga@samsung.com>
>  M:	Krzysztof Opasiak <k.opasiak@samsung.com>
>  L:	linux-nfc@lists.01.org (moderated for non-subscribers)
>  S:	Supported
> +F:	Documentation/devicetree/bindings/net/nfc/s3fwrn5.yaml
>  F:	drivers/nfc/s3fwrn5
>  
>  SAMSUNG S5C73M3 CAMERA DRIVER
> -- 
> 2.17.1
> 
