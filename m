Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6E4429A83
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 02:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJLAtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 20:49:24 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:45021 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhJLAtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 20:49:24 -0400
Received: by mail-oi1-f171.google.com with SMTP id y207so23734409oia.11;
        Mon, 11 Oct 2021 17:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=poTvpzF7Q9lxXOwqWE5CBjIxUnl36yVfDL/70ZxDuU0=;
        b=1OVFrYSHgFQ3vvrh9LaA3PnIcwAUecksJNg3rnkl7hekqWesSVOZbxAiMESTXxROwQ
         ARqQ+ALngZEZMEvvfZQilOniMchFT63J7ykjlBKM07YYQ4DbYoOsMieAX96h3ukPIa9L
         k+UYhZ8TeKxcWdHt0i+3JhFZ1k5MdWAUNV26Sz+Ky+Hugiwmd4AAJGnuqHerI4DVHvUN
         52QUfBfRO0kerwKDuG497DJgOfPXVVFLIzthQE8cAnf5ZubSghUeR20A+etO6TZUbP3V
         y3Jp6mnsBrTfnuuco8/6Lxm8m3eb/Whuj537NIyiU2cBkGrHUD44riLOhrpaIbXIorMJ
         r5hA==
X-Gm-Message-State: AOAM530yYnzhsx9HQm5u8ojnpY8x0eLo9K9n0vwi/Un4mbPqfNLLg/yl
        LoZL3j0xciBuMu0TYU/E3g==
X-Google-Smtp-Source: ABdhPJzGSmuSZFEPBJaDjFQZmiYTURhJmygi0uSKOWovmVg93tr6x+ey0AByD0nfa+xwu9bjGJm7IQ==
X-Received: by 2002:aca:59d5:: with SMTP id n204mr1631076oib.142.1633999638864;
        Mon, 11 Oct 2021 17:47:18 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e2sm1796921ooa.20.2021.10.11.17.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 17:47:18 -0700 (PDT)
Received: (nullmailer pid 1479769 invoked by uid 1000);
        Tue, 12 Oct 2021 00:47:17 -0000
Date:   Mon, 11 Oct 2021 19:47:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 8/8] dt-bindings: adin1100: Add binding for ADIN1100
 Ethernet PHY
Message-ID: <YWTbFfMKk4QQh8fa@robh.at.kernel.org>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
 <20211011142215.9013-9-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011142215.9013-9-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 05:22:15PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> DT bindings for the ADIN1100 10BASE-T1L Ethernet PHY.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1100.yaml | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin1100.yaml b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
> new file mode 100644
> index 000000000000..7f98ea8fdf51
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
> @@ -0,0 +1,30 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/adi,adin1100.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Analog Devices ADIN1100 PHY
> +
> +maintainers:
> +  - Alexandru Tachici <alexandru.tachici@analog.com>
> +
> +description:
> +  Bindings for Analog Devices Industrial Low Power 10BASE-T1L Ethernet PHY

This schema doesn't do anything. ethernet-phy.yaml is already applied 
based on the node name and you haven't added any phy specific 
properties.

> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +examples:
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        10base-t1l-2.4vpp = <0>;
> +
> +        ethernet-phy@0 {
> +            compatible = "ethernet-phy-id0283.bc81";
> +            reg = <0>;
> +        };
> +    };
> -- 
> 2.25.1
> 
> 
