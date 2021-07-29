Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6453E3DA3C5
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbhG2NSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:18:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237475AbhG2NSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 09:18:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=o6gDh22Ro6ovNEhQvwZBx+WNuMjXayJvQyfw3IGhpLs=; b=mIEmM9k9u+fpHO9PVfmWz7W3vj
        NAV+9xbJ5o2VdKOLo0MhDk8tGz9cXFe85Ygj4M97KR6v32mMpEDs7/A28oLAIC2yfnOUnFcFCYxZG
        2T4k2BjbVk3+fXxBi7QsLBtDsYgm6LlwgV3krNZ33Set7f+Si6h/6Yi+3NnSsKGNv1gQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m95vC-00FJYn-MF; Thu, 29 Jul 2021 15:17:58 +0200
Date:   Thu, 29 Jul 2021 15:17:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
Message-ID: <YQKqhoJ4iPOTiGHZ@lunn.ch>
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <20210729125358.5227-3-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729125358.5227-3-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -23,7 +25,29 @@ properties:
>      const: 0
>  
>    reg:
> -    maxItems: 1
> +    maxItems: 2
> +
> +  clocks:
> +    items:
> +      - description: MDIO clock
> +
> +  clock-names:
> +    items:
> +      - const: gcc_mdio_ahb_clk
> +
> +  resets:
> +    items:
> +      - description: MDIO reset & GEPHY hardware reset
> +
> +  reset-names:
> +    items:
> +      - const: gephy_mdc_rst
> +
> +  phy-reset-gpios:
> +    maxItems: 3
> +    description:
> +      The phandle and specifier for the GPIO that controls the RESET
> +      lines of PHY devices on that MDIO bus.

This is clearly not a rename. It is great you are adding missing
properties, but please do it as a separate patch.

	    Andrew
