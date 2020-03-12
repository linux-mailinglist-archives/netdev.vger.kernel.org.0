Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEAE183690
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 17:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgCLQuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 12:50:44 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:56279 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCLQuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 12:50:44 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1A69122FAC;
        Thu, 12 Mar 2020 17:50:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1584031841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kjJ10yaE4xOITwa0lcGngsQWRZEzeFLVFpTKECi5fjM=;
        b=O1IP2r4NgRR8jB5FfvAbMpoq+5dm1oyxRXXBswapjXuY8YadbpB9YjHm64TjJieI0e66TR
        QyczEjlcMl9E5JR1cfxQCLPfQ6bb4cjq4WB7y2/0sykEI5cAdeOQgqHiXSEnE1Rtx/TKFv
        Ew4c3ToeJGp+bFBbOTxgIAllCSdA4lA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Mar 2020 17:50:40 +0100
From:   Michael Walle <michael@walle.cc>
To:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 2/2] arm64: dts: ls1028a: disable the felix switch by
 default
In-Reply-To: <20200312164320.22349-2-michael@walle.cc>
References: <20200312164320.22349-1-michael@walle.cc>
 <20200312164320.22349-2-michael@walle.cc>
Message-ID: <5c06000e9ca893cdf431f29618428630@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 1A69122FAC
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         DBL_PROHIBIT(0.00)[0.0.0.0:email];
         RCPT_COUNT_TWELVE(0.00)[13];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[davemloft.net,gmail.com,lunn.ch,nxp.com,kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-03-12 17:43, schrieb Michael Walle:
> Disable the felix switch by default and enable it per board which are
> actually using it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

I forgot to mention that this patch depends on the following series:
   
https://lore.kernel.org/linux-devicetree/20200311074929.19569-1-michael@walle.cc/

Sorry,
-michael

> ---
>  .../boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts  | 4 ++++
>  .../boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts      | 4 ++++
>  arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts             | 4 ++++
>  arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                | 3 ++-
>  4 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git
> a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> index a83a176cf18a..d4ca12b140b4 100644
> --- 
> a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> +++ 
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> @@ -63,6 +63,10 @@
>  	};
>  };
> 
> +&mscc_felix {
> +	status = "okay";
> +};
> +
>  &mscc_felix_port0 {
>  	label = "swp0";
>  	managed = "in-band-status";
> diff --git
> a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> index 0a34ff682027..901b5b161def 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> @@ -48,6 +48,10 @@
>  	status = "okay";
>  };
> 
> +&mscc_felix {
> +	status = "okay";
> +};
> +
>  &mscc_felix_port0 {
>  	label = "gbe0";
>  	phy-handle = <&phy0>;
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> index 0d27b5667b8c..8294d364112e 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> @@ -228,6 +228,10 @@
>  	status = "okay";
>  };
> 
> +&mscc_felix {
> +	status = "okay";
> +};
> +
>  &mscc_felix_port0 {
>  	label = "swp0";
>  	managed = "in-band-status";
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> index c09279379723..70a10268bb83 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> @@ -933,10 +933,11 @@
>  				fsl,extts-fifo;
>  			};
> 
> -			ethernet-switch@0,5 {
> +			mscc_felix: ethernet-switch@0,5 {
>  				reg = <0x000500 0 0 0 0>;
>  				/* IEP INT_B */
>  				interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
> +				status = "disabled";
> 
>  				ports {
>  					#address-cells = <1>;
