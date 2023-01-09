Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A85662767
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbjAINlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbjAINlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:41:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88E93B91D;
        Mon,  9 Jan 2023 05:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qK6lV7QSTv9+pKbnrqwgqCq711Cf+sulr6SnpBvZui8=; b=Zx8K6ZeHDbrkxr9ADUvZf+K0M4
        GHLjqH5GaZW/Cnd3V6ObqhzDQ40z2BrJ3Rx7fGDAcq4oVBzAAq2IddwHX+7W4WX1MVg2/uxud6Jzg
        xMYB7gt8Tm0/7zeFvvJB1PEGVAWos7RQYvgzYaaIE+3xlEF96dJxYhGTYSNp5h78YmhI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pEsNm-001ZTL-Jf; Mon, 09 Jan 2023 14:40:10 +0100
Date:   Mon, 9 Jan 2023 14:40:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] net: phy: allow a phy to opt-out of
 interrupt handling
Message-ID: <Y7wZOhecFxq7E/9/@lunn.ch>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109123013.3094144-4-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 01:30:12PM +0100, Michael Walle wrote:
> Until now, it is not possible for a PHY driver to disable interrupts
> during runtime. If a driver offers the .config_intr() as well as the
> .handle_interrupt() ops, it is eligible for interrupt handling.
> Introduce a new flag for the dev_flags property of struct phy_device, which
> can be set by PHY driver to skip interrupt setup and fall back to polling
> mode.
> 
> At the moment, this is used for the MaxLinear PHY which has broken
> interrupt handling and there is a need to disable interrupts in some
> cases.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
