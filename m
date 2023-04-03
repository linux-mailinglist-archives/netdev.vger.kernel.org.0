Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988726D50EC
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbjDCSqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbjDCSqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:46:18 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FDD2106;
        Mon,  3 Apr 2023 11:46:14 -0700 (PDT)
Received: by mail-ot1-f49.google.com with SMTP id r40-20020a05683044a800b006a14270bc7eso12812494otv.6;
        Mon, 03 Apr 2023 11:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680547573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wy0NcaxMPjAd0Cjp8anGLQ+ZJvJT6IQ/gKneu1y1dn4=;
        b=RUCI2YU5l1jF7/0EiY/CpchLdFe4V2JlDTdyH59Sywc1uALECZtS33AanlTXUM+o3E
         N9waLui/RWD+714E8VEhDhk5jk3E87vyZ6ugc73voPrl4NTc3OMQPuchV6mZR2rt3L51
         /dd1UzKPY/eonld+UEtLwC16eSM3MCGmWFgGppGCc+2/99H1MiiLdHh75/sdMZgPS75z
         kYKioG2vNdB3nAE0fSIHY0v2yuq8dY/Q6XZTFNEeBwU2iqvA6njGQuKpQbH+SGs1X6f3
         pRXAUAcBYJJkr5+zVXKo2t/A0KrrEhNMWltdPU0k8ESPYLB1yvc3s748pPjhAw5O0cpS
         cbRw==
X-Gm-Message-State: AAQBX9fq+NJtKn9TmUXsZdjMoRsyZhFV/k5mecYE7hZ0unglXMpiFpd6
        PbrgfDW5M9fHsUVihczeJA==
X-Google-Smtp-Source: AKy350YjgozHOEC2dvNCQI9uebQk/eVsGBSXpTw8cGc1ZFM5R8OSBSr2dBzvQAQoRblbFeGR9A8sDg==
X-Received: by 2002:a9d:77d3:0:b0:69a:5407:e563 with SMTP id w19-20020a9d77d3000000b0069a5407e563mr10154194otl.16.1680547573599;
        Mon, 03 Apr 2023 11:46:13 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b11-20020a056830104b00b006a1287ccce6sm4540387otp.31.2023.04.03.11.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 11:46:12 -0700 (PDT)
Received: (nullmailer pid 1356073 invoked by uid 1000);
        Mon, 03 Apr 2023 18:46:11 -0000
Date:   Mon, 3 Apr 2023 13:46:11 -0500
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 16/16] arm: mvebu: dt: Add PHY LED support
 for 370-rd WAN port
Message-ID: <20230403184611.GA1352384-robh@kernel.org>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-17-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327141031.11904-17-ansuelsmth@gmail.com>
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:10:31PM +0200, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> The WAN port of the 370-RD has a Marvell PHY, with one LED on
> the front panel. List this LED in the device tree.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  arch/arm/boot/dts/armada-370-rd.dts | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/armada-370-rd.dts b/arch/arm/boot/dts/armada-370-rd.dts
> index be005c9f42ef..15b36aa34ef4 100644
> --- a/arch/arm/boot/dts/armada-370-rd.dts
> +++ b/arch/arm/boot/dts/armada-370-rd.dts
> @@ -20,6 +20,7 @@
>  /dts-v1/;
>  #include <dt-bindings/input/input.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/leds/common.h>
>  #include <dt-bindings/gpio/gpio.h>
>  #include "armada-370.dtsi"
>  
> @@ -135,6 +136,19 @@ &mdio {
>  	pinctrl-names = "default";
>  	phy0: ethernet-phy@0 {
>  		reg = <0>;
> +		leds {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			led@0 {
> +				reg = <0>;
> +				label = "WAN";

WAN or

> +				color = <LED_COLOR_ID_WHITE>;
> +				function = LED_FUNCTION_LAN;

LAN?

> +				function-enumerator = <1>;
> +				linux,default-trigger = "netdev";
> +			};
> +		};
>  	};
>  
>  	switch: switch@10 {
> -- 
> 2.39.2
> 
