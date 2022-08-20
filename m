Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B9D59ADD7
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 14:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346212AbiHTMKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346200AbiHTMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 08:10:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4821E80483
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 05:10:19 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPNIj-0003PM-Cd; Sat, 20 Aug 2022 14:10:05 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPNIi-00024O-Ny; Sat, 20 Aug 2022 14:10:04 +0200
Date:   Sat, 20 Aug 2022 14:10:04 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 4/7] net: pse-pd: add generic PSE driver
Message-ID: <20220820121004.GG10138@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-5-o.rempel@pengutronix.de>
 <YwABUCYRRiCns3bO@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwABUCYRRiCns3bO@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
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

On Fri, Aug 19, 2022 at 11:32:00PM +0200, Andrew Lunn wrote:
> On Fri, Aug 19, 2022 at 02:01:06PM +0200, Oleksij Rempel wrote:
> > Add generic driver to support simple Power Sourcing Equipment without
> > automatic classification support.
> > 
> > This driver was tested on 10Bast-T1L switch with regulator based PoDL PSE.
> 
> Do you have access to a PHY which implements clause 45.2.9? That seems
> like a better reference implementation?

Suddenly I do not have access to any of them. 

> I don't know the market, what is more likely, a simple regulator, or
> something more capable with an interface like 45.2.9?

So far I was not able to find any PoDL PES IC (with classification
support). Or PHY with PoDL PSE on one package. If some one know any,
please let me know.

> netlink does allow us to keep adding more attributes, so we don't need
> to be perfect first time, but it seems like 45.2.9 is what IEEE expect
> vendors to provide, so at some point Linux should implement it.

ack.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
