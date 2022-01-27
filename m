Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3E49D68E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiA0AHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:07:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233418AbiA0AHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 19:07:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=J0yHmzr7Bes1AQyZcP7Txq+9cpESQjph6YFpeH3l8Ug=; b=0VDrWO+BT42h67xlYtGTodPhBo
        VmN6BdIbOVDuzY6vALbfR19NYqiT9lxjVT2sIvV8U/kMoBh7dJWTzFLffNTH3069NyKrXPPLKaces
        GS9qFfMIp+Gv8lg6qQbBZ7361KQTmg2wzHZLQikJpFqyDRadtm3Yhk7FuMkXRbLPGNF8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCsK1-002sZ3-V0; Thu, 27 Jan 2022 01:07:29 +0100
Date:   Thu, 27 Jan 2022 01:07:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5/8] arm64: dts: qcom: sa8155p-adp: Enable ethernet node
Message-ID: <YfHiQYkeQYwjl3G7@lunn.ch>
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-6-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126221725.710167-6-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +&ethernet {
> +	status = "okay";
> +
> +	snps,reset-gpio = <&tlmm 79 GPIO_ACTIVE_LOW>;
> +	snps,reset-active-low;
> +	snps,reset-delays-us = <0 11000 70000>;
> +
> +	snps,ptp-ref-clk-rate = <250000000>;
> +	snps,ptp-req-clk-rate = <96000000>;
> +
> +	snps,mtl-rx-config = <&mtl_rx_setup>;
> +	snps,mtl-tx-config = <&mtl_tx_setup>;
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&ethernet_defaults>;
> +
> +	phy-handle = <&rgmii_phy>;
> +	phy-mode = "rgmii";

Where are the rgmii delays being added for this board?

      Andrew
