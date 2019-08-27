Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19029EFD6
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbfH0QMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:12:38 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42848 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfH0QMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 12:12:38 -0400
Received: by mail-oi1-f195.google.com with SMTP id o6so15372876oic.9;
        Tue, 27 Aug 2019 09:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cz/ZReSAayiO2TIIiV0TqCPnJ2ta6EUq4sXNauC2br4=;
        b=FDbqR2IhrA3xRvMLd92Q9mkm5relO/2py5uPevvxLa4bTW8ew36KZyTaK2ttU41R2q
         A9u5Ivp/Ay/vnKjnMXTFpsH2wDQldwFPHA62OcmSnFtyBRJ3jnzeA3+qhJiAyNq1aBKj
         9VULKTk6alil+2fjv+FmTec7aax+nKD61U9AfiG3DPAYtgyghd4ZCYxH9FFpOfuzJhpt
         ydUc5SwBG/7spcFUcPAPT1Xsv0GG8FC8HdL/SAByuljQU3VO7qU5nunwmt7/6uRjs/N5
         M4Jl/JsUN9Ym4ep1otCGNN0c0OCCrgppOdLjR5vxYfU79tE18OSAwJNffRJ32CKUeMbh
         mFeQ==
X-Gm-Message-State: APjAAAWpNpvVA2jahXMvNrXJg3BwDTRFkVqtJ+qQvCFZbV+WHu50+fNv
        DfRKgzEqrJQUmA1CkXJVtg==
X-Google-Smtp-Source: APXvYqy5uq8+TgF1D4UOlhXpGeWe88J4wJ104qD4aXUbxNeuR6i5LmlumFgVQYjTec1HMkYnvWFUbQ==
X-Received: by 2002:a54:4508:: with SMTP id l8mr10701622oil.90.1566922356702;
        Tue, 27 Aug 2019 09:12:36 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f21sm5402064otq.7.2019.08.27.09.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 09:12:36 -0700 (PDT)
Date:   Tue, 27 Aug 2019 11:12:35 -0500
From:   Rob Herring <robh@kernel.org>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 1/4] dt-bindings: net: phy: Add subnode for LED
 configuration
Message-ID: <20190827161235.GA14901@bogus>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-2-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813191147.19936-2-mka@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 12:11:44PM -0700, Matthias Kaehlcke wrote:
> The LED behavior of some Ethernet PHYs is configurable. Add an
> optional 'leds' subnode with a child node for each LED to be
> configured. The binding aims to be compatible with the common
> LED binding (see devicetree/bindings/leds/common.txt).
> 
> A LED can be configured to be:
> 
> - 'on' when a link is active, some PHYs allow configuration for
>   certain link speeds
>   speeds
> - 'off'
> - blink on RX/TX activity, some PHYs allow configuration for
>   certain link speeds
> 
> For the configuration to be effective it needs to be supported by
> the hardware and the corresponding PHY driver.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v6:
> - none
> 
> Changes in v5:
> - renamed triggers from 'phy_link_<speed>_active' to 'phy-link-<speed>'
> - added entries for 'phy-link-<speed>-activity'
> - added 'phy-link' and 'phy-link-activity' for triggers with any link
>   speed
> - added entry for trigger 'none'
> 
> Changes in v4:
> - patch added to the series
> ---
>  .../devicetree/bindings/net/ethernet-phy.yaml | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index f70f18ff821f..98ba320f828b 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -153,6 +153,50 @@ properties:
>        Delay after the reset was deasserted in microseconds. If
>        this property is missing the delay will be skipped.
>  
> +patternProperties:
> +  "^leds$":
> +    type: object
> +    description:
> +      Subnode with configuration of the PHY LEDs.

#address-cells and #size-cells needed.

> +
> +    patternProperties:
> +      "^led@[0-9]+$":

Need to allow for the case of 1 LED which doesn't need a unit-address 
nor reg.

> +        type: object
> +        description:
> +          Subnode with the configuration of a single PHY LED.
> +
> +    properties:
> +      reg:
> +        description:
> +          The ID number of the LED, typically corresponds to a hardware ID.
> +        $ref: "/schemas/types.yaml#/definitions/uint32"

Standard properties already have a type definition. What's needed is 
'maxItems: 1'.

> +
> +      linux,default-trigger:
> +        description:
> +          This parameter, if present, is a string specifying the trigger
> +          assigned to the LED. Supported triggers are:
> +            "none" - LED will be solid off
> +            "phy-link" - LED will be solid on when a link is active
> +            "phy-link-10m" - LED will be solid on when a 10Mb/s link is active
> +            "phy-link-100m" - LED will be solid on when a 100Mb/s link is active
> +            "phy-link-1g" - LED will be solid on when a 1Gb/s link is active
> +            "phy-link-10g" - LED will be solid on when a 10Gb/s link is active
> +            "phy-link-activity" - LED will be on when link is active and blink
> +                                  off with activity.
> +            "phy-link-10m-activity" - LED will be on when 10Mb/s link is active
> +                                      and blink off with activity.
> +            "phy-link-100m-activity" - LED will be on when 100Mb/s link is
> +                                       active and blink off with activity.
> +            "phy-link-1g-activity" - LED will be on when 1Gb/s link is active
> +                                     and blink off with activity.
> +            "phy-link-10g-activity" - LED will be on when 10Gb/s link is active
> +                                      and blink off with activity.

These strings all need to be in an enum.

The led binding is moving away from linux,default-trigger to 'function' 
and 'color' properties. You probably want to do that here.

> +
> +        $ref: "/schemas/types.yaml#/definitions/string"
> +
> +    required:
> +      - reg
> +
>  required:
>    - reg
>  
> @@ -173,5 +217,20 @@ examples:
>              reset-gpios = <&gpio1 4 1>;
>              reset-assert-us = <1000>;
>              reset-deassert-us = <2000>;
> +
> +            leds {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                led@0 {
> +                    reg = <0>;
> +                    linux,default-trigger = "phy-link-1g";
> +                };
> +
> +                led@1 {
> +                    reg = <1>;
> +                    linux,default-trigger = "phy-link-100m-activity";
> +                };
> +            };
>          };
>      };
> -- 
> 2.23.0.rc1.153.gdeed80330f-goog
> 
