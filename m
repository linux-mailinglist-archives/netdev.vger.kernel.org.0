Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0151F2DF18C
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 21:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgLSUZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 15:25:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34424 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbgLSUZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 15:25:44 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kqimW-00CtUt-Oo; Sat, 19 Dec 2020 21:24:48 +0100
Date:   Sat, 19 Dec 2020 21:24:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 8/8] arm64: dts: sparx5: Add the Sparx5 switch node
Message-ID: <20201219202448.GE3026679@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-9-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217075134.919699-9-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		port13: port@13 {
> +			reg = <13>;
> +			/* Example: CU SFP, 1G speed */
> +			max-speed = <10000>;

One too many 0's for 1G.

> +		/* 25G SFPs */
> +		port56: port@56 {
> +			reg = <56>;
> +			max-speed = <10000>;

Why limit a 25G SFP to 10G?

    Andrew
