Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496D16E2C5D
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDNWMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDNWMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:12:00 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD91C44AE;
        Fri, 14 Apr 2023 15:11:52 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33EMBanx037917;
        Fri, 14 Apr 2023 17:11:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681510296;
        bh=a0uKTsMKaNvk5uDtPQLpPxerY/DYuoC0qGEIcf/1C7s=;
        h=Date:From:To:CC:Subject:References:In-Reply-To;
        b=IJNabqVjScx0220sPMI7p2BoqZ48sUsP3VO/xJ82NdcXb1LijLkJG00auwjgpXv22
         0yImhfOtcNFQAm77FHHd9eUOmCJnQLcQ1w6V5PX7swnDudtpBfgFIknAaKL5gKupba
         iKqhYx0/B6iCm4Dj2+3+zIK/yeZL5pH3KFozmi94=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33EMBatK009894
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 Apr 2023 17:11:36 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Fri, 14
 Apr 2023 17:11:36 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Fri, 14 Apr 2023 17:11:36 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33EMBZf4063553;
        Fri, 14 Apr 2023 17:11:35 -0500
Date:   Fri, 14 Apr 2023 17:11:35 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>
Subject: Re: [RFC PATCH 4/5] arm64: dts: ti: Enable multiple MCAN for AM62x
 in MCU MCAN overlay
Message-ID: <20230414221135.vifinqboqndxdxzw@embark>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-5-jm@ti.com>
 <9ab56180-328e-1416-56cb-bbf71af0c26d@linaro.org>
 <20230414182925.ya3fe2n6mtyuqotb@detached>
 <342dd9b0-35cd-1715-ee67-6a6628a3a9a6@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <342dd9b0-35cd-1715-ee67-6a6628a3a9a6@linaro.org>
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22:44-20230414, Krzysztof Kozlowski wrote:
> On 14/04/2023 20:29, Nishanth Menon wrote:
> >>> +
> >>> +&cbass_mcu {
> >>> +	mcu_mcan1: can@4e00000 {
> >>> +		compatible = "bosch,m_can";
> >>> +		reg = <0x00 0x4e00000 0x00 0x8000>,
> >>> +			  <0x00 0x4e08000 0x00 0x200>;
> >>> +		reg-names = "message_ram", "m_can";
> >>> +		power-domains = <&k3_pds 188 TI_SCI_PD_EXCLUSIVE>;
> >>> +		clocks = <&k3_clks 188 6>, <&k3_clks 188 1>;
> >>> +		clock-names = "hclk", "cclk";
> >>> +		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
> >>> +		pinctrl-names = "default";
> >>> +		pinctrl-0 = <&mcu_mcan1_pins_default>;
> >>> +		phys = <&transceiver2>;
> >>> +		status = "okay";
> >>
> >> okay is by default. Why do you need it?
> > 
> > mcan is not functional without pinmux, so it has been disabled by
> > default in SoC. this overlay is supposed to enable it. But this is done
> > entirely wrongly.
> 
> Ah, so this is override of existing node? Why not overriding by
> label/phandle?

Yep, that is how it should be done (as every other node is done for
mcan):
a) SoC.dtsi -> introduce mcu_mcan1, disabled since no transciever or
pinmux, set status = "disabled";
b) overlay -> use the label and provide the missing properties, set
status = "okay";

The series definitely needs a respin.

-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D
