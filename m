Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B90510137
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 16:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347847AbiDZPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351834AbiDZPBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:01:44 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCA5B1A9B;
        Tue, 26 Apr 2022 07:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1650985071;
        bh=KLCjLhfQTgA0oKxUS8a8HV/nxwOxtsyC4o79WkTfje8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IIcY48H9YK8/QDBNpiRiNIjM5ijvX9dPgdmCPggiTIq7XwNedhwHy18OxeYmKHEoF
         aTWxmr4FQ9c9f1+BSP3KA3mTvOPXFvrXnR56rwSg8opVpkVDmlW5t7ss7YGXvUhPii
         MK5BlLt3w1SEQLCrqBWvI62kQpytjOvDD7ZZPMaA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.77.37] ([80.245.77.37]) by web-mail.gmx.net
 (3c-app-gmx-bs69.server.lan [172.19.170.214]) (via HTTP); Tue, 26 Apr 2022
 16:57:50 +0200
MIME-Version: 1.0
Message-ID: <trinity-8ceec42c-8705-4808-b37b-9e9849ba774e-1650985070928@3c-app-gmx-bs69>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Aw: [RFC v1 3/3] arm64: dts: rockchip: Add mt7531 dsa node to
 BPI-R2-Pro board
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 26 Apr 2022 16:57:50 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20220426134924.30372-4-linux@fw-web.de>
References: <20220426134924.30372-1-linux@fw-web.de>
 <20220426134924.30372-4-linux@fw-web.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:wBW5QJYpMHdq3PrMhGinR1AdioQG5dT+v1AUhYrsDygj5o2ETBmB7lzitdogghO9fUJ34
 7C+S+3eGXblSF48OoeX01rSKkoLZx+5zlIPitqd/reCb/PRwuR3znVtcbV6WiXGQw9fKCED9pXjl
 Yqa7X5QsU8EBNE1dsh3kVNkMGRtDKOoHGLkrRf7GTn8z0SY+JQ6juNUXpn1GZl+laWiX/FtsqqgA
 Ye27fCi0B2ZSew4gY/X1gzmzAfDOgUNCH3qY9mTUMWRxlDCIDxa1Wg084wN8Bg56b4e0IO/LVl4D
 Qc=
X-UI-Out-Filterresults: notjunk:1;V03:K0:41kc6tKK5sg=:EDOaU6bOsIT1ZaYJ+7rZT4
 ul8RUcVdFNTJTPhR0EmciMDWP/g6o5NGLfUZmDgSUNOU8LhvXxvfMQVPT8xvM5No8QyQIbn8p
 WMKpXo9jDASBQp5oAj0e+GrzTnpb5vgLTshGaXlYY3HoKQ8wAfMaejoi/1ZxTv84/iGtHUGSY
 /G6B35z0oyXoPDsU1l56EIMFgjGcCm183owIWmaTlTRBwLA0GVTzC4JsHMyxRP1gfzIxj22B8
 O/D50GXl1IFfPc01KMVhe04uv3tzA6QtQQVgtRFqxnXtllj2fRbmUos/0Fm/ann/0wlOpOAtZ
 EqUzTxAlRXhQdKgIpYjjYkzfiMcAbUs+oIVACxTJcUBBzzCygQQPs5nhdvhf0E7TZaOjV7oTG
 RXa/eCwTZCoXO/XYcyAZC86TrMQ2sfzX2WRS0uiiEMEUzJt8xYokLe4p79IjT8zZa87WinMsl
 QyFLU1u8cGd1nm5XZ/St9Ujq5DnuhwN67mNGTj+ieasHZSPWubsLPAHfmFtAwIG37FKgvckQn
 KkRLuySR8bhQ99HM8D1hiPo3RvV3NsbQxWxb311FPu0Eh6OSNrZbUE3bxgTHx+HKnDxcV3f35
 tVlt1abs3yLoH4Z3CbvTXV8g8mzJCPirOCEwhH0yv/EtSa+8tmhEsUTZ6TyZaKWp7E8j4+dFv
 CABs6rKSUkmCf6VeZozZk0q83zD29Nep3MjfI1n60J2xSBoq0WVp0ATaLKsXCgso9g5LsjY0a
 z251OrYA/UMD62CBfDskbdcjm/W52tCy/N+3PGEqj/65yPZIeG6Xj8rVvf9/LFDVKHFIN0y5l
 wmiNiYq
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Dienstag, 26. April 2022 um 15:49 Uhr
> Von: "Frank Wunderlich" <linux@fw-web.de>

> +&mdio0 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	switch@0 {
> +		compatible = "mediatek,mt7531";
> +		reg = <0>;
> +		status = "disabled";

seems i had missed to delete this, but it looks like it was ignored as switch was probed

> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;

