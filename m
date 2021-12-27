Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA524801AA
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 17:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhL0Qgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 11:36:36 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]:40600 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhL0Qgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 11:36:35 -0500
Received: by mail-qt1-f176.google.com with SMTP id l17so13900536qtk.7;
        Mon, 27 Dec 2021 08:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NvWv4FZyIrN5nkG1K4g0aTLhjlCARTmPaNYGMqKugSc=;
        b=5GsOjXRMGLxcMMHdatIGk/JUkHA3TPGVd9QQ9uW5H4KwDcZpzvizpzKbyu4vtBoW0B
         7sEtTb3s5c9y2wLdWFMGXqMJWNvxXPzOgkWCtgvJCNLQfmsJz+tfCEZlImQcJWsQutnT
         fPjp4MJPC8OYM2QaVOh93SaN/SqLEiMJwMZ83lqXrvgwoLun6ltlz5+2b2nMhsrXYKr4
         3hVgi/q+jxlH+qrnGeqRUTNkiwa9f7AMIc8WKhP+pVq4+HDker7F5in/Bi/W4k6CrqC+
         YKBNsdG69Zjxlz8NnxjreyECVYrqDaP4eksBafFnqq14wJTdGv45rxqmQ28zQdiAhYlE
         X3bw==
X-Gm-Message-State: AOAM531yWoHB5OLV9iIz1QG7SleCgHkpGUAuLss6JLCQk505lj7WvQAN
        M1uWgvl3EkNL7ehFRyXPgw==
X-Google-Smtp-Source: ABdhPJzZshfJsJcm/yRFsND6Ah0/cdHd3EQ/kiIvKCMIIlxDD8VMQBD0jLJZB8JuOMfoeC9tnV9gwQ==
X-Received: by 2002:ac8:4e4b:: with SMTP id e11mr15629813qtw.503.1640622994883;
        Mon, 27 Dec 2021 08:36:34 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id r16sm13658375qta.46.2021.12.27.08.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 08:36:34 -0800 (PST)
Received: (nullmailer pid 617864 invoked by uid 1000);
        Mon, 27 Dec 2021 16:36:31 -0000
Date:   Mon, 27 Dec 2021 12:36:31 -0400
From:   Rob Herring <robh@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH 01/34] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
Message-ID: <YcnrjySZ9mPbkidZ@robh.at.kernel.org>
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-2-marcan@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211226153624.162281-2-marcan@marcan.st>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 12:35:51AM +0900, Hector Martin wrote:
> This binding is currently used for SDIO devices, but these chips are
> also used as PCIe devices on DT platforms and may be represented in the
> DT. Re-use the existing binding and add chip compatibles used by Apple
> T2 and M1 platforms (the T2 ones are not known to be used in DT
> platforms, but we might as well document them).
> 
> Then, add properties required for firmware selection and calibration on
> M1 machines.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../net/wireless/brcm,bcm4329-fmac.yaml       | 32 +++++++++++++++++--
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> index c11f23b20c4c..2530ff3e7b90 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM4329 family fullmac wireless SDIO devices
> +title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
>  
>  maintainers:
>    - Arend van Spriel <arend@broadcom.com>
> @@ -36,16 +36,22 @@ properties:
>                - brcm,bcm43455-fmac
>                - brcm,bcm43456-fmac
>                - brcm,bcm4354-fmac
> +              - brcm,bcm4355c1-fmac
>                - brcm,bcm4356-fmac
>                - brcm,bcm4359-fmac
> +              - brcm,bcm4364b2-fmac
> +              - brcm,bcm4364b3-fmac
> +              - brcm,bcm4377b3-fmac
> +              - brcm,bcm4378b1-fmac
> +              - brcm,bcm4387c2-fmac
>                - cypress,cyw4373-fmac
>                - cypress,cyw43012-fmac
>            - const: brcm,bcm4329-fmac
>        - const: brcm,bcm4329-fmac
>  
>    reg:
> -    description: SDIO function number for the device, for most cases
> -      this will be 1.
> +    description: SDIO function number for the device (for most cases
> +      this will be 1) or PCI device identifier.
>  
>    interrupts:
>      maxItems: 1
> @@ -75,6 +81,26 @@ properties:
>      items:
>        pattern: '^[A-Z][A-Z]-[A-Z][0-9A-Z]-[0-9]+$'
>  
> +  brcm,cal-blob:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description: A per-device calibration blob for the Wi-Fi radio. This
> +      should be filled in by the bootloader from platform configuration
> +      data, if necessary, and will be uploaded to the device if present.
> +
> +  apple,module-instance:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Module codename used to identify a specific board on
> +      Apple platforms. This is used to build the firmware filenames, to allow
> +      different platforms to have different firmware and/or NVRAM config.
> +
> +  apple,antenna-sku:
> +    $def: /schemas/types.yaml#/definitions/string
> +    description: Antenna SKU used to identify a specific antenna configuration
> +      on Apple platforms. This is use to build firmware filenames, to allow
> +      platforms with different antenna configs to have different firmware and/or
> +      NVRAM. This would normally be filled in by the bootloader from platform
> +      configuration data.

Is there a known set of strings that can be defined?

There's also the somewhat standard 'firmware-name' property that serves 
similar purpose, but if there's multiple files, then I guess this 
approach is fine.

Rob
