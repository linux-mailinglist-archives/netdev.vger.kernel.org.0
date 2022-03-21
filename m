Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9994E2415
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346223AbiCUKRR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 21 Mar 2022 06:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346165AbiCUKRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:17:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF1D97BB5
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:15:51 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWF4U-0002Cp-A5; Mon, 21 Mar 2022 11:15:30 +0100
Received: from [2a0a:edc0:0:900:1d::4e] (helo=lupine)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWF4O-0024FB-Af; Mon, 21 Mar 2022 11:15:25 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1nWF4O-0005mG-5W; Mon, 21 Mar 2022 11:15:24 +0100
Message-ID: <15c3836ecc42c1fea36a51b11a0f47757d06605f.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/3] net: mdio: add reset control for Aspeed MDIO
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Dylan Hung <dylan_hung@aspeedtech.com>, robh+dt@kernel.org,
        joel@jms.id.au, andrew@aj.id.au, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     BMC-SW@aspeedtech.com, stable@vger.kernel.org
Date:   Mon, 21 Mar 2022 11:15:24 +0100
In-Reply-To: <20220321095648.4760-3-dylan_hung@aspeedtech.com>
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
         <20220321095648.4760-3-dylan_hung@aspeedtech.com>
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

On Mo, 2022-03-21 at 17:56 +0800, Dylan Hung wrote:
> Add reset assertion/deassertion for Aspeed MDIO.  There are 4 MDIO
> controllers embedded in Aspeed AST2600 SOC and share one reset
> control
> register SCU50[3]. So devm_reset_control_get_shared is used in this
> change.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>


regards
Philipp
