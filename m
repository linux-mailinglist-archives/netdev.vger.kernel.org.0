Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DE44E371F
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 04:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiCVDCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 23:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiCVDCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 23:02:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3044541A2;
        Mon, 21 Mar 2022 20:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=b9U/YwFXv20yTfLFWbuRAqJRHhEpMtnMkWj3xf7Fzmc=; b=UI
        EEw8H1dCe2232LDPhplovW5e6NBNhkEiNVcTx8Gi+C/x/aWmMF0oZf5UfZpX9ycafyR2rIwhvk8lb
        S/63ptPf6TBvFK8o+Ed2oh96jDXeLIDwEiH9B/Kpyln2pE00hYBEMbinj77+zZNRU1jjfimUnpmqq
        vVUHfXSoVMB8oGM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWUlH-00C3s4-PQ; Tue, 22 Mar 2022 04:00:43 +0100
Date:   Tue, 22 Mar 2022 04:00:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Message-ID: <Yjk722CyEW3q1ntm@lunn.ch>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
 <20220321095648.4760-4-dylan_hung@aspeedtech.com>
 <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
 <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 02:32:13AM +0000, Dylan Hung wrote:
> > -----Original Message-----
> > From: Krzysztof Kozlowski [mailto:krzk@kernel.org]
> > Sent: 2022年3月21日 11:53 PM
> > To: Dylan Hung <dylan_hung@aspeedtech.com>; robh+dt@kernel.org;
> > joel@jms.id.au; andrew@aj.id.au; andrew@lunn.ch; hkallweit1@gmail.com;
> > linux@armlinux.org.uk; davem@davemloft.net; kuba@kernel.org;
> > pabeni@redhat.com; p.zabel@pengutronix.de; devicetree@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org; linux-aspeed@lists.ozlabs.org;
> > linux-kernel@vger.kernel.org; netdev@vger.kernel.org
> > Cc: BMC-SW <BMC-SW@aspeedtech.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
> > nodes
> > 
> > On 21/03/2022 10:56, Dylan Hung wrote:
> > > Add reset control properties into MDIO nodes.  The 4 MDIO controllers in
> > > AST2600 SOC share one reset control bit SCU50[3].
> > >
> > > Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> > > Cc: stable@vger.kernel.org
> > 
> > Please describe the bug being fixed. See stable-kernel-rules.
> 
> Thank you for your comment.
> The reset deassertion of the MDIO device was usually done by the bootloader (u-boot).
> However, one of our clients uses proprietary bootloader and doesn't deassert the MDIO
> reset so failed to access the HW in kernel driver.

So are you saying mainline u-boot releases the reset?

> The reset deassertion is missing in the
> kernel driver since it was created, should I add a BugFix for the first commit of this driver?

Yes, that is normal. Ideally the kernel should not depend on u-boot,
because often people want to use other bootloaders, e.g. barebox. You
should also consider kexec, where one kernel hands over to another
kernel, without the bootloader being involved. In such a situation,
you ideally want to assert and deassert the reset just to clean away
any state the old kernel left around.

But please do note, that the reset is optional, since you need to be
able to work with old DT blobs which don't have the reset property in
them.

	Andrew



