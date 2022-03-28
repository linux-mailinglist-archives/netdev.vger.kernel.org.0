Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18EB4E9907
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243677AbiC1OOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242898AbiC1OOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:14:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD75DA4E;
        Mon, 28 Mar 2022 07:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZZCazdSp2Q40b/BqagmCEGgqZGwX+/8FIUUT+tT2tnw=; b=OOw1pmOu6r1p7DbwSfYO8CCHgy
        bQHxPSPcJpEoCQdrBbwtUKAdXMrr6Mv6ScQJfq9YtYwiLA5AugQYCMfjaKTH89Q8QivikqQaA6AHX
        UVbS5D+6X+j+9XNj/kU8X236uB+zd+DGIAde+v2d8VP0J+A7yFAxdtIbpIE66bgIZIac=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nYq6j-00D1qF-7O; Mon, 28 Mar 2022 16:12:33 +0200
Date:   Mon, 28 Mar 2022 16:12:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/5] net: mdio: fwnode: add fwnode_mdiobus_register()
Message-ID: <YkHCUbWxaqDJeQoK@lunn.ch>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
 <20220325172234.1259667-2-clement.leger@bootlin.com>
 <Yj4MIIu7Qtvv25Fs@lunn.ch>
 <20220328082642.471281e7@fixe.home>
 <YkGyFJuUDS6x4wrC@lunn.ch>
 <20220328152700.74be6037@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328152700.74be6037@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> With this series, fwnode_mdiobus_register() supports exactly the same
> subset that is supported by of_mdiobus_register().

I need to see the side-by-side conversion. But it looked to me you did
not support everything in DT.

And another question is, should it support everything in DT. The DT
binding has things which are deprecated. We have to support them in
DT, they are ABI. But anything new should not be using them.

    Andrew

