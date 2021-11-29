Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DC7462326
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 22:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhK2VZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 16:25:33 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:41955 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhK2VXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 16:23:32 -0500
Received: by mail-oi1-f180.google.com with SMTP id u74so37101858oie.8;
        Mon, 29 Nov 2021 13:20:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/jIaWBgsu+oXpJeAi+fCw5Zfn9VqgsViSXmHREtQW7w=;
        b=jiNRV0fjVWGIGMo9jpqsKrak7J+M5LXmzf9rKkOhIFXmnJINq7bzMNwMEEp0LnhG0M
         T3rp3pQGzNDNi9WnUTw7C0Sykc5mwUFC+hA7gHIukkCmjoDX+ruWKfXZuJXhK7kYDRnP
         QoxI+60myMXMJW27oTQpuWwSwoxgc51sv9fUunf3fL/F+iiwHkFbVPUiYkEHlb1qvkXQ
         L7Z1ysGsZUVnpxpgV7X/2toBJPWrqDsvtXST/iqsjKTy4Re7mAKeS60X5yIjjmtUv5OW
         VWnfbEN39rkBI1+rvjqoTYbFLE2SgR2ur9CQKrOzJlYJ4Juqym0JE1pYJL6008tRm2im
         FqtQ==
X-Gm-Message-State: AOAM532e018Vepp8Bf5NLABB755bW0KJa5WUM/VwvpUn8O/Ed7A1aQPU
        QhlAreVrcUQFkTCQyypRnw==
X-Google-Smtp-Source: ABdhPJw7JLYoJIiNdZPrVY+5nvjVbUowzZ3MObEEaLWLC03o6BfX8vvMU9eNhvf28bYd6piz0cD9Lw==
X-Received: by 2002:a05:6808:13d3:: with SMTP id d19mr497944oiw.149.1638220814426;
        Mon, 29 Nov 2021 13:20:14 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t13sm3343185oiw.30.2021.11.29.13.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 13:20:13 -0800 (PST)
Received: (nullmailer pid 629158 invoked by uid 1000);
        Mon, 29 Nov 2021 21:20:12 -0000
Date:   Mon, 29 Nov 2021 15:20:12 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: improve port
 definition documentation
Message-ID: <YaVEDN2unmq7O4Ob@robh.at.kernel.org>
References: <20211112165752.1704-1-ansuelsmth@gmail.com>
 <20211112165752.1704-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112165752.1704-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 05:57:52PM +0100, Ansuel Smith wrote:
> Clean and improve port definition for qca8k documentation by referencing
> the dsa generic port definition and adding the additional specific port
> definition.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 82 ++++++-------------
>  1 file changed, 23 insertions(+), 59 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 48de0ace265d..9eb24cdf6cd4 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -99,65 +99,29 @@ patternProperties:
>          type: object
>          description: Ethernet switch ports
>  
> -        properties:
> -          reg:
> -            description: Port number
> -
> -          label:
> -            description:
> -              Describes the label associated with this port, which will become
> -              the netdev name
> -            $ref: /schemas/types.yaml#/definitions/string
> -
> -          link:
> -            description:
> -              Should be a list of phandles to other switch's DSA port. This
> -              port is used as the outgoing port towards the phandle ports. The
> -              full routing information must be given, not just the one hop
> -              routes to neighbouring switches
> -            $ref: /schemas/types.yaml#/definitions/phandle-array
> -
> -          ethernet:
> -            description:
> -              Should be a phandle to a valid Ethernet device node.  This host
> -              device is what the switch port is connected to
> -            $ref: /schemas/types.yaml#/definitions/phandle
> -
> -          phy-handle: true
> -
> -          phy-mode: true
> -
> -          fixed-link: true
> -
> -          mac-address: true
> -
> -          sfp: true
> -
> -          qca,sgmii-rxclk-falling-edge:
> -            $ref: /schemas/types.yaml#/definitions/flag
> -            description:
> -              Set the receive clock phase to falling edge. Mostly commonly used on
> -              the QCA8327 with CPU port 0 set to SGMII.
> -
> -          qca,sgmii-txclk-falling-edge:
> -            $ref: /schemas/types.yaml#/definitions/flag
> -            description:
> -              Set the transmit clock phase to falling edge.
> -
> -          qca,sgmii-enable-pll:
> -            $ref: /schemas/types.yaml#/definitions/flag
> -            description:
> -              For SGMII CPU port, explicitly enable PLL, TX and RX chain along with
> -              Signal Detection. On the QCA8327 this should not be enabled, otherwise
> -              the SGMII port will not initialize. When used on the QCA8337, revision 3
> -              or greater, a warning will be displayed. When the CPU port is set to
> -              SGMII on the QCA8337, it is advised to set this unless a communication
> -              issue is observed.
> -
> -        required:
> -          - reg
> -
> -        additionalProperties: false
> +        allOf:
> +          - $ref: dsa-port.yaml#
> +          - properties:

You can drop 'allOf' here too. And add 'unevaluatedProperties: false'.

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

> +              qca,sgmii-rxclk-falling-edge:
> +                $ref: /schemas/types.yaml#/definitions/flag
> +                description:
> +                  Set the receive clock phase to falling edge. Mostly commonly used on
> +                  the QCA8327 with CPU port 0 set to SGMII.
> +
> +              qca,sgmii-txclk-falling-edge:
> +                $ref: /schemas/types.yaml#/definitions/flag
> +                description:
> +                  Set the transmit clock phase to falling edge.
> +
> +              qca,sgmii-enable-pll:
> +                $ref: /schemas/types.yaml#/definitions/flag
> +                description:
> +                  For SGMII CPU port, explicitly enable PLL, TX and RX chain along with
> +                  Signal Detection. On the QCA8327 this should not be enabled, otherwise
> +                  the SGMII port will not initialize. When used on the QCA8337, revision 3
> +                  or greater, a warning will be displayed. When the CPU port is set to
> +                  SGMII on the QCA8337, it is advised to set this unless a communication
> +                  issue is observed.
>  
>  oneOf:
>    - required:
> -- 
> 2.32.0
> 
> 
