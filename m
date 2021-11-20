Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE49457EF0
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 16:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbhKTP3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 10:29:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhKTP3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 10:29:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HTvgLzOoOehOykOOZoN1M1R/6gNgBUMtdPME5ZKHJhI=; b=Po37m8bITJ9E+j5M7j04ddReFk
        HL9oqmnO/lQRpSq8rmGYs47hTw7RKhxwyQM4+MNjpd0MjRiKINKpzzShyg6Dz2NzA1qEUTrbVpcnt
        teDlRuM0hp+gVrlKeSy/+DhJCak1eOTcGFi6MJbDrhpW+BoL86bFilUVFmLer7dqT8Tw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1moSFl-00E9aB-TB; Sat, 20 Nov 2021 16:26:09 +0100
Date:   Sat, 20 Nov 2021 16:26:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc:     robh+dt@kernel.org, aisheng.dong@nxp.com, qiangqing.zhang@nxp.com,
        davem@davemloft.net, kuba@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH 4/4] arm64: dts: imx8ulp-evk: enable fec
Message-ID: <YZkTkagrQ/zafYEQ@lunn.ch>
References: <20211120115825.851798-1-peng.fan@oss.nxp.com>
 <20211120115825.851798-5-peng.fan@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120115825.851798-5-peng.fan@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +&fec {
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&pinctrl_enet>;
> +	phy-mode = "rmii";

Is this really a Fast Ethernet? Not 1G?

> +	phy-handle = <&ethphy>;
> +	status = "okay";
> +
> +	mdio {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		ethphy: ethernet-phy {
> +			reg = <1>;

I'm surprised this does not give warnings from the DTS tools. There is
a reg value, so it should be ethernet-phy@1

  Andrew
