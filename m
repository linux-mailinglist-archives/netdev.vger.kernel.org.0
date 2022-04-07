Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D11734F7EB4
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiDGMIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245122AbiDGMHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:07:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DCA11C0A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:05:37 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ncQt6-0002Hk-5U; Thu, 07 Apr 2022 14:05:20 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ncQt3-0006v5-3a; Thu, 07 Apr 2022 14:05:17 +0200
Date:   Thu, 7 Apr 2022 14:05:17 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     alexandru.tachici@analog.com, andrew@lunn.ch, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v5 0/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20220407120347.GA25348@pengutronix.de>
References: <20220324112620.46963-1-alexandru.tachici@analog.com>
 <20220324160041.0d775df8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220324160041.0d775df8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:02:55 up 8 days, 32 min, 75 users,  load average: 0.70, 0.46,
 0.32
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 04:00:41PM -0700, Jakub Kicinski wrote:
> On Thu, 24 Mar 2022 13:26:13 +0200 alexandru.tachici@analog.com wrote:
> > The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
> > industrial Ethernet applications and is compliant with the IEEE 802.3cg
> > Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.
> 
> # Form letter - net-next is closed
> 
> We have already sent the networking pull request for 5.18
> and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
> 
> Please repost when net-next reopens after 5.18-rc1 is cut.
> 
> RFC patches sent for review only are obviously welcome at any time.

Hi Alexandru net-next is open now, you can rebase and resend this
patches.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
