Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EF8433B89
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhJSQFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:05:05 -0400
Received: from vern.gendns.com ([98.142.107.122]:54244 "EHLO vern.gendns.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhJSQFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:05:05 -0400
X-Greylist: delayed 1302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 12:05:04 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lechnology.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sZekwuwMwcMC0PSMG4u/OrHchR+x4Vkc9whNiwOFRTU=; b=swhCBTxRJxxtIgLi9/dq8+T6r/
        vspvuy0rZ+pYE/Qr7xdcW7dMSI/fhJyFOTgCsFHKkFZIq7vke3zf0kLJMD6OaKLDB0tcBMhKIreMZ
        TWm8HtLQ77oVsZG9+jOo1050N5P/oePr0JftFVFYXIJGnrjAFETDM4QkjUo0Il/DHCWbcISI0Drr2
        v4iOonRLYFTRpN9itQVm4M3ksp2LbDdbZXS5azuxZeGMfKqZOAwvWs+IzmoZ/38wM6Ic+e0QDalm3
        4v8/+gp+89DHOLr4iBQ1WIo712DB8mXH6lm0dezc1a4yPnPULwJ8YfzX4RWUaQCkjGRWJLKFWaZsK
        l9RCwGfA==;
Received: from 108-198-5-147.lightspeed.okcbok.sbcglobal.net ([108.198.5.147]:40992 helo=[192.168.0.134])
        by vern.gendns.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <david@lechnology.com>)
        id 1mcrEb-0004JI-9h; Tue, 19 Oct 2021 11:41:06 -0400
Subject: Re: [PATCH 3/3] dt-bindings: net: ti,bluetooth: Convert to
 json-schema
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Beno=c3=aet_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Reichel <sre@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <cover.1634646975.git.geert+renesas@glider.be>
 <c1814db9aff7f09ea41b562a2da305312d8df2dd.1634646975.git.geert+renesas@glider.be>
From:   David Lechner <david@lechnology.com>
Message-ID: <70d3efb8-e379-5d20-1873-4752e893f10b@lechnology.com>
Date:   Tue, 19 Oct 2021 10:41:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c1814db9aff7f09ea41b562a2da305312d8df2dd.1634646975.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - vern.gendns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lechnology.com
X-Get-Message-Sender-Via: vern.gendns.com: authenticated_id: davidmain+lechnology.com/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: vern.gendns.com: davidmain@lechnology.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/21 7:43 AM, Geert Uytterhoeven wrote:
> Convert the Texas Instruments serial-attached bluetooth Device Tree
> binding documentation to json-schema.
> 
> Add missing max-speed property.
> Update the example.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I listed David as maintainer, as he wrote the original bindings.
> Please scream if not appropriate.

I'm not affiliated with TI in any way, so if someone from TI
wants to take responsibility, that would probably be better.

For for the time being...

Acked-by: David Lechner <david@lechnology.com>


> ---
>   .../devicetree/bindings/net/ti,bluetooth.yaml | 91 +++++++++++++++++++
>   .../devicetree/bindings/net/ti-bluetooth.txt  | 60 ------------
>   2 files changed, 91 insertions(+), 60 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/net/ti,bluetooth.yaml
>   delete mode 100644 Documentation/devicetree/bindings/net/ti-bluetooth.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,bluetooth.yaml b/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
> new file mode 100644
> index 0000000000000000..9f6102977c9732d2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,bluetooth.yaml
> @@ -0,0 +1,91 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,bluetooth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Texas Instruments Bluetooth Chips
> +
> +maintainers:
> +  - David Lechner <david@lechnology.com>
> +
> +description: |
> +  This documents the binding structure and common properties for serial
> +  attached TI Bluetooth devices. The following chips are included in this
> +  binding:
> +
> +  * TI CC256x Bluetooth devices
> +  * TI WiLink 7/8 (wl12xx/wl18xx) Shared Transport BT/FM/GPS devices
> +
> +  TI WiLink devices have a UART interface for providing Bluetooth, FM radio,
> +  and GPS over what's called "shared transport". The shared transport is
> +  standard BT HCI protocol with additional channels for the other functions.
> +
> +  TI WiLink devices also have a separate WiFi interface as described in
> +  wireless/ti,wlcore.yaml.
> +
> +  This bindings follows the UART slave device binding in ../serial/serial.yaml.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,cc2560
> +      - ti,wl1271-st
> +      - ti,wl1273-st
> +      - ti,wl1281-st
> +      - ti,wl1283-st
> +      - ti,wl1285-st
> +      - ti,wl1801-st
> +      - ti,wl1805-st
> +      - ti,wl1807-st
> +      - ti,wl1831-st
> +      - ti,wl1835-st
> +      - ti,wl1837-st
> +
> +  enable-gpios:
> +    maxItems: 1
> +
> +  vio-supply:
> +    description: Vio input supply (1.8V)
> +
> +  vbat-supply:
> +    description: Vbat input supply (2.9-4.8V)
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: ext_clock
> +
> +  max-speed: true

Does this mean that max-speed from serial.yaml is supported
but current-speed is not?

> +
> +  nvmem-cells:
> +    maxItems: 1
> +    description:
> +      Nvmem data cell that contains a 6 byte BD address with the most
> +      significant byte first (big-endian).
> +
> +  nvmem-cell-names:
> +    items:
> +      - const: bd-address
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
