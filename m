Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966DD612BB6
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 18:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJ3RGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 13:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiJ3RGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 13:06:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DEA2B7
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 10:06:01 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1opBju-0002tX-Qd; Sun, 30 Oct 2022 18:04:50 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1opBjm-0000cU-6B; Sun, 30 Oct 2022 18:04:42 +0100
Date:   Sun, 30 Oct 2022 18:04:42 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        UNGLinuxDriver@microchip.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>,
        Martin Botka <martin.botka@somainline.org>,
        Taniya Das <tdas@codeaurora.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Shawn Guo <shawn.guo@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        krishna Lanka <quic_vamslank@quicinc.com>,
        Iskren Chernev <iskren.chernev@gmail.com>,
        Del Regno <angelogioacchino.delregno@somainline.org>,
        Robert Foss <robert.foss@linaro.org>,
        Jeffrey Hugo <quic_jhugo@quicinc.com>,
        Govind Singh <govinds@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: constrain number of 'reg' in ethernet
 ports
Message-ID: <20221030170442.GA7508@pengutronix.de>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
 <20221028140326.43470-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221028140326.43470-2-krzysztof.kozlowski@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 10:03:25AM -0400, Krzysztof Kozlowski wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention for Ethernet controller's port number.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

For  asix,ax88178.yaml and microchip,lan95xx.yaml

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

> 
> ---
> 
> Please give it a time for Rob's bot to process this.
> ---
>  Documentation/devicetree/bindings/net/asix,ax88178.yaml       | 4 +++-
>  Documentation/devicetree/bindings/net/microchip,lan95xx.yaml  | 4 +++-
>  .../devicetree/bindings/net/microchip,lan966x-switch.yaml     | 4 ++--
>  .../devicetree/bindings/net/microchip,sparx5-switch.yaml      | 3 ++-
>  .../devicetree/bindings/net/mscc,vsc7514-switch.yaml          | 3 ++-
>  .../bindings/net/renesas,r8a779f0-ether-switch.yaml           | 4 ++--
>  6 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/asix,ax88178.yaml b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> index 1af52358de4c..a81dbc4792f6 100644
> --- a/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> +++ b/Documentation/devicetree/bindings/net/asix,ax88178.yaml
> @@ -27,7 +27,9 @@ properties:
>            - usbb95,772b   # ASIX AX88772B
>            - usbb95,7e2b   # ASIX AX88772B
>  
> -  reg: true
> +  reg:
> +    maxItems: 1
> +
>    local-mac-address: true
>    mac-address: true
>  
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> index cf91fecd8909..3715c5f8f0e0 100644
> --- a/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> +++ b/Documentation/devicetree/bindings/net/microchip,lan95xx.yaml
> @@ -39,7 +39,9 @@ properties:
>            - usb424,9e08   # SMSC LAN89530 USB Ethernet Device
>            - usb424,ec00   # SMSC9512/9514 USB Hub & Ethernet Device
>  
> -  reg: true
> +  reg:
> +    maxItems: 1
> +
>    local-mac-address: true
>    mac-address: true
>  
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> index dc116f14750e..583d70c51be6 100644
> --- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> @@ -83,8 +83,8 @@ properties:
>              const: 0
>  
>            reg:
> -            description:
> -              Switch port number
> +            items:
> +              - description: Switch port number
>  
>            phys:
>              description:
> diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> index 57ffeb8fc876..ccb912561446 100644
> --- a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
> @@ -89,7 +89,8 @@ properties:
>  
>          properties:
>            reg:
> -            description: Switch port number
> +            items:
> +              - description: Switch port number
>  
>            phys:
>              maxItems: 1
> diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> index ee0a504bdb24..1cf82955d75e 100644
> --- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
> @@ -109,7 +109,8 @@ properties:
>  
>          properties:
>            reg:
> -            description: Switch port number
> +            items:
> +              - description: Switch port number
>  
>            phy-handle: true
>  
> diff --git a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
> index 581fff8902f4..0eba66a29c6c 100644
> --- a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
> @@ -106,8 +106,8 @@ properties:
>  
>          properties:
>            reg:
> -            description:
> -              Port number of ETHA (TSNA).
> +            items:
> +              - description: Port number of ETHA (TSNA).
>  
>            phys:
>              maxItems: 1
> -- 
> 2.34.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
