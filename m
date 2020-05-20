Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166C31DB5C2
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgETN4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:56:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgETN4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 09:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yW9W/HhlxheuNaE5i574WexC9r5Wyq1J3+gq8UzHE+Q=; b=nD/2Mhlv7UcVTvWEFNNokHYfcu
        uQbQ6t/mZCHTTAvEUgO8TnmDiQ3iJmGwLFsq4IqH/+G7AcXDwmcrkzBVgqE8nkuh9txLbOLNl8qQw
        KTMcEBTtxzfJi85j0acg0xofLT1SozMJE5gNJeZU0EDs8f2Qml/f52Oc8ybr6wTvRWi4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbPCq-002oL3-GJ; Wed, 20 May 2020 15:56:24 +0200
Date:   Wed, 20 May 2020 15:56:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
Message-ID: <20200520135624.GC652285@lunn.ch>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520121835.31190-4-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 07:18:34AM -0500, Dan Murphy wrote:
> Add the internal delay values into the header and update the binding
> with the internal delay properties.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83869.yaml    | 16 ++++++++++++++++
>  include/dt-bindings/net/ti-dp83869.h           | 18 ++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> index 5b69ef03bbf7..344015ab9081 100644
> --- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
> @@ -64,6 +64,20 @@ properties:
>         Operational mode for the PHY.  If this is not set then the operational
>         mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
>  
> +  ti,rx-internal-delay:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +      RGMII Receive Clock Delay - see dt-bindings/net/ti-dp83869.h
> +      for applicable values. Required only if interface type is
> +      PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_RXID.

Hi Dan

Having it required with PHY_INTERFACE_MODE_RGMII_ID or
PHY_INTERFACE_MODE_RGMII_RXID is pretty unusual. Normally these
properties are used to fine tune the delay, if the default of 2ns does
not work.

    Andrew
