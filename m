Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7677655163
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 15:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiLWO2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 09:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLWO2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 09:28:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5A737FA6;
        Fri, 23 Dec 2022 06:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=i14Y9Pt0caAT0qbfJh818uuCqr7HO6PtFcjSn4atUWw=; b=nu0jHclv6qPxMEU2iUiAtckJ2c
        fuNHxV50YeJJZ2t7FEjdmw81Ih1JN0ek+kJQSTbeHVuVIhuawxgRl4lrBWlkv+2hpA0cqsFzjO1Uy
        lApKCGr3IvHV5NtpQVRbcONiT800a3zQ8dUW2JnfgNuZj008NRo+bW42KiICA8itLA84=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p8j2K-000LEI-1K; Fri, 23 Dec 2022 15:28:36 +0100
Date:   Fri, 23 Dec 2022 15:28:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Suman Anna <s-anna@ti.com>, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        ssantosh@kernel.org, srk@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Message-ID: <Y6W7FNzJEHYt6URg@lunn.ch>
References: <20221223110930.1337536-1-danishanwar@ti.com>
 <20221223110930.1337536-2-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223110930.1337536-2-danishanwar@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +        ethernet-ports {
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +            pruss2_emac0: port@0 {
> +                reg = <0>;
> +                phy-handle = <&pruss2_eth0_phy>;
> +                phy-mode = "rgmii-rxid";

That is unusual. Where are the TX delays coming from?

     Andrew
