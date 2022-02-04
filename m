Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013434AA2D5
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344779AbiBDWHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:07:06 -0500
Received: from mail-oo1-f53.google.com ([209.85.161.53]:41940 "EHLO
        mail-oo1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344244AbiBDWHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:07:05 -0500
Received: by mail-oo1-f53.google.com with SMTP id q145-20020a4a3397000000b002e85c7234b1so6185845ooq.8;
        Fri, 04 Feb 2022 14:07:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QtAEL5mAFjL4SAlOXTLMVCmygT87AT+bBVvDPQA7iq8=;
        b=2L1/QDwjd80BcphSckslz6W0guF+abZM+o8x/kxuXHjZ3uLWvBUGA3dNwOOoSEB4lv
         7TOQlSDVjtW5O5YVs2yeVUu6NUzuL8EbrqghH7xsOcuuL8RG8GwHiiR2IJfM/4gWBXPK
         kEe7Y46liXOoiQYbQX/mNGQwTSkIDYsY5kmGTmTbm+sx/mmCsTvpJPXQkEVvO760oAOM
         Xw8jw2S7i8ezqkpUr/J8DlGuL2JVBN8yiaCEztKsHGe+QMuTxSmBHvfUp0xPRYqYt8x5
         CLTBHC+YKHaKp0M+ufNtOat6siD/Cm9QQGp7BmtdEnNbLC8InGYOjVYyly0IjyBsnEUp
         hgHg==
X-Gm-Message-State: AOAM531vQPQQf3bg/Q50oKYjEQrbmJkLSbBad6xzol127QFybYE0FoeQ
        4ZmIYElAYmQqF6IUfPCwKLPNrzYkkg==
X-Google-Smtp-Source: ABdhPJwKq0cOi2S5q54B2+hEX/owSNnnAWK9Z5jj7EhpiTN5aXIL5Z5T0EzSZ2HjEz4Akkkp6Kk2zg==
X-Received: by 2002:a05:6870:c7a8:: with SMTP id dy40mr1264985oab.33.1644012424619;
        Fri, 04 Feb 2022 14:07:04 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a128sm1217586oob.17.2022.02.04.14.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:07:03 -0800 (PST)
Received: (nullmailer pid 3264008 invoked by uid 1000);
        Fri, 04 Feb 2022 22:07:02 -0000
Date:   Fri, 4 Feb 2022 16:07:02 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        andrew@lunn.ch, leon@kernel.org
Subject: Re: [PATCH v17, 1/2] yaml: Add dm9051 SPI network yaml file
Message-ID: <Yf2jhudUnk4k69TE@robh.at.kernel.org>
References: <20220202181248.18344-1-josright123@gmail.com>
 <20220202181248.18344-2-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202181248.18344-2-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 02:12:47AM +0800, Joseph CHAMG wrote:
> From: JosephCHANG <josright123@gmail.com>
> 
> This is a new yaml base data file for configure davicom dm9051 with
> device tree

Please address my comments on v13 that still apply.

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
