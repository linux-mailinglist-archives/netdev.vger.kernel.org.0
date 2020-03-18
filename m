Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57E01897C9
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCRJRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:17:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgCRJRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 05:17:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KeLPJyyquVYMqBbQtbmvA4XwuIDg/90uof9w1TOJEf0=; b=GWbfE9TR8Qjf3F+si9NU9WUvdR
        yOYUQhp4cjhe3RNjs0dkBjwl97SNYZtImawJ1P2sEZvPhRDUb5IGhlnqyz84tMkFWE/FigDp0+t+0
        S//51x0ON8RP1nbs9Kq3Gd5bB8Dag8Iz0r9m3yQZCb+r5Y3+0avwHoOmzI6ytv3vsNJE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEUpS-00069u-NQ; Wed, 18 Mar 2020 10:17:34 +0100
Date:   Wed, 18 Mar 2020 10:17:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/4] dt-bindings: fec: document the new fsl,stop-mode
 property
Message-ID: <20200318091734.GA23244@lunn.ch>
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
 <1584463806-15788-4-git-send-email-martin.fuzzey@flowbird.group>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584463806-15788-4-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 05:50:05PM +0100, Martin Fuzzey wrote:
> This property allows the appropriate GPR register bit to be set
> for wake on lan support.
> 
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
> ---
>  Documentation/devicetree/bindings/net/fsl-fec.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
> index 5b88fae0..bd0ef5e 100644
> --- a/Documentation/devicetree/bindings/net/fsl-fec.txt
> +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
> @@ -19,6 +19,11 @@ Optional properties:
>    number to 1.
>  - fsl,magic-packet : If present, indicates that the hardware supports waking
>    up via magic packet.
> +- fsl,stop-mode: register bits of stop mode control, the format is
> +		 <&gpr reg bit>.
> +		 gpr is the phandle to general purpose register node.
> +		 reg is the gpr register offset for the stop request.
> +		 bit is the bit offset for the stop request.

Hi Martin

You should not be putting registers and values into device tree.

The regmap is fine. But could you add the register and the bit to
fec_devtype[IMX6SX_FEC], fec_devtype[IMX6UL_FEC], etc.

	Andrew
