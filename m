Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F9D1724BC
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgB0RNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:13:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729297AbgB0RNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 12:13:54 -0500
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1481E246A2;
        Thu, 27 Feb 2020 17:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582823633;
        bh=Av9+N9Sw/6yGgD2tCLI1uZRILU83lnh2H3xVVPQcEMs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xiLIVol5DsJ7hut2N0EsAk8d6N/I7JonTjxI10tGT56ITL55xo6Wb7uGZp3rxlMYP
         DMcA2dzJk5bCClMHADhaEnK26kS+Q3upTLYhHTxzGVB8h8gMN5/V4VKASrNud4h1jT
         9lgVXLBPHMIRQXiU5Bzl9Vutrx1/3dNNvVPAT/qU=
Received: by mail-qt1-f174.google.com with SMTP id g21so2810298qtq.10;
        Thu, 27 Feb 2020 09:13:53 -0800 (PST)
X-Gm-Message-State: APjAAAXPKCw4fpDFd8kxBhBtzkBcc6iNonFkWNxKwxZyEveOtYpe6wJq
        ToeWVZ3KD7u8IOb7h+deLo7cXu7B/kEWCe8l/A==
X-Google-Smtp-Source: APXvYqzWwqfR+SoJdd3pUrXUejrHZFu5fqFZ7jqlZyQ/GDLlYmrm1j7psEVj+D73QH5qwTr8ogrjBSus80zaAD3b6II=
X-Received: by 2002:aed:2344:: with SMTP id i4mr202251qtc.136.1582823632167;
 Thu, 27 Feb 2020 09:13:52 -0800 (PST)
MIME-Version: 1.0
References: <20200227095159.GJ25745@shell.armlinux.org.uk> <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j7FqO-0003sv-Ho@rmk-PC.armlinux.org.uk>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 27 Feb 2020 11:13:41 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK9SLJKZfGjWu3RCk9Wiof+YdUaMziwOrCw5ZxjMZAq_Q@mail.gmail.com>
Message-ID: <CAL_JsqK9SLJKZfGjWu3RCk9Wiof+YdUaMziwOrCw5ZxjMZAq_Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: add dt bindings for
 marvell10g driver
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 3:52 AM Russell King <rmk+kernel@armlinux.org.uk> wrote:
>
> Add a DT bindings document for the Marvell 10G driver, which will
> augment the generic ethernet PHY binding by having LED mode
> configuration.
>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  .../devicetree/bindings/net/marvell,10g.yaml  | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,10g.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/marvell,10g.yaml b/Documentation/devicetree/bindings/net/marvell,10g.yaml
> new file mode 100644
> index 000000000000..da597fc5314d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/marvell,10g.yaml
> @@ -0,0 +1,31 @@
> +# SPDX-License-Identifier: GPL-2.0+

Dual license new bindings please:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/marvell,10g.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Marvell Alaska X family Ethernet PHYs
> +
> +maintainers:
> +  - Russell King <rmk+kernel@armlinux.org.uk>
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  marvell,led-mode:
> +    description: |
> +      An array of one to four 16-bit integers to write to the PHY LED
> +      configuration registers.

This is for what to blink or turn on for? I thought we had something
generic for configuring PHY LEDs specifically?

> +    allOf:
> +      - $ref: /schemas/types.yaml#/definitions/uint16-array
> +      - minItems: 1
> +        maxItems: 4
> +
> +examples:
> +  - |
> +    ethernet-phy@0 {
> +        reg = <0>;

This needs to be under an 'mdio' node with #address-cells and
#size-cells set correctly.

> +        compatible = "ethernet-phy-ieee802.3-c45";
> +        marvell,led-mode = /bits/ 16 <0x0129 0x095d 0x0855>;
> +    };
> --
> 2.20.1
>
