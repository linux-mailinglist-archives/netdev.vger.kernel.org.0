Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13861D051C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgEMClN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:41:13 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33972 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgEMClM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:41:12 -0400
Received: by mail-oi1-f193.google.com with SMTP id c12so19164531oic.1;
        Tue, 12 May 2020 19:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vk/gH8NIib/i4WfO/BNqo7XG45YgRMuUKBCFCVNn9K4=;
        b=SG+0zf87qoK95kbJl8aVrnAdDs8QxEe94vNGKHZo3mbpugux4pcOoiOjF3VAKpYyAN
         /8U7J50azqbbAkCe+tAEuC3ncELx7eM49r1PtbqWkckvF2mpxv7/Eopc50mx1lkivKTu
         0iAG9nIwR71DZoUuEKktBKiNhExqHZyimISpMEiCdQjX/5ETii0zokVVq5a4/DTCjJop
         HYPl8IKtmpxTw6UtwUMFCquA1SDB46mX5qTFniZPD3VCqr9XG08MeYDPDUwlMG1TVNDj
         WDZFuJflr07IyLXg9BkX8DAiZGk6FFZByjXoDI23+CRudRBT0MLFVqMn9EvcSVPuNVfD
         6QEQ==
X-Gm-Message-State: AGi0PuZiaNTKNChL89FqYYR+JEaWt1gNRbAz2iSZeiDHtGsr2HkUSMEw
        1V7xjj6F5QAmCCi7lfudcQ==
X-Google-Smtp-Source: APiQypLSWgq5+Oay+HnD2z30chqUL/969npxbmRPrn1Thwb26z2ngIk97YEqxzAvB6hlSpP74HHRRQ==
X-Received: by 2002:aca:2209:: with SMTP id b9mr15742070oic.117.1589337671421;
        Tue, 12 May 2020 19:41:11 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id j23sm58681otl.64.2020.05.12.19.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 19:41:10 -0700 (PDT)
Received: (nullmailer pid 2185 invoked by uid 1000);
        Wed, 13 May 2020 02:41:09 -0000
Date:   Tue, 12 May 2020 21:41:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 02/11] dt-bindings: new: add yaml bindings for MediaTek
 Ethernet MAC
Message-ID: <20200513024109.GA29703@bogus>
References: <20200505140231.16600-1-brgl@bgdev.pl>
 <20200505140231.16600-3-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505140231.16600-3-brgl@bgdev.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 04:02:22PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> This adds yaml DT bindings for the MediaTek Ethernet MAC present on the
> mt8* family of SoCs.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  .../bindings/net/mediatek,eth-mac.yaml        | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
> new file mode 100644
> index 000000000000..7682fe9d8109
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
> @@ -0,0 +1,80 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mediatek,eth-mac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek Ethernet MAC Controller
> +
> +maintainers:
> +  - Bartosz Golaszewski <bgolaszewski@baylibre.com>
> +
> +description:
> +  This Ethernet MAC is used on the MT8* family of SoCs from MediaTek.
> +  It's compliant with 802.3 standards and supports half- and full-duplex
> +  modes with flow-control as well as CRC offloading and VLAN tags.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - mediatek,mt8516-eth
> +      - mediatek,mt8518-eth
> +      - mediatek,mt8175-eth
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 3
> +    maxItems: 3
> +
> +  clock-names:
> +    additionalItems: false
> +    items:
> +      - const: core
> +      - const: reg
> +      - const: trans
> +
> +  mediatek,pericfg:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      Phandle to the device containing the PERICFG register range.

Perhaps say what it is used for?

> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - mediatek,pericfg
> +  - phy-handle
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/mt8516-clk.h>
> +
> +    ethernet: ethernet@11180000 {
> +        compatible = "mediatek,mt8516-eth";
> +        reg = <0 0x11180000 0 0x1000>;

Default addr and size is 1 cell.

> +        mediatek,pericfg = <&pericfg>;
> +        interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_LOW>;
> +        clocks = <&topckgen CLK_TOP_RG_ETH>,
> +                 <&topckgen CLK_TOP_66M_ETH>,
> +                 <&topckgen CLK_TOP_133M_ETH>;
> +        clock-names = "core", "reg", "trans";
> +        phy-handle = <&eth_phy>;
> +        phy-mode = "rmii";
> +
> +        mdio {

Not documented.

> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            eth_phy: ethernet-phy@0 {
> +                reg = <0>;
> +            };
> +        };
> +    };
> -- 
> 2.25.0
> 
