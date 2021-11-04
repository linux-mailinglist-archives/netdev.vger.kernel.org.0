Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFA1445A2E
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 20:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhKDTFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 15:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234147AbhKDTFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 15:05:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB92961053;
        Thu,  4 Nov 2021 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636052559;
        bh=zbv7Dzgj1Wsfp/gUJExbJvfRCyf5Qqe5D8kKFiCGqxI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=TBuEo3R1O7GDP9ATs+c/QAG3gj/w4TlvcFz1AZufjmotHNVuDXjoN91//dh5a8rLi
         W76jla8N1A7uWJsNj2jDulp689lqHAvfG3246+2cJpzAX+2A5Vcy65cn1no7gzDdN4
         kJcOAANRPrAZFpq+BXITpv/+iqmSZfqksJ9msZP43XbN46/1NUCVY3PEhQCYWSF1/v
         +FWerU8jNgXYJpRjXAXlMe2iiY0BjkBurrNPibG51WcZVE9gUv6szhZ3gfV4Q8vQr7
         mMCqcuzzdxd8dh7c8RzXIl4K3lpRkSdVkprS+NMsqubPnP02lbaTAu7YKsSEFQBDAa
         ieFgse+o1qsfA==
Date:   Thu, 4 Nov 2021 12:02:37 -0700 (PDT)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@ubuntu-linux-20-04-desktop
To:     David Heidelberg <david@ixit.cz>
cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijeshkumar.singh@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        ~okias/devicetree@lists.sr.ht, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, sstabellini@kernel.org
Subject: Re: [PATCH] arm64: dts: drop legacy property #stream-id-cells
In-Reply-To: <20211030103117.33264-1-david@ixit.cz>
Message-ID: <alpine.DEB.2.22.394.2111041158220.284830@ubuntu-linux-20-04-desktop>
References: <20211030103117.33264-1-david@ixit.cz>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 30 Oct 2021, David Heidelberg wrote:
> Property #stream-id-cells is legacy leftover and isn't currently
> documented nor used.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  .../boot/dts/amd/amd-seattle-xgbe-b.dtsi      |  2 --
>  arch/arm64/boot/dts/qcom/msm8996.dtsi         |  1 -
>  arch/arm64/boot/dts/qcom/msm8998.dtsi         |  1 -
>  arch/arm64/boot/dts/qcom/sc7180.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sc7280.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sdm630.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sdm845.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sm8150.dtsi          |  1 -
>  arch/arm64/boot/dts/qcom/sm8250.dtsi          |  1 -
>  arch/arm64/boot/dts/xilinx/zynqmp.dtsi        | 28 -------------------
>  10 files changed, 38 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
> index d97498361ce3..3e9faace47f2 100644
> --- a/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
> +++ b/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
> @@ -55,7 +55,6 @@ xgmac0: xgmac@e0700000 {
>  		clocks = <&xgmacclk0_dma_250mhz>, <&xgmacclk0_ptp_250mhz>;
>  		clock-names = "dma_clk", "ptp_clk";
>  		phy-mode = "xgmii";
> -		#stream-id-cells = <16>;
>  		dma-coherent;
>  	};
>  
> @@ -81,7 +80,6 @@ xgmac1: xgmac@e0900000 {
>  		clocks = <&xgmacclk1_dma_250mhz>, <&xgmacclk1_ptp_250mhz>;
>  		clock-names = "dma_clk", "ptp_clk";
>  		phy-mode = "xgmii";
> -		#stream-id-cells = <16>;
>  		dma-coherent;
>  	};

#stream-id-cells is used to parse the legacy mmu-masters property (which
by the way Xen is still capable of parsing [1]).

So #stream-id-cells should be present if mmu-masters is present.

Looking at the patch and grepping for mmu-masters,
amd-seattle-xgbe-b.dtsi is the only one that has mmu-masters. So I think
this change to amd-seattle-xgbe-b.dtsi should be removed from the patch.
Everything else is fine.


[1] https://gitlab.com/xen-project/xen/-/blob/staging/xen/drivers/passthrough/arm/smmu.c#L2477
