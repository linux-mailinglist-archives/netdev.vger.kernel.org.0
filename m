Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678B72B7018
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgKQUcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:32:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33328 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgKQUcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 15:32:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kf7dm-007b82-FA; Tue, 17 Nov 2020 21:31:50 +0100
Date:   Tue, 17 Nov 2020 21:31:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, ciorneiioana@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/4] dt-bindings: net: Add Rx/Tx output
 configuration for 10base T1L
Message-ID: <20201117203150.GA1800835@lunn.ch>
References: <20201117201555.26723-1-dmurphy@ti.com>
 <20201117201555.26723-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117201555.26723-3-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:15:53PM -0600, Dan Murphy wrote:
> Per the 802.3cg spec the 10base T1L can operate at 2 different
> differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to

ability

> drive that output is dependent on the PHY's on board power supply.
> This common feature is applicable to all 10base T1L PHYs so this binding
> property belongs in a top level ethernet document.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 6dd72faebd89..bda1ce51836b 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -174,6 +174,12 @@ properties:
>        PHY's that have configurable TX internal delays. If this property is
>        present then the PHY applies the TX delay.
>  
> +  max-tx-rx-p2p-microvolt:
> +    description: |
> +      Configures the Tx/Rx p2p differential output voltage for 10base-T1L PHYs.

Does it configure, or does it limit? I _think_ this is a negotiation
parameter, so the PHY might decide to do 1100mV if the link peer is
near by even when max-tx-rx-p2p-microvolt has the higher value.

     Andrew
