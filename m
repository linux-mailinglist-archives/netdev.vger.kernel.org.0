Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9626D4CEC0F
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 16:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiCFPSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 10:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiCFPSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 10:18:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDD4263B
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 07:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kwpvlaHje42FrFq1okuoSBTc7NR8B85cclyMB1p3swc=; b=v6OGIeDfoHY7C+tNYaOG8iITRH
        tipRvGeko3coZCWJ1LRtiPw4EU7hCsXumOKj6fb3vfGIbxCO0KSSLmw9mZ0fweechEQ6DG/6nm/+f
        2N3fm/u3eSNm0yVKBtDC262XDgX+vkzVpwrqvfb9LWztl2djVyM7TRIpVm8FY1efkaLM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nQsdq-009V8k-1J; Sun, 06 Mar 2022 16:17:50 +0100
Date:   Sun, 6 Mar 2022 16:17:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mdio-mux: add bus name to bus id
Message-ID: <YiTQnjjtlJfrHH/a@lunn.ch>
References: <00b4bb1e-98f9-b4e7-5549-e095a4701f66@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00b4bb1e-98f9-b4e7-5549-e095a4701f66@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 03:22:34PM +0100, Heiner Kallweit wrote:
> In case of DT-configured systems it may be hard to identify the PHY
> interrupt in the /proc/interrupts output. Therefore add the name to
> the id to make clearer that it's about a device on a muxed mdio bus.
> In my case:
> 
> Now: mdio_mux-0.e40908ff:08
> Before: 0.e40908ff:08
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
