Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D336EE223
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbjDYMrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjDYMru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:47:50 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743F3BB8D;
        Tue, 25 Apr 2023 05:47:49 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33PClMng069057;
        Tue, 25 Apr 2023 07:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1682426842;
        bh=OwWheics6M72Ry4e2WdjO4f48sALqJDkHHsdbEnwqD0=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=jYq4VmqRZ9uiIsPFJcHfbk4se0j+PpR19reqO0nuPYXVYI5ZUiZ6pMG2/fIcvQ8hR
         25MLE4KM84v5D7CIWdpTthK9nCvcmYRAsCquHGPOBaqQ+EqcKnouquy+YS0ncIX9q9
         MNeYeXcdv0I5EnxgEoULMpCB/IY2Nh3JYMUss1pQ=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33PClMqN035520
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Apr 2023 07:47:22 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 25
 Apr 2023 07:47:22 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 25 Apr 2023 07:47:22 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33PClMYT001603;
        Tue, 25 Apr 2023 07:47:22 -0500
Date:   Tue, 25 Apr 2023 07:47:22 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Judith Mendez <jm@ti.com>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 3/4] DO_NOT_MERGE arm64: dts: ti: Add AM62x MCAN MAIN
 domain transceiver overlay
Message-ID: <20230425124722.pnp7rkuanoml2zvj@nanny>
References: <20230424195402.516-1-jm@ti.com>
 <20230424195402.516-4-jm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230424195402.516-4-jm@ti.com>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14:54-20230424, Judith Mendez wrote:
> Add an overlay for main domain MCAN on AM62x SK. The AM62x
> SK board does not have on-board CAN transceiver so instead
> of changing the DTB permanently, add an overlay to enable
> MAIN domain MCAN and support for 1 CAN transceiver.
> 
> Signed-off-by: Judith Mendez <jm@ti.com>
> ---
>  arch/arm64/boot/dts/ti/Makefile               |  2 ++
>  .../boot/dts/ti/k3-am625-sk-mcan-main.dtso    | 35 +++++++++++++++++++
>  2 files changed, 37 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
> 

Just a headsup - for a formal patch, for the overlay, please ensure we
provide link to the specific board. I dont want to end up with 1000s
of overlay files, each enabling one specific peripheral instance of a
small subgroup of peripheral instance. Overlays should be describing a
real platform with product link.

> diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
> index c83c9d772b81..abe15e76b614 100644
> --- a/arch/arm64/boot/dts/ti/Makefile
> +++ b/arch/arm64/boot/dts/ti/Makefile
> @@ -9,8 +9,10 @@
>  # alphabetically.
>  
>  # Boards with AM62x SoC
> +k3-am625-sk-mcan-dtbs := k3-am625-sk.dtb k3-am625-sk-mcan-main.dtbo
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-beagleplay.dtb
>  dtb-$(CONFIG_ARCH_K3) += k3-am625-sk.dtb
> +dtb-$(CONFIG_ARCH_K3) += k3-am625-sk-mcan.dtb
>  dtb-$(CONFIG_ARCH_K3) += k3-am62-lp-sk.dtb
>  
>  # Boards with AM62Ax SoC
> diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
> new file mode 100644
> index 000000000000..0a7b2f394f87
> --- /dev/null
> +++ b/arch/arm64/boot/dts/ti/k3-am625-sk-mcan-main.dtso
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/**
> + * DT overlay for MCAN transceiver in main domain on AM625 SK
> + *
> + * Copyright (C) 2022 Texas Instruments Incorporated - https://www.ti.com/
> + */
> +
> +/dts-v1/;
> +/plugin/;
> +
> +#include "k3-pinctrl.h"
> +
> +&{/} {
> +	transceiver1: can-phy0 {
> +		compatible = "ti,tcan1042";
> +		#phy-cells = <0>;
> +		max-bitrate = <5000000>;
> +	};
> +};
> +
> +&main_pmx0 {
> +	main_mcan0_pins_default: main-mcan0-pins-default {
> +		pinctrl-single,pins = <
> +			AM62X_IOPAD(0x1dc, PIN_INPUT, 0) /* (E15) MCAN0_RX */
> +			AM62X_IOPAD(0x1d8, PIN_OUTPUT, 0) /* (C15) MCAN0_TX */
> +		>;
> +	};
> +};
> +
> +&main_mcan0 {
> +	status = "okay";
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&main_mcan0_pins_default>;
> +	phys = <&transceiver1>;
> +};
> -- 
> 2.17.1
> 

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
