Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693E24A60CC
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240730AbiBAPzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:55:25 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:33558 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbiBAPzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:55:24 -0500
Received: by mail-oi1-f180.google.com with SMTP id x193so34252776oix.0;
        Tue, 01 Feb 2022 07:55:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BIOHVYrkUV2xJeNiNC056YPJOZ8/TdHWrOUE5wcAtsg=;
        b=6IcQLbT6/nx9LqGyJ04IzCHtbtbGt0MCoLefPPvTO9QrPquMpeDyCu+hoBL3ez3JnI
         i9cRumQxyWlKIt1+/QalEzeIp9q74WV4Dah8e0oCr+PkAYOjWt4ddOkMSNc92m9rxk6p
         8LUy6LclqJn0QVbu+VREj3mzGH2kDrKPucpji5YqwLf5MCaag+LZLjJIZDgnvPDgEz96
         tF2SPOv1omzRDrsUNvT0mhCVU6l9nhDflTsKAJAg8/HtXlG5jeSleQDDnTMkn/nczQwj
         b18KwuBdbusfVwbaxLpVL5zf1DNU3IKRGJE/oBc1oIQVzRgdu+PEcRrz+Q2AhZNDohwM
         ui9A==
X-Gm-Message-State: AOAM531VTiOF+Gt6ko9s9BHLkGdf+Rl5joHuPMGr/uvdwb0t2Rwda59Q
        RvShVQrrYfqnqB9Y+z4qcw==
X-Google-Smtp-Source: ABdhPJxBrh/ir0cmOW9wJ0tFhEtPE2+p0SLWpOeItg+jaohY58A/07Nx1NrilC1u3e7v5UKhgu1fBQ==
X-Received: by 2002:a05:6808:3098:: with SMTP id bl24mr1677697oib.312.1643730924088;
        Tue, 01 Feb 2022 07:55:24 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q14sm17568505otg.77.2022.02.01.07.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:55:23 -0800 (PST)
Received: (nullmailer pid 100417 invoked by uid 1000);
        Tue, 01 Feb 2022 15:55:22 -0000
Date:   Tue, 1 Feb 2022 09:55:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Michael Walle <michael@walle.cc>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH REBASED 2/2] dt-bindings: nvmem: cells: add MAC address
 cell
Message-ID: <YflX6kxWTD6qMnhJ@robh.at.kernel.org>
References: <20220125180114.12286-1-zajec5@gmail.com>
 <20220126070745.32305-1-zajec5@gmail.com>
 <20220126070745.32305-2-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220126070745.32305-2-zajec5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 08:07:45AM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This adds support for describing details of NVMEM cell containing MAC
> address. Those are often device specific and could be nicely stored in
> DT.
> 
> Initial documentation includes support for describing:
> 1. Cell data format (e.g. Broadcom's NVRAM uses ASCII to store MAC)
> 2. Reversed bytes flash (required for i.MX6/i.MX7 OCOTP support)
> 3. Source for multiple addresses (very common in home routers)
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  .../bindings/nvmem/cells/mac-address.yaml     | 94 +++++++++++++++++++
>  1 file changed, 94 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
> 
> diff --git a/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
> new file mode 100644
> index 000000000000..f8d19e87cdf0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
> @@ -0,0 +1,94 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/nvmem/cells/mac-address.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NVMEM cell containing a MAC address
> +
> +maintainers:
> +  - Rafał Miłecki <rafal@milecki.pl>
> +
> +properties:
> +  compatible:
> +    const: mac-address
> +
> +  format:
> +    description: |
> +      Some NVMEM cells contain MAC in a non-binary format.
> +
> +      ASCII should be specified if MAC is string formatted like:
> +      - "01:23:45:67:89:AB" (30 31 3a 32 33 3a 34 35 3a 36 37 3a 38 39 3a 41 42)
> +      - "01-23-45-67-89-AB"
> +      - "0123456789AB"
> +    enum:
> +      - ascii
> +
> +  reversed-bytes:
> +    type: boolean
> +    description: |
> +      MAC is stored in reversed bytes order. Example:
> +      Stored value: AB 89 67 45 23 01
> +      Actual MAC: 01 23 45 67 89 AB
> +
> +  base-address:
> +    type: boolean
> +    description: |
> +      Marks NVMEM cell as provider of multiple addresses that are relative to
> +      the one actually stored physically. Respective addresses can be requested
> +      by specifying cell index of NVMEM cell.

While a base address is common, aren't there different ways the base is 
modified. 

The problem with these properties is every new variation results in a 
new property and the end result is something not well designed. A unique
compatible string, "#nvmem-cell-cells" and code to interpret the data is 
more flexible.

For something like this to fly, I need some level of confidence this is 
enough for everyone for some time (IOW, find all the previous attempts 
and get those people's buy-in). You have found at least 3 cases, but I 
seem to recall more.

Rob
