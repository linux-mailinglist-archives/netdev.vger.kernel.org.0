Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14636E7EEE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbjDSPzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233605AbjDSPzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:55:12 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFEB08A45;
        Wed, 19 Apr 2023 08:55:09 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 33JFss9r030988;
        Wed, 19 Apr 2023 10:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1681919694;
        bh=ECtls6r4zEewHNfldLF5yv4pxr43zudpJBOSpDVJGfg=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=JReNgkWpOFq1h7lmPDRvI52P8AbO5xrJCuAqp0aohMJCqKcqwPuetVVe51SNbqwgJ
         tPlGxLvUYs1YX2PQIbOIFcDg2UANBqSWwIRPokg7aYDpjaXFoLcCZ1SduK1dy21Tfe
         9kQvqltZIH+b0M+5pTnTbIzdKHEKwsFei/4geHBQ=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 33JFssTi062585
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Apr 2023 10:54:54 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 19
 Apr 2023 10:54:54 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 19 Apr 2023 10:54:54 -0500
Received: from [128.247.81.102] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 33JFsrYx113397;
        Wed, 19 Apr 2023 10:54:53 -0500
Message-ID: <43daed81-fe38-60c6-bdd6-8ab15869c511@ti.com>
Date:   Wed, 19 Apr 2023 10:54:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH 4/5] arm64: dts: ti: Enable multiple MCAN for AM62x in
 MCU MCAN overlay
Content-Language: en-US
To:     Nishanth Menon <nm@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <linux-can@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        Schuyler Patton <spatton@ti.com>
References: <20230413223051.24455-1-jm@ti.com>
 <20230413223051.24455-5-jm@ti.com>
 <9ab56180-328e-1416-56cb-bbf71af0c26d@linaro.org>
 <20230414182925.ya3fe2n6mtyuqotb@detached>
 <342dd9b0-35cd-1715-ee67-6a6628a3a9a6@linaro.org>
 <20230414221135.vifinqboqndxdxzw@embark>
From:   "Mendez, Judith" <jm@ti.com>
In-Reply-To: <20230414221135.vifinqboqndxdxzw@embark>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, all

On 4/14/2023 5:11 PM, Nishanth Menon wrote:
> On 22:44-20230414, Krzysztof Kozlowski wrote:
>> On 14/04/2023 20:29, Nishanth Menon wrote:
>>>>> +
>>>>> +&cbass_mcu {
>>>>> +	mcu_mcan1: can@4e00000 {
>>>>> +		compatible = "bosch,m_can";
>>>>> +		reg = <0x00 0x4e00000 0x00 0x8000>,
>>>>> +			  <0x00 0x4e08000 0x00 0x200>;
>>>>> +		reg-names = "message_ram", "m_can";
>>>>> +		power-domains = <&k3_pds 188 TI_SCI_PD_EXCLUSIVE>;
>>>>> +		clocks = <&k3_clks 188 6>, <&k3_clks 188 1>;
>>>>> +		clock-names = "hclk", "cclk";
>>>>> +		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
>>>>> +		pinctrl-names = "default";
>>>>> +		pinctrl-0 = <&mcu_mcan1_pins_default>;
>>>>> +		phys = <&transceiver2>;
>>>>> +		status = "okay";
>>>>
>>>> okay is by default. Why do you need it?
>>>
>>> mcan is not functional without pinmux, so it has been disabled by
>>> default in SoC. this overlay is supposed to enable it. But this is done
>>> entirely wrongly.
>>
>> Ah, so this is override of existing node? Why not overriding by
>> label/phandle?
> 
> Yep, that is how it should be done (as every other node is done for
> mcan):
> a) SoC.dtsi -> introduce mcu_mcan1, disabled since no transciever or
> pinmux, set status = "disabled";
> b) overlay -> use the label and provide the missing properties, set
> status = "okay";
> 
> The series definitely needs a respin.
> 

Thanks for your feedback, I will definitely fix and send out a v2 with 
this update.

Thanks,
Judith

