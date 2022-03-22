Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF794E3B74
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiCVJKT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Mar 2022 05:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiCVJKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:10:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE7D6E7BD
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:08:48 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWaV3-0002h8-Qv; Tue, 22 Mar 2022 10:08:21 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWaUn-002G5K-VH; Tue, 22 Mar 2022 10:08:08 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWaUq-00015B-0c; Tue, 22 Mar 2022 10:08:08 +0100
Message-ID: <b861bc8259084432dffe3ca6b3a76ee682fd4b64.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Dylan Hung <dylan_hung@aspeedtech.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date:   Tue, 22 Mar 2022 10:08:07 +0100
In-Reply-To: <HK0PR06MB28348F925FEDA3853DD3489D9C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
         <20220321095648.4760-4-dylan_hung@aspeedtech.com>
         <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
         <HK0PR06MB2834CFADF087A439B06F87C29C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
         <Yjk722CyEW3q1ntm@lunn.ch>
         <HK0PR06MB28348F925FEDA3853DD3489D9C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Di, 2022-03-22 at 03:22 +0000, Dylan Hung wrote:
> > -----Original Message-----
> > From: Andrew Lunn [mailto:andrew@lunn.ch]
> > Sent: 2022年3月22日 11:01 AM
> > To: Dylan Hung <dylan_hung@aspeedtech.com>
> > Cc: Krzysztof Kozlowski <krzk@kernel.org>; robh+dt@kernel.org;
> > joel@jms.id.au; andrew@aj.id.au; hkallweit1@gmail.com;
> > linux@armlinux.org.uk; davem@davemloft.net; kuba@kernel.org;
> > pabeni@redhat.com; p.zabel@pengutronix.de; 
> > devicetree@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org;
> > linux-aspeed@lists.ozlabs.org;
> > linux-kernel@vger.kernel.org; netdev@vger.kernel.org; BMC-SW
> > <BMC-SW@aspeedtech.com>; stable@vger.kernel.org
> > Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties
> > into MDIO
> > nodes
> > 
> > On Tue, Mar 22, 2022 at 02:32:13AM +0000, Dylan Hung wrote:
> > > > -----Original Message-----
> > > > From: Krzysztof Kozlowski [mailto:krzk@kernel.org]
> > > > Sent: 2022年3月21日 11:53 PM
> > > > To: Dylan Hung <dylan_hung@aspeedtech.com>; robh+dt@kernel.org;
> > > > joel@jms.id.au; andrew@aj.id.au; andrew@lunn.ch;
> > > > hkallweit1@gmail.com; linux@armlinux.org.uk; 
> > > > davem@davemloft.net;
> > > > kuba@kernel.org; pabeni@redhat.com; p.zabel@pengutronix.de;
> > > > devicetree@vger.kernel.org; 
> > > > linux-arm-kernel@lists.infradead.org;
> > > > linux-aspeed@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> > > > netdev@vger.kernel.org
> > > > Cc: BMC-SW <BMC-SW@aspeedtech.com>; stable@vger.kernel.org
> > > > Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset
> > > > properties
> > > > into MDIO nodes
> > > > 
> > > > On 21/03/2022 10:56, Dylan Hung wrote:
> > > > > Add reset control properties into MDIO nodes.  The 4 MDIO
> > > > > controllers in
> > > > > AST2600 SOC share one reset control bit SCU50[3].
> > > > > 
> > > > > Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> > > > > Cc: stable@vger.kernel.org
> > > > 
> > > > Please describe the bug being fixed. See stable-kernel-rules.
> > > 
> > > Thank you for your comment.
> > > The reset deassertion of the MDIO device was usually done by the
> > bootloader (u-boot).
> > > However, one of our clients uses proprietary bootloader and
> > > doesn't
> > > deassert the MDIO reset so failed to access the HW in kernel
> > > driver.
> > 
> > So are you saying mainline u-boot releases the reset?
> > 
> Yes, if the mdio devices are used in u-boot.
> 
> > > The reset deassertion is missing in the kernel driver since it
> > > was
> > > created, should I add a BugFix for the first commit of this
> > > driver?
> > 
> > Yes, that is normal. Ideally the kernel should not depend on u-
> > boot, because
> > often people want to use other bootloaders, e.g. barebox. You
> > should also
> > consider kexec, where one kernel hands over to another kernel,
> > without the
> > bootloader being involved. In such a situation, you ideally want to
> > assert and
> > deassert the reset just to clean away any state the old kernel left
> > around.
> > 
> > But please do note, that the reset is optional, since you need to
> > be able to
> > work with old DT blobs which don't have the reset property in them.
> > 
> 
> Thank you. I will let the reset property be optional and modify the
> error-checking in the driver accordingly in V3.

No need to change the error checking, just use 
devm_reset_control_get_optional_shared().


regards
Philipp
