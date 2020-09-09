Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F1B26384B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgIIVP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:15:56 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42936 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIVPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:15:55 -0400
Received: by mail-io1-f67.google.com with SMTP id u6so4764951iow.9;
        Wed, 09 Sep 2020 14:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=lyqQQMVpyPt4g281ZC1tAF0lH2Dn5fwBGNRSkwvKTw8=;
        b=qOBBGsyFrF/7AiCYA8PXJr8phr+Qsu/Jk2/VQTjPmOlSWiI4igeUDwTchcRdMQR0wn
         F3oBI0NLNU+6crWYi5C4qJoKPcIfDzCLGV4uQonP+MXQdoT84XkWDuzffVe2NZcn5BRn
         HUNPN9CYoJ4ZaP3SWSuBGLxR2p/Ov0XMrveDz3gLg5DTR3Jre2dHXMKnjDtkUA9OA4+T
         OIUnWj735QSg0pQbRF7RvpqxYw9/Vt+4bD560O02/TbLkQ6Sgn4jA2qbFy7ERq/R1PlA
         /3DMUMGrBLk2DKKw7PY68EViEEkYvRBiOTuUfGM0f2iyBwx5951kQqrNj4dNUe/DoQlL
         /V0g==
X-Gm-Message-State: AOAM531fMYjFIj0Sxdy5uWZ6mWADLf4aQqxr+BYX7CmxfoNcslgEolp0
        D2GQpjEJ0kp1Em/9vsz3AQ==
X-Google-Smtp-Source: ABdhPJzSTRSFo7o8vKMpqBaz5cjJ4sWQ/Y9MvwYh1ZFwZFWnbgymWaBDslRLk7NL6zP+xpbdHWcdCw==
X-Received: by 2002:a6b:f801:: with SMTP id o1mr4962313ioh.43.1599686153545;
        Wed, 09 Sep 2020 14:15:53 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id p12sm1279074iom.47.2020.09.09.14.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 14:15:52 -0700 (PDT)
Received: (nullmailer pid 3087549 invoked by uid 1000);
        Wed, 09 Sep 2020 21:15:52 -0000
Date:   Wed, 9 Sep 2020 15:15:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909211552.GA3066273@bogus>
References: <20200909162552.11032-1-marek.behun@nic.cz>
 <20200909162552.11032-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909162552.11032-2-marek.behun@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 06:25:46PM +0200, Marek Behún wrote:
> Document binding for LEDs connected to and controlled by various chips
> (such as ethernet PHY chips).

If they are h/w controlled, then why are they in DT?

> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> ---
>  .../leds/linux,hw-controlled-leds.yaml        | 99 +++++++++++++++++++
>  1 file changed, 99 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> 
> diff --git a/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> new file mode 100644
> index 0000000000000..eaf6e5d80c5f5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> @@ -0,0 +1,99 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/leds/linux,hw-controlled-leds.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LEDs that can be controlled by hardware (eg. by an ethernet PHY chip)
> +
> +maintainers:
> +  - Marek Behún <marek.behun@nic.cz>
> +
> +description:
> +  Many an ethernet PHY (and other chips) supports various HW control modes
> +  for LEDs connected directly to them. With this binding such LEDs can be
> +  described.
> +
> +properties:
> +  compatible:
> +    const: linux,hw-controlled-leds

What makes this linux specific?

Unless you're going to make this h/w specific, then it probably should 
just be dropped. 

The phy schema will need:

leds:
  type: object
  $ref: /schemas/leds/hw-controlled-leds.yaml#

> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +patternProperties:
> +  "^led@[0-9a-f]+$":
> +    type: object
> +    allOf:
> +      - $ref: common.yaml#
> +    description:
> +      This node represents a LED device connected to a chip that can control
> +      the LED in various HW controlled modes.
> +
> +    properties:
> +      reg:
> +        maxItems: 1
> +        description:
> +          This property identifies the LED to the chip the LED is connected to
> +          (eg. an ethernet PHY chip can have multiple LEDs connected to it).
> +
> +      enable-active-high:
> +        description:
> +          Polarity of LED is active high. If missing, assumed default is active
> +          low.
> +        type: boolean
> +
> +      led-tristate:
> +        description:
> +          LED pin is tristate type. If missing, assumed false.
> +        type: boolean
> +
> +      linux,default-hw-mode:

How is this linux specific? It sounds device specific. Your choice is 
make this a device specific property with device specific values or come 
up with generic modes.

Perhaps 'function' should be expanded.

> +        description:
> +          This parameter, if present, specifies the default HW triggering mode
> +          of the LED when LED trigger is set to `dev-hw-mode`.
> +          Available values are specific per device the LED is connected to and
> +          per LED itself.
> +        $ref: /schemas/types.yaml#definitions/string
> +
> +    required:
> +      - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +
> +    #include <dt-bindings/leds/common.h>
> +
> +    ethernet-phy@0 {
> +        compatible = "ethernet-phy-ieee802.3-c45";
> +        reg = <0>;
> +
> +        leds {
> +            compatible = "linux,hw-controlled-leds";
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            led@0 {
> +                reg = <0>;
> +                color = <LED_COLOR_ID_GREEN>;
> +                function = <LED_FUNCTION_STATUS>;

Reading the description of LED_FUNCTION_STATUS doesn't align with how 
you are using it. Think of it as user alert/notification.

> +                linux,default-trigger = "dev-hw-mode";

This is deprecated in favor of 'function'.

> +                linux,default-hw-mode = "1Gbps";
> +            };
> +
> +            led@1 {
> +                reg = <1>;
> +                color = <LED_COLOR_ID_YELLOW>;
> +                function = <LED_FUNCTION_ACTIVITY>;
> +                linux,default-trigger = "dev-hw-mode";
> +                linux,default-hw-mode = "activity";
> +            };
> +        };
> +    };
> +
> +...
> -- 
> 2.26.2
> 
