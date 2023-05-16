Return-Path: <netdev+bounces-3001-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD23C704F5A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:31:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB6D21C20E39
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F3827720;
	Tue, 16 May 2023 13:31:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF9734CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:31:30 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7821981;
	Tue, 16 May 2023 06:31:29 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34GDV1Px029662;
	Tue, 16 May 2023 08:31:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1684243861;
	bh=KiJOZ7KFupaQDkC6vwpyzXkB38VvgH/7nK2KElIdK5Q=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=qmxDx+vKWF7bJ3554Yy0ba71FC9/2fR6vrCrPeeSZl3jvce7FcmFk6BJoWt7v1/JW
	 tfa1G+VAhjq/FEqTZDLrxRaX876MWicoUDOCAl35rq68ejM1UkvQ/MSoiiiNaF0HN9
	 Y7QIBDlSmepMghOqmqhD0zIF8Nrnw40ObNtxyrgc=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34GDV1jx020884
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 16 May 2023 08:31:01 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 16
 May 2023 08:31:01 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 16 May 2023 08:31:01 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34GDV1wZ031938;
	Tue, 16 May 2023 08:31:01 -0500
Date: Tue, 16 May 2023 08:31:01 -0500
From: Nishanth Menon <nm@ti.com>
To: Siddharth Vadapalli <s-vadapalli@ti.com>, Peter Rosin <peda@axentia.se>,
        <tony@atomide.com>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <kristo@kernel.org>, <vigneshr@ti.com>, <rogerq@kernel.org>,
        <nsekhar@ti.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>
Subject: Re: [PATCH net-next 4/5] arm64: dts: ti: k3-am62-main: Add timesync
 router node
Message-ID: <20230516133101.ezt5jacp6i47nspa@oblivion>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-5-s-vadapalli@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230111114429.1297557-5-s-vadapalli@ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17:14-20230111, Siddharth Vadapalli wrote:
> TI's AM62x SoC has a Time Sync Event Router, which enables routing a single
> input signal to multiple recipients. This facilitates syncing all the
> peripherals or processor cores to the input signal which acts as a master
> clock.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
> index 072903649d6e..4ce59170b6a7 100644
> --- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
> +++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
> @@ -649,6 +649,15 @@ cpts@3d000 {
>  		};
>  	};
>  
> +	timesync_router: pinctrl@a40000 {
> +		compatible = "pinctrl-single";

While I understand that the timesync router is essentially a mux,
pinctrl-single is a specific mux model that is used to model external
facing pins to internal signals - pin mux sections of control module
which is already in place is an example of the same.

Using the pinctrl-single scheme for timesync router is, IMHO, wrong
and limiting to potential functions that timesync router could need
enabling.

Is there a reason for using pinctrl-single rather than writing a
mux-controller / consumer model driver instead or rather simpler a
reg-mux node?

> +		reg = <0x0 0xa40000 0x0 0x800>;
> +		#pinctrl-cells = <1>;
> +		pinctrl-single,register-width = <32>;
> +		pinctrl-single,function-mask = <0x000107ff>;
> +		status = "disabled";
> +	};
> +
-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D

