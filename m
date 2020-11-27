Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784B42C6A51
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbgK0RBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:01:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731966AbgK0RBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 12:01:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kih76-0099hG-56; Fri, 27 Nov 2020 18:00:52 +0100
Date:   Fri, 27 Nov 2020 18:00:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/3] dt-bindings: net: sparx5: Add sparx5-switch
 bindings
Message-ID: <20201127170052.GV2073444@lunn.ch>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-2-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133307.2969817-2-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  reg-names:
> +    minItems: 153
> +    items:
> +      - const: dev2g5_0
> +      - const: dev5g_0
> +      - const: pcs5g_br_0
> +      - const: dev2g5_1
> +      - const: dev5g_1
...
> +      - const: ana_ac
> +      - const: vop

> +    switch: switch@600000000 {
> +      compatible = "microchip,sparx5-switch";
> +      reg = <0x10004000 0x4000>, /* dev2g5_0 */
> +        <0x10008000 0x4000>, /* dev5g_0 */
> +        <0x1000c000 0x4000>, /* pcs5g_br_0 */
> +        <0x10010000 0x4000>, /* dev2g5_1 */
> +        <0x10014000 0x4000>, /* dev5g_1 */

...

> +        <0x11800000 0x100000>, /* ana_l2 */
> +        <0x11900000 0x100000>, /* ana_ac */
> +        <0x11a00000 0x100000>; /* vop */

This is a pretty unusual binding.

Why is it not

reg = <0x10004000 0x1af8000>

and the driver can then break up the memory into its sub ranges?

    Andrew
