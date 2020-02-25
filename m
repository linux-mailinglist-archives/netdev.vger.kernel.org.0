Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A1816B746
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 02:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgBYBkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 20:40:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBYBkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 20:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ruwwviCX3u9iIHw2RDglYwBhcA5r2ShXtHN3byrUOBw=; b=KyXATRz4RpG08H34t3PebJPk63
        os/hXh+cE23WSw0cL3YEt0OVxWbjNGBEBrrAT9nRAkJNuBEbNFeJHZxE7/kDbvF4DMM8LlrPk+3fB
        5HLtxbPJhvaHgWmEZ0gR++SBM8kum+UgpYiCmUFYmaInxpKWvB5x19LLayxFVToqCwVA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6PCW-0003eH-M3; Tue, 25 Feb 2020 02:39:56 +0100
Date:   Tue, 25 Feb 2020 02:39:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] Documentation: devictree: Add ipq806x mdio
 bindings
Message-ID: <20200225013956.GA13912@lunn.ch>
References: <20200224211035.16897-1-ansuelsmth@gmail.com>
 <20200224211035.16897-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224211035.16897-2-ansuelsmth@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 10:10:31PM +0100, Ansuel Smith wrote:
> Add documentations for ipq806x mdio driver.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
> Changes in v7:
> - Fix dt_binding_check problem
> 
>  .../bindings/net/qcom,ipq8064-mdio.yaml       | 55 +++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> new file mode 100644
> index 000000000000..3178cbfdc661
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> @@ -0,0 +1,55 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ipq8064-mdio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm ipq806x MDIO bus controller
> +
> +maintainers:
> +  - Ansuel Smith <ansuelsmth@gmail.com>
> +
> +description: |+
> +  The ipq806x soc have a MDIO dedicated controller that is
> +  used to comunicate with the gmac phy conntected.

used to communicate with the connected gmac phy.

     Andrew
