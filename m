Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46FCEAB9D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfJaIfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:35:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50341 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbfJaIfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:35:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id 11so4949323wmk.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 01:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rmDq6FxRuUYkoax7fknWg9lZtSi88FQnuHiD1s4eg5U=;
        b=r19RbJrrR3TTQRFvNVgH7muc0VuAYAy6rKwAenBj+MBaMLmAwvooeA4uJPujOZH/3f
         Z38+un06J7GpZ7qzlIBluqhhNCKQaWpQMA676w27Uq3/NB3ccSjBROSFDlaPHO1d4VHG
         IJrmYs9psQzlLCLW1tNvWUHfZ5FD3R+nqfWbEJQWVUHNzGo1biYTUC47PS4wDJYYoNdB
         efvLI/52efMQGN2fhxcU3VXQUIWQIzCIuhCef1hEsbPzN6iWNVoVX7W4Rx1VirV8VhAT
         C6K1MLxvnxYyF2hCKEzWrb24APK5ufdQEoK8a7DMjJzeFDQQmPGQ5GSzPZ/glg65NJDL
         kEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rmDq6FxRuUYkoax7fknWg9lZtSi88FQnuHiD1s4eg5U=;
        b=QHNdtBz8t3mqaSv7H5Ze+Ug8HqDhlZxXacw2iDCmjgIR0DNv0LBi7YtQGOqh9z7BCE
         12xKJ2WJ6WSOH/jcbAJ/IdycFgCstIV9kBvNJgLk5r7nM11S3zg249u/CZNDRm/FH1qO
         TEFFG9YC5jVZp3ogPUFjNw/1GCJFXURKFNKn1ukj9NQ9++ag47oOcftMzLwB9B6YbM3G
         /UNVd1/I8FGL9FcS8EZT+cwzMJe9sDjka7GJ+e9qabGLzgDEtm+03lClxxeF/W14ekMA
         Urt/kwU7IYbVnVqK1C3Mrw8vGgOGlu6E2x9ihP3l6+IwKu7nRN0A1krzCAewAme3L/wJ
         fGNg==
X-Gm-Message-State: APjAAAWBUi4+7yK8p/GveRgNqaRx+5SxOCu4o6p/jrgIDxi3Xnf4oCP7
        lKQqSqZk5Vxm/POmojCCWLx1hA==
X-Google-Smtp-Source: APXvYqzFt/7CmZZG28e813dIiqfXPdkh/FrOn1ZW0fYjE3EhnPpwhz4KlImOvd6t8BDPMhbuXOGzHQ==
X-Received: by 2002:a1c:3b44:: with SMTP id i65mr3744553wma.1.1572510912455;
        Thu, 31 Oct 2019 01:35:12 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id 11sm3233576wmb.34.2019.10.31.01.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 01:35:12 -0700 (PDT)
Date:   Thu, 31 Oct 2019 09:35:10 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, axboe@kernel.dk,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, bhelgaas@google.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/5] dt-bindings: net: document loongson.pci-gmac
Message-ID: <20191031083509.GA30739@netronome.com>
References: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
 <20191030135347.3636-5-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030135347.3636-5-jiaxun.yang@flygoat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiaxun,

thanks for your patch.

On Wed, Oct 30, 2019 at 09:53:46PM +0800, Jiaxun Yang wrote:
> This binding will provide extra information for PCI enabled
> device.
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

Please verify the bindings using dtbs_check as described in
Documentation/devicetree/writing-schema.rst

> ---
>  .../net/wireless/loongson,pci-gmac.yaml       | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml b/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
> new file mode 100644
> index 000000000000..5f764bd46735
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
> @@ -0,0 +1,71 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/allwinner,sun7i-a20-gmac.yaml#

The id does not match the filename of the schema.

i.e. the above should be:

	$id: http://devicetree.org/schemas/net/wireless/loongson,pci-gmac.yaml#

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Loongson PCI GMAC Device Tree Bindings
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"

snps,dwmac.yaml# is in the parent directory relative to loongson,pci-gmac.yaml.
So I think the above needs to be:

	$ref: "../snps,dwmac.yaml#"

> +
> +maintainers:
> +  - Jiaxun Yang <jiaxun.yang@flygoat.com>
> +
> +properties:
> +  compatible:
> +    const: loongson,pci-gmac
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 1
> +    maxItems: 3
> +    items:
> +      - description: Combined signal for various interrupt events
> +      - description: The interrupt to manage the remote wake-up packet detection
> +      - description: The interrupt that occurs when Rx exits the LPI state
> +
> +  interrupt-names:
> +    minItems: 1
> +    maxItems: 3
> +    items:
> +      - const: macirq
> +      - const: eth_wake_irq
> +      - const: eth_lpi
> +
> +  clocks:
> +    items:
> +      - description: GMAC main clock
> +
> +  clock-names:
> +    items:
> +      - const: stmmaceth
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - phy-mode
> +
> +examples:
> +  - |
> +    gmac: ethernet@ {

I would have expected a bus address here, f.e.:

	gmac: ethernet@0x00001800

> +        compatible = "loongson,pci-irq";
> +        reg = <0x00001800 0 0 0 0>;

I think there is one to many cell in the above, perhaps it should be.

	reg = <0x00001800 0 0 0>;

Also, I would expect the registers to be wider than 0, i.e. no registers.

`
> +        interrupts = <12>, <13>;
> +        interrupt-names = "macirq", "eth_lpi";
> +        clocks =  <&clk_pch_gmac>;
> +        clock-names = "stmmaceth";
> +        phy-mode = "rgmii";
> +    };
> +
> +# FIXME: We should set it, but it would report all the generic
> +# properties as additional properties.
> +# additionalProperties: false
> +
> +...
> -- 
> 2.23.0
> 
