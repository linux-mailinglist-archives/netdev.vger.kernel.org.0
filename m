Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6534A6896
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 00:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiBAXhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 18:37:21 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:36594 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbiBAXhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 18:37:20 -0500
Received: by mail-oi1-f180.google.com with SMTP id s185so36558874oie.3;
        Tue, 01 Feb 2022 15:37:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1wzPNNppKnRmG7GhdaVHcFdeObKPyXncbl2olgh+vYk=;
        b=mA5s93Tog9xUVZEv2R90wAlFVxmYEGBAjUCbTIeJa3sGzK3dI2a6L8B1wtDTO97a3h
         t52zJMgNHiaQ5NxOUX9xgUFz1G7FsWryQww7RIcUxFff/PZ+WhoZTAfZwpH1veq+VubC
         Aygp1bYS8Iakbej+kJo40XdKhHqs46Tty61YEVQn4G0LIqwQEVAilWN7k7/7qv9xVzQq
         JRqGsA9gjP5ZFbvVuKY1UV5DUp8ajkaYPqvH8lQd3LmSZxQ1ICKWsAvxlDJRv9mMwhoe
         XjTgH7IQ5CzMdUNSoCnKUS0+JZQZr6MlU2MDWOMjOGbUxnX5YkjknJT6ZQHD+y+6IzH6
         rxjw==
X-Gm-Message-State: AOAM532NUIfL5TZj1+ao/Nyl3yY5RczLn+TazpghaphL+ZyG3aVcLZeV
        n70VA0zfSU8+lizXTRvKgA==
X-Google-Smtp-Source: ABdhPJxLSN6/Tsa9g3DSUOocW9OA1MD7EGtHI9BNYU9duePeHbY2ZHUOdFd/pN4CgpfQRCO1NKorOA==
X-Received: by 2002:a05:6808:1522:: with SMTP id u34mr2990481oiw.158.1643758639943;
        Tue, 01 Feb 2022 15:37:19 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j9sm15051021otp.23.2022.02.01.15.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 15:37:19 -0800 (PST)
Received: (nullmailer pid 969883 invoked by uid 1000);
        Tue, 01 Feb 2022 23:37:18 -0000
Date:   Tue, 1 Feb 2022 17:37:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: Re: [PATCH v13, 1/2] yaml: Add dm9051 SPI network yaml file
Message-ID: <YfnELnLfr6K0fNVY@robh.at.kernel.org>
References: <20220125085837.10357-1-josright123@gmail.com>
 <20220125085837.10357-2-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125085837.10357-2-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 04:58:36PM +0800, Joseph CHAMG wrote:
> From: JosephCHANG <josright123@gmail.com>

Follow the naming convention of the subsystem for the subject line (use 
'git log --oneline'):

dt-bindings: net: Add Davicom dm9051 SPI ethernet controller

> 
> This is a new yaml base data file for configure davicom dm9051 with
> device tree
> 
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: JosephCHANG <josright123@gmail.com>
> ---
>  .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> new file mode 100644
> index 000000000000..52e852fef753
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> @@ -0,0 +1,62 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/davicom,dm9051.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Davicom DM9051 SPI Ethernet Controller
> +
> +maintainers:
> +  - Joseph CHANG <josright123@gmail.com>
> +
> +description: |
> +  The DM9051 is a fully integrated and cost-effective low pin count single
> +  chip Fast Ethernet controller with a Serial Peripheral Interface (SPI).
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    const: davicom,dm9051
> +
> +  reg:
> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 45000000
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  local-mac-address: true
> +
> +  mac-address: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - spi-max-frequency
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  # Raspberry Pi platform
> +  - |
> +    /* for Raspberry Pi with pin control stuff for GPIO irq */
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/gpio/gpio.h>
> +    spi {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethernet@0 {
> +            compatible = "davicom,dm9051";
> +            reg = <0>; /* spi chip select */
> +            local-mac-address = [00 00 00 00 00 00];
> +            interrupt-parent = <&gpio>;
> +            interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
> +            spi-max-frequency = <31200000>;
> +        };
> +    };
> -- 
> 2.20.1
> 
> 
