Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F1F1E68D4
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 19:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405643AbgE1Rsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 13:48:39 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:43475 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405580AbgE1Rsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 13:48:38 -0400
Received: by mail-il1-f193.google.com with SMTP id l20so1045594ilj.10;
        Thu, 28 May 2020 10:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xA+8ZtZwDMfjZ7DO84uhGqtfaAhbDdUqKkUCy7pUj1U=;
        b=o+w1UfduJs4do4KLMy2/g5AVIuhSXOK4cAOa15yjsKwBZ6gXzX5ymR1x3XRfcKQeDk
         TAeQuKDdbm3LNzC7YRnSxoXUtaL2heRpuK0bK9U4abmNtX/fo4WSNViENyR9oOVg6r6e
         C5IeUi2S0+qG0N13H/FWu2SK/HHR1h72uoXaseXvPB+wgvUxdaMgImXKNQ+TNqQLTAH8
         4MOQtuDXcT2cDshJmIFKllsWvPacndCYGKIpOsjKoSOm2IIe0/uMvFVKcabBcJwYoPoW
         txx9tgJbLp6/Yl++p+OZcAvUP8rcqewksppxw1cxnB8uaptyKRoshswa3qNXZswflmwv
         E7xQ==
X-Gm-Message-State: AOAM532SC8b9xve2eQ31R4wLptZt7Wg8kUBG+eZMAqQnLlI2gUP0f/g+
        nsZXCfZY7f7guP4gzBXNrImNaYM=
X-Google-Smtp-Source: ABdhPJwzEtC0+3YsXMxFaCJjXuihCzBokX+wvcFWsqh4QHEzCQNWPg5pzbjV9o2mQN+7xsl1C7j/7w==
X-Received: by 2002:a92:b111:: with SMTP id t17mr3992506ilh.241.1590688117320;
        Thu, 28 May 2020 10:48:37 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id r20sm3682147ilk.44.2020.05.28.10.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 10:48:36 -0700 (PDT)
Received: (nullmailer pid 386101 invoked by uid 1000);
        Thu, 28 May 2020 17:48:35 -0000
Date:   Thu, 28 May 2020 11:48:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dp83822: Add TI dp83822
 phy
Message-ID: <20200528174835.GA362519@bogus>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514173055.15013-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:30:54PM -0500, Dan Murphy wrote:
> Add a dt binding for the TI dp83822 ethernet phy device.
> 
> CC: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83822.yaml   | 49 +++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
> new file mode 100644
> index 000000000000..60afd43ad3b6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)
> +# Copyright (C) 2020 Texas Instruments Incorporated
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/ti,dp83822.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: TI DP83822 ethernet PHY
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"

Not an ethernet controller. Drop. (The ethernet-phy.yaml schema will be 
applied based on node name).

> +
> +maintainers:
> +  - Dan Murphy <dmurphy@ti.com>
> +
> +description: |
> +  The DP83822 is a low-power, single-port, 10/100 Mbps Ethernet PHY. It
> +  provides all of the physical layer functions needed to transmit and receive
> +  data over standard, twisted-pair cables or to connect to an external,
> +  fiber-optic transceiver. Additionally, the DP83822 provides flexibility to
> +  connect to a MAC through a standard MII, RMII, or RGMII interface
> +
> +  Specifications about the charger can be found at:
> +    http://www.ti.com/lit/ds/symlink/dp83822i.pdf
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +
> +  ti,signal-polarity-low:

What signal? 

> +    type: boolean
> +    description: |
> +       DP83822 PHY in Fiber mode only.
> +       Sets the DP83822 to detect a link drop condition when the signal goes
> +       high.  If not set then link drop will occur when the signal goes low.

The naming is not clear that low is for link drop. So maybe:

ti,link-loss-low

Rob
