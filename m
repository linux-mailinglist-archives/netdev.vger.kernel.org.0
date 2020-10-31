Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C618C2A14CB
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 10:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgJaJ1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 05:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgJaJ1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 05:27:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8C4C0613D5;
        Sat, 31 Oct 2020 02:27:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t11so9066480edj.13;
        Sat, 31 Oct 2020 02:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YKoG4ZYfmAK75REzHLyFTGpVBZ47HWY/6Oq5Ja2eDV8=;
        b=g1ggD5kGaKE0e8Gpe94g9evI2iQ15qiOIw20A5nHRKvbHw2sFurRdKgMJI92wwFuxJ
         jf3h/Hn3ha4jsKHchoFzn0b1Bqrk1R3KcACmXx/WR9GWmL6hDp5e3fQX3hCC5ZaQAfZa
         LwfnbVVvyBXf79XuSNYd6OPNs6x3WPycrNFbHuc7hCF9mvS2h/8PjCrGCqJJjXK7y+Cw
         jPEFtujDyZMm5hSpHDnxIvazjspHA282xQsXm+HisbSM1EQd3hbrodwan6bRMw0FJ7iB
         EzJqF65iKYAZqLsbTeiaTIPDNAAY2Z+73LRUWato+kqAW0QX9cxFYyJud+fX3y9fHtim
         EJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YKoG4ZYfmAK75REzHLyFTGpVBZ47HWY/6Oq5Ja2eDV8=;
        b=PYwtsH5IOeNP9mCCswr0limreP7uTCwHK6oWWA8eMgxX38SOKXQR+CqPEQXnmwRMX/
         DelU1SK52mxEA0SF4NOxyi3kdqUDU3dYhk/QHHuUX0l6oa2cPHxkajwKFQcpSnrazWDk
         EY5cQ1qWhVP0rbJ+xu32hkIFliFHPaIUzGZMcBh/NjI7TWdxgvswF6LJe9dlf4pfewiE
         85BnwQfOJshKMgCLNaWyUdkequEkXi8ACNnOkiLlgXMVWEtOFxgEhlA7O7nUQsDuVrOm
         Mpjhfn+r1trvbE3qjDRALBBBMWijYTveobiSphYNb25mdgKjyTOmBa3k8UGigAA/Lnii
         yUeg==
X-Gm-Message-State: AOAM530LajomWc5oXrSnuNXQTo+YYjn/nB+BomWt46B7tX80s/vWut8n
        gq1cgJ6UlnZF4Gj2t+7vVL0=
X-Google-Smtp-Source: ABdhPJxvwRB75NAjxdlPBWLeasxrNiqo6eK4j62FVrQhHtIrYEZKJ1kg9QGuFBTy9KB8Xxkuj86RIQ==
X-Received: by 2002:a05:6402:1112:: with SMTP id u18mr6902128edv.349.1604136465305;
        Sat, 31 Oct 2020 02:27:45 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id z20sm4612524edq.90.2020.10.31.02.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 02:27:44 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Sat, 31 Oct 2020 11:27:43 +0200
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
Message-ID: <20201031092743.pfqzear3siw5jn3e@skbuf>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030172950.12767-4-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 12:29:49PM -0500, Dan Murphy wrote:
> The DP83TD510 is a 10M single twisted pair Ethernet PHY
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83td510.yaml | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83td510.yaml b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> new file mode 100644
> index 000000000000..aef949c1cfdd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> @@ -0,0 +1,62 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2020 Texas Instruments Incorporated
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/ti,dp83td510.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: TI DP83TD510 ethernet PHY
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +  - $ref: "ethernet-phy.yaml#"
> +
> +maintainers:
> +  - Dan Murphy <dmurphy@ti.com>
> +
> +description: |
> +  The PHY is an twisted pair 10Mbps Ethernet PHY that support MII, RMII and
> +  RGMII interfaces.
> +
> +  Specifications about the Ethernet PHY can be found at:
> +    http://www.ti.com/lit/ds/symlink/dp83td510e.pdf
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +
> +  tx-fifo-depth:
> +    description: |
> +       Transmitt FIFO depth for RMII mode.  The PHY only exposes 4 nibble
> +       depths. The valid nibble depths are 4, 5, 6 and 8.
> +    enum: [ 4, 5, 6, 8 ]
> +    default: 5
> +
> +  rx-internal-delay-ps:
> +    description: |
> +       Setting this property to a non-zero number sets the RX internal delay
> +       for the PHY.  The internal delay for the PHY is fixed to 30ns relative
> +       to receive data.
> +
> +  tx-internal-delay-ps:
> +    description: |
> +       Setting this property to a non-zero number sets the TX internal delay
> +       for the PHY.  The internal delay for the PHY has a range of -4 to 4ns
> +       relative to transmit data.
> +
> +required:
> +  - reg
> +

I just got this feedback so I am passing it on.

Every dtbinding should have the additionalProperties set to false so
that dtbs_check can actually catch if there is a undefined property
used.

Ioana
