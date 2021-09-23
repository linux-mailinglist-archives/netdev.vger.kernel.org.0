Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373AD415ECB
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbhIWMuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:50:52 -0400
Received: from mail-oo1-f50.google.com ([209.85.161.50]:36388 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241000AbhIWMut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:50:49 -0400
Received: by mail-oo1-f50.google.com with SMTP id y47-20020a4a9832000000b00290fb9f6d3fso2105359ooi.3;
        Thu, 23 Sep 2021 05:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=32AqBVXNroHHsS62jPgtjGmkNYUjzZq0gtkFGRv5Kts=;
        b=QiNPgKSUqDKTH9H9y8dT2q728sI88rkv23iDSNHzDIgcleesdPtTdzzUPqn2dER87d
         m9n/PW610BbUH8/mPQ6qRh+LSlf4pK1lz9CIPrZjObrPdaXmmmg3NqT08qjp7yNsfihK
         c28vGUfNBjpbgJMhq/R+YFkuILDp0/xgBwv56KBQnXBfGvQsKWdBNTcZgiuDneKxq3VU
         0aJzs6yWKXwn/lW9nmqI2Hm9UhMahvHxBxQSF9DQsSEgX5vj/YTJZzKkC2G0/6L56+CS
         2058mjgR+AWXytKgVQ2XBmgfJ6nDs6BydDmNoG+2rElKjbHAygB9HxPCT04gPYjfzSn6
         lieg==
X-Gm-Message-State: AOAM531ZOpOSGzlyRz7LiTllBPN3HXXvM054z39Uml8sUWBjEHw6raN5
        gO+Tr7wtmryNRYo0XN9KRQ==
X-Google-Smtp-Source: ABdhPJy/+1msRjPfYSZItQTF2FX/XSozQKcIBXilhnC8CsG6TfKUKNsiC4VyOE3zFEDTwvBP8VIx/w==
X-Received: by 2002:a4a:ba90:: with SMTP id d16mr1257550oop.31.1632401343915;
        Thu, 23 Sep 2021 05:49:03 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id i27sm1277529ots.12.2021.09.23.05.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:49:03 -0700 (PDT)
Received: (nullmailer pid 2828726 invoked by uid 1000);
        Thu, 23 Sep 2021 12:49:02 -0000
Date:   Thu, 23 Sep 2021 07:49:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 04/12] dt-bindings: reset: Add lan966x
 switch reset bindings
Message-ID: <YUx3vuQQbHVbpcTh@robh.at.kernel.org>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-5-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:10AM +0200, Horatiu Vultur wrote:
> Document the lan966x switch reset device driver bindings
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../bindings/reset/lan966x,rst.yaml           | 58 +++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reset/lan966x,rst.yaml
> 
> diff --git a/Documentation/devicetree/bindings/reset/lan966x,rst.yaml b/Documentation/devicetree/bindings/reset/lan966x,rst.yaml
> new file mode 100644
> index 000000000000..97d6334e4e0a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reset/lan966x,rst.yaml
> @@ -0,0 +1,58 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/reset/lan966x,rst.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Microchip lan966x Switch Reset Controller
> +
> +maintainers:
> +  - Horatiu Vultur <horatiu.vultur@microchip.com>
> +  - UNGLinuxDriver@microchip.com
> +
> +description: |
> +  The Microchip lan966x Switch provides reset control and implements the
> +  following
> +  functions
> +    - One Time Switch Core Reset (Soft Reset)

This looks like just some grouping of separate reset controllers. If 
there are 3 h/w blocks providing resets, then the DT should have 3 reset 
providers.

> +
> +properties:
> +  $nodename:
> +    pattern: "^reset-controller$"

Don't use 'pattern' for fixed strings.

> +
> +  compatible:
> +    const: microchip,lan966x-switch-reset
> +
> +  "#reset-cells":
> +    const: 1
> +
> +  cpu-syscon:
> +    $ref: "/schemas/types.yaml#/definitions/phandle"
> +    description: syscon used to access CPU reset
> +
> +  switch-syscon:
> +    $ref: "/schemas/types.yaml#/definitions/phandle"
> +    description: syscon used to access SWITCH reset
> +
> +  chip-syscon:
> +    $ref: "/schemas/types.yaml#/definitions/phandle"
> +    description: syscon used to access CHIP reset
> +
> +required:
> +  - compatible
> +  - "#reset-cells"
> +  - cpu-syscon
> +  - switch-syscon
> +  - chip-syscon
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    reset: reset-controller {
> +        compatible = "microchip,lan966x-switch-reset";
> +        #reset-cells = <1>;
> +        cpu-syscon = <&cpu_ctrl>;
> +        switch-syscon = <&switch_ctrl>;
> +        chip-syscon = <&chip_ctrl>;
> +    };
> -- 
> 2.31.1
> 
> 
