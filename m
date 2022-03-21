Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381774E2617
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347273AbiCUMNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347256AbiCUMM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:12:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8631F35271;
        Mon, 21 Mar 2022 05:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wfPqTrMLZmI62s7w5pDJOhr0oJWgwZyXFkacCjOAFtg=; b=S8EhJW9bc1yCRidAUH8gazE1IQ
        tPFmz4auIwvdRcZ2vgyddW+hz3/QfSTWPC8gCVlEDmU5C7a7L/6Upx1AoKFU8rAFH7jzdvZkQELzv
        9TPFPM2fQi/Yc5MRRE9B/UCIVcL4F052ICKlQoQzo7TGU87X5j7R0GuJVOCWRodjiANk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWGsE-00BwHU-Tb; Mon, 21 Mar 2022 13:10:58 +0100
Date:   Mon, 21 Mar 2022 13:10:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     robh+dt@kernel.org, joel@jms.id.au, andrew@aj.id.au,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, BMC-SW@aspeedtech.com
Subject: Re: [PATCH 0/2] Add reset deassertion for Aspeed MDIO
Message-ID: <YjhrUrXzLxvKtDP8@lunn.ch>
References: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 03:01:29PM +0800, Dylan Hung wrote:
> Add missing reset deassertion for Aspeed MDIO. There are 4 MDIOs
> embedded in Aspeed AST2600 and share one reset control bit SCU50[3].

Is the reset limited to the MDIO bus masters, or are PHYs one the bus
potentially also reset?

Who asserts the reset in the first place? Don't you want the first
MDIO bus to probe to assert and then deassert the reset in order that
all the hardware is reset?

    Andrew
