Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7404F2E10F3
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 01:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgLWA5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 19:57:22 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgLWA5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 19:57:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1krsS9-00DTox-4F; Wed, 23 Dec 2020 01:56:33 +0100
Date:   Wed, 23 Dec 2020 01:56:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux@armlinux.org.uk,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH 2/4] dt-bindings: net: Add bindings for Qualcomm QCA807x
Message-ID: <20201223005633.GR3107610@lunn.ch>
References: <20201222222637.3204929-1-robert.marko@sartura.hr>
 <20201222222637.3204929-3-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222222637.3204929-3-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  gpio-controller: true
> +  "#gpio-cells":
> +    const: 2
> +
> +  qcom,single-led-1000:
> +    description: |
> +      If present, then dedicated 1000 Mbit will light up for 1000Base-T.
> +      This is a workround for boards with a single LED instead of two.
> +    type: boolean
> +
> +  qcom,single-led-100:
> +    description: |
> +      If present, then dedicated 1000 Mbit will light up for 100Base-TX.
> +      This is a workround for boards with a single LED instead of two.
> +    type: boolean
> +
> +  qcom,single-led-10:
> +    description: |
> +      If present, then dedicated 1000 Mbit will light up for 10Base-Te.
> +      This is a workround for boards with a single LED instead of two.
> +    type: boolean

Sorry, but no. Please look at the work being done for allow PHY LEDs
to be controlled via the LED subsystem. 

> +  qcom,tx-driver-strength:
> +    description: PSGMII/QSGMII TX driver strength control.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

Please use the actual values here, and have the driver convert to the
value poked into the register. So the property would be
qcom,tx-driver-strength-mv and it would have the value 220 for
example.

> +
> +  qcom,control-dac:
> +    description: Analog MDI driver amplitude and bias current.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1, 2, 3, 4, 5, 6, 7]

Make here.

     Andrew
