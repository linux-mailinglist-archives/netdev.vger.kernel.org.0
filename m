Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111F6181622
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 11:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgCKKtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 06:49:10 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10271 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgCKKtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 06:49:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e68c2170000>; Wed, 11 Mar 2020 03:48:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 11 Mar 2020 03:49:08 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 11 Mar 2020 03:49:08 -0700
Received: from [10.26.11.218] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Mar
 2020 10:49:04 +0000
Subject: Re: [PATCH v2 17/17] arm64: dts: sdm845: add IPA information
To:     Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>
CC:     David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200306042831.17827-1-elder@linaro.org>
 <20200306042831.17827-18-elder@linaro.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ec9776b3-ac79-8f9d-8c4d-012d62dc8f72@nvidia.com>
Date:   Wed, 11 Mar 2020 10:49:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200306042831.17827-18-elder@linaro.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583923735; bh=YDvGaWGcO9cfN0iV8m9ROH9v2HzFADkFgb34PsNqeGk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BhgHVnVRJaAzQXsK+Kgz5ryNRbeh+j5lEJKbdH4t7pCns1aoDEtuMhAPkXO/8/Uzd
         yP1eeHZlT3wbs9iXwdc6J4N/6pIun3D7Pc9eOV56RKOhzTZ0RMUf6AgJlh1Dvu0a6K
         NEoQ/vdOWcfIrPLVryAihPSsF37FCutQ/2r82cwuQr+LiV2E8AO8PWau90ULEjKk/Y
         wxscUdfGgXKxGVCeLaourFX+D1TuTNAw6kdw302qM0b9oYS2xiq5YlPMpj5+PSpgLO
         8gPEqPByzMkSPSiU6NG1W3UeMvffEH8iBVlu4OjT9VuRnzuBKx/GC30ZPwO316xTpn
         tGiTZc/m3Tg4w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/03/2020 04:28, Alex Elder wrote:
> Add IPA-related nodes and definitions to "sdm845.dtsi".
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 51 ++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index d42302b8889b..58fd1c611849 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -675,6 +675,17 @@
>  			interrupt-controller;
>  			#interrupt-cells = <2>;
>  		};
> +
> +		ipa_smp2p_out: ipa-ap-to-modem {
> +			qcom,entry-name = "ipa";
> +			#qcom,smem-state-cells = <1>;
> +		};
> +
> +		ipa_smp2p_in: ipa-modem-to-ap {
> +			qcom,entry-name = "ipa";
> +			interrupt-controller;
> +			#interrupt-cells = <2>;
> +		};
>  	};
>  
>  	smp2p-slpi {
> @@ -1435,6 +1446,46 @@
>  			};
>  		};
>  
> +		ipa@1e40000 {
> +			compatible = "qcom,sdm845-ipa";
> +
> +			modem-init;
> +			modem-remoteproc = <&mss_pil>;
> +
> +			reg = <0 0x1e40000 0 0x7000>,
> +			      <0 0x1e47000 0 0x2000>,
> +			      <0 0x1e04000 0 0x2c000>;
> +			reg-names = "ipa-reg",
> +				    "ipa-shared",
> +				    "gsi";
> +
> +			interrupts-extended =
> +					<&intc 0 311 IRQ_TYPE_EDGE_RISING>,
> +					<&intc 0 432 IRQ_TYPE_LEVEL_HIGH>,
> +					<&ipa_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
> +					<&ipa_smp2p_in 1 IRQ_TYPE_EDGE_RISING>;
> +			interrupt-names = "ipa",
> +					  "gsi",
> +					  "ipa-clock-query",
> +					  "ipa-setup-ready";
> +
> +			clocks = <&rpmhcc RPMH_IPA_CLK>;
> +			clock-names = "core";
> +
> +			interconnects =
> +				<&rsc_hlos MASTER_IPA &rsc_hlos SLAVE_EBI1>,
> +				<&rsc_hlos MASTER_IPA &rsc_hlos SLAVE_IMEM>,
> +				<&rsc_hlos MASTER_APPSS_PROC &rsc_hlos SLAVE_IPA_CFG>;
> +			interconnect-names = "memory",
> +					     "imem",
> +					     "config";
> +
> +			qcom,smem-states = <&ipa_smp2p_out 0>,
> +					   <&ipa_smp2p_out 1>;
> +			qcom,smem-state-names = "ipa-clock-enabled-valid",
> +						"ipa-clock-enabled";
> +		};
> +
>  		tcsr_mutex_regs: syscon@1f40000 {
>  			compatible = "syscon";
>  			reg = <0 0x01f40000 0 0x40000>;
> 


This change is causing the following build error on today's -next ...

 DTC     arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dtb
 arch/arm64/boot/dts/qcom/sdm845.dtsi:1710.15-1748.5: ERROR (phandle_references): /soc@0/ipa@1e40000: Reference to non-existent node or label "rsc_hlos"

Cheers
Jon

-- 
nvpublic
