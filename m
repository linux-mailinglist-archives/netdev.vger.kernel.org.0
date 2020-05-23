Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217B11DF7F5
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 17:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387950AbgEWPNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 11:13:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbgEWPNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 11:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g2G0MbVsoaFhpPXareC/2snBekx4pkXDqtUPZnko2zE=; b=HA4Ia2wV+2OM7fKjpDb7BrL3XJ
        6+nWivW51tC9gXY4EN9QkhZdMOesVeBTI2Jq6XBpVFhINBI5xlzwa+WqXrK6337I8cmeVa05rHjEr
        GauELEVv63zv7V/5rXVz74TuEsJIbbuKa8j0Q6m9PBmqANsR3wYqWzpyE6cq87hNFStM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcVqG-0034Tp-PQ; Sat, 23 May 2020 17:13:40 +0200
Date:   Sat, 23 May 2020 17:13:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] dt-bindings: net: Add tx and rx internal
 delays
Message-ID: <20200523151340.GL610998@lunn.ch>
References: <20200522122534.3353-1-dmurphy@ti.com>
 <20200522122534.3353-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522122534.3353-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 07:25:31AM -0500, Dan Murphy wrote:
> tx-internal-delays and rx-internal-delays are a common setting for RGMII
> capable devices.
> 
> These properties are used when the phy-mode or phy-controller is set to
> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
> controller that the PHY will add the internal delay for the connection.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> 
> v2 - updated to add -ps
> 
>  .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index ac471b60ed6a..70702a4ef5e8 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -143,6 +143,20 @@ properties:
>        Specifies the PHY management type. If auto is set and fixed-link
>        is not specified, it uses MDIO for management.
>  
> +  rx-internal-delay-ps:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable RX internal delays.  This property is only
> +      used when the phy-mode or phy-connection-type is rgmii-id or rgmii-rxid.

Hi Dan

Please add a comment about rounding to the nearest supported value.

    Andrew
