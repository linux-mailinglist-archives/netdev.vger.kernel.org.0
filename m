Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D17CF73DE
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKM3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:29:08 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52522 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfKKM3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:29:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id l1so1742494wme.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 04:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dSewQoeACmq1i1jpvr49vxw60LKl1U3C6WonRLxoHo0=;
        b=m742fK844x/AKk8KLUcMNI/xB3PL7U/PKYIrZRbBI6HHBHB0Xftdnqn+CdxGBajHiU
         qf/+lGuVOwdsUcByXWOoq/4uWy+RyPAHX+FmSkh8ivk3IZJGEMcRK5s1U9PG6pctruAU
         x5cdMfvqDVbx9PpWanjh+YnIsNlR7xKuTDuyChMjREHTPvLJkhQZ0Mz5Kp4aFScRUtKy
         VY/yBirGXm6Ex8bwo0kQzpK+jJyz+juMYkp3GOgMwtP7DUNJdtpzHghBe6MIPTjJf55T
         cmrW18SFS6MUx5JKGDvhlVfYSbYwOiNZ7+HzSR9v+xtby+FIjUHWluguBGptbDkXrn8V
         ViFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dSewQoeACmq1i1jpvr49vxw60LKl1U3C6WonRLxoHo0=;
        b=n6IRrdRlqVcHYJ1WbjFLqqDKswRXl32CvBnFdMZDDSd1gRcK8W3l+tGeGYljhvY+ze
         1RYBxCvKYanSA8Z4Oko1tHrtU0+LWJD6B6HiQOlE5DFAj56GHJUKjwTKbQ/LvaGQeo3D
         BafOiS2Do7tiPBuZVc8vE6xnRL28CbbiMzb3fpnmwspoyBVw4t9g0ONOEHGesbHbY02n
         3lHTKQnQed3EqTcpq6VxI5OG4T5ghpfH+AXVPX7vDZpBZSHEfcdAhWFgQ2m2CeQPF/sg
         GNVGBrO0MqU6NM69YDEKyyFmq6egop5Zvs2pIfRcFvGV7k70htppgvDC39zveUl/8O0Z
         kuug==
X-Gm-Message-State: APjAAAUz+5FiY8AiPl+UssskdOXcUgvwVR9H3xOoagw3eBAfCpSRNC5J
        gLYEhcJXzePVu/iQha4L34h7Wg==
X-Google-Smtp-Source: APXvYqyZIKxeXx4xEQ1NF4pOosCu14x+2PE3xpwtY7eYZ1cc7Li7ooYJvY2hEnMV6QiKRzLBKjnX6Q==
X-Received: by 2002:a7b:c768:: with SMTP id x8mr21085407wmk.26.1573475344622;
        Mon, 11 Nov 2019 04:29:04 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id y2sm22728920wmy.2.2019.11.11.04.29.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Nov 2019 04:29:04 -0800 (PST)
Date:   Mon, 11 Nov 2019 13:29:03 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: dp83869: Add TI dp83869 phy
Message-ID: <20191111122902.567r2geh4popqknq@netronome.com>
References: <20191107174002.11227-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107174002.11227-1-dmurphy@ti.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 11:40:01AM -0600, Dan Murphy wrote:
> Add dt bindings for the TI dp83869 Gigabit ethernet phy
> device.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> CC: Rob Herring <robh+dt@kernel.org>
> ---
> 
> v2 - No changes 
> 
>  .../devicetree/bindings/net/ti,dp83869.yaml   | 84 +++++++++++++++++++
>  1 file changed, 84 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83869.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> new file mode 100644
> index 000000000000..6fe3e451da8a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> @@ -0,0 +1,84 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2019 Texas Instruments Incorporated
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/ti,dp83869.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: TI DP83869 ethernet PHY
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +
> +maintainers:
> +  - Dan Murphy <dmurphy@ti.com>
> +
> +description: |
> +  The DP83869HM device is a robust, fully-featured Gigabit (PHY) transceiver
> +  with integrated PMD sublayers that supports 10BASE-Te, 100BASE-TX and
> +  1000BASE-T Ethernet protocols. The DP83869 also supports 1000BASE-X and
> +  100BASE-FX Fiber protocols.
> +  This device interfaces to the MAC layer through Reduced GMII (RGMII) and
> +  SGMII The DP83869HM supports Media Conversion in Managed mode. In this mode,
> +  the DP83869HM can run 1000BASE-X-to-1000BASE-T and 100BASE-FX-to-100BASE-TX
> +  conversions.  The DP83869HM can also support Bridge Conversion from RGMII to
> +  SGMII and SGMII to RGMII.
> +
> +  Specifications about the charger can be found at:
> +    http://www.ti.com/lit/ds/symlink/dp83869hm.pdf
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +
> +  ti,min-output-impedance:
> +    type: boolean
> +    description: |
> +       MAC Interface Impedance control to set the programmable output impedance
> +       to a minimum value (35 ohms).
> +
> +  ti,max-output-impedance:
> +    type: boolean
> +    description: |
> +       MAC Interface Impedance control to set the programmable output impedance
> +       to a maximum value (70 ohms).
> +
> +  tx-fifo-depth:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +       Transmitt FIFO depth see dt-bindings/net/ti-dp83869.h for values
> +
> +  rx-fifo-depth:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +       Receive FIFO depth see dt-bindings/net/ti-dp83869.h for values
> +
> +  ti,clk-output-sel:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +       Muxing option for CLK_OUT pin see dt-bindings/net/ti-dp83869.h for values.
> +
> +  ti,op-mode:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +       Operational mode for the PHY.  If this is not set then the operational
> +       mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
> +
> +required:
> +  - reg
> +
> +examples:
> +  - |
> +    #include <dt-bindings/net/ti-dp83869.h>

The header above does not exist until patch 2 is applied.
Which means that make dtbs_check fails.

Perhaps adding the header could be moved into this patch?

> +    mdio0 {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      ethphy0: ethernet-phy@0 {
> +        reg = <0>;
> +        tx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
> +        rx-fifo-depth = <DP83869_PHYCR_FIFO_DEPTH_4_B_NIB>;
> +        ti,op-mode = <DP83869_RGMII_COPPER_ETHERNET>;
> +        ti,max-output-impedance = "true";
> +        ti,clk-output-sel = <DP83869_CLK_O_SEL_CHN_A_RCLK>;
> +      };
> +    };
> -- 
> 2.22.0.214.g8dca754b1e
> 
