Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ABD59864A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343551AbiHROps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245445AbiHROpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:45:47 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D0C422CA;
        Thu, 18 Aug 2022 07:45:46 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BFB3B22248;
        Thu, 18 Aug 2022 16:45:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1660833943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqSBNQl1mf/1igPF5XqlRtw3O/1RNBIhVB5yzX6jyns=;
        b=fUpmdZM2jjYTYnlEoHOBwU/Fw/2/aKXZW+MBNbtArIe/fYkSwtng5ZQ7zGtWG3E4RgriDx
        OUh08ziwON4iWeApYeNfn0Yq/3hXMe+tdJ1FfBgMXM3ImrruqGjni4jcN4B6bd88yyEWGt
        +ESDbQuz9fB41FVFcdp6+Z0vTCiEI80=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Aug 2022 16:45:43 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree 1/3] arm64: dts: ls1028a: move DSA CPU port
 property to the common SoC dtsi
In-Reply-To: <20220818140519.2767771-2-vladimir.oltean@nxp.com>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
 <20220818140519.2767771-2-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <125791f71a27edd4c2d989125c55de3a@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-18 16:05, schrieb Vladimir Oltean:
> Since the CPU port 4 of the switch is hardwired inside the SoC to go to
> the enetc port 2, this shouldn't be something that the board files need
> to set (but whether that CPU port is used or not is another 
> discussion).
> 
> So move the DSA "ethernet" property to the common dtsi.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts     | 1 -
>  arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts  | 1 -
>  arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts                | 1 -
>  arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi                   | 1 +
>  4 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git
> a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> index 6b575efd84a7..52ef2e8e5492 100644
> --- 
> a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> +++ 
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts
> @@ -104,7 +104,6 @@ &mscc_felix_port3 {
>  };
> 
>  &mscc_felix_port4 {
> -	ethernet = <&enetc_port2>;
>  	status = "okay";
>  };
> 
> diff --git
> a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> index 330e34f933a3..37c20cb6c152 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
> @@ -60,6 +60,5 @@ &mscc_felix_port1 {
>  };
> 
>  &mscc_felix_port4 {
> -	ethernet = <&enetc_port2>;
>  	status = "okay";
>  };
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> index e0cd1516d05b..7285bdcf2302 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts
> @@ -278,7 +278,6 @@ &mscc_felix_port3 {
>  };
> 
>  &mscc_felix_port4 {
> -	ethernet = <&enetc_port2>;
>  	status = "okay";
>  };
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> index 5627dd7734f3..3da105119d82 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
> @@ -1157,6 +1157,7 @@ mscc_felix_port4: port@4 {
>  						reg = <4>;
>  						phy-mode = "internal";
>  						status = "disabled";
> +						ethernet = <&enetc_port2>;

same here, status should probably the last one.

except from that:
Acked-by: Michael Walle <michael@walle.cc>

> 
>  						fixed-link {
>  							speed = <2500>;
