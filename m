Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897DC2F5F73
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 12:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbhANLEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 06:04:51 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46879 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbhANLEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 06:04:50 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 90C5CC0005;
        Thu, 14 Jan 2021 11:03:41 +0000 (UTC)
Date:   Thu, 14 Jan 2021 12:03:41 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v12 4/4] arm64: dts: sparx5: Add Sparx5 serdes driver node
Message-ID: <20210114110341.GB3654@piout.net>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
 <20210107091924.1569575-5-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107091924.1569575-5-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01/2021 10:19:24+0100, Steen Hegelund wrote:
> Add Sparx5 serdes driver node, and enable it generally for all
> reference boards.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  arch/arm64/boot/dts/microchip/sparx5.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
> index 380281f312d8..29c606194bc7 100644
> --- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
> +++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
> @@ -383,5 +383,13 @@ tmon0: tmon@610508110 {
>  			#thermal-sensor-cells = <0>;
>  			clocks = <&ahb_clk>;
>  		};
> +
> +		serdes: serdes@10808000 {
> +			compatible = "microchip,sparx5-serdes";
> +			#phy-cells = <1>;
> +			clocks = <&sys_clk>;
> +			reg = <0x6 0x10808000 0x5d0000>;
> +		};
> +
>  	};
>  };
> -- 
> 2.29.2
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
