Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5245FCD55
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJLVcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiJLVcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:32:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395E7120BF4;
        Wed, 12 Oct 2022 14:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xnFGWD1uy6BcknnACQ8OXcBBRlzYf3rf9rvmVnUeUFM=; b=2LSexal8o2u2Nc9bp2xnlLXBaT
        YSUlFWHl477Yxux/Xd/cTZS703eWgP1POFJoW4ifGhNpudUfctHl6tMvdxo8mAc6chTaQ9EO3iwq4
        Lavx1DEAi8lwcevq2+KfvB1lkUUKQRoI1XkvKfbH+5jnoBJ/QfV+oxUdNFHjexyBHYnA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oijKh-001pu6-Sz; Wed, 12 Oct 2022 23:32:07 +0200
Date:   Wed, 12 Oct 2022 23:32:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, kernel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 3/3] arm64: dts: imx93: add fec and eqos support
Message-ID: <Y0cyV84BbUd1X0Zk@lunn.ch>
References: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
 <20221012105129.3706062-4-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012105129.3706062-4-xiaoning.wang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	mdio {
> +		compatible = "snps,dwmac-mdio";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		clock-frequency = <5000000>;
> +
> +		ethphy1: ethernet-phy@1 {
> +			compatible = "ethernet-phy-ieee802.3-c22";

It is not wrong, but this is not needed, its the default.

   Andrew
