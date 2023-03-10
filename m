Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004B86B3732
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCJHNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjCJHN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:13:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E852211B
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:13:27 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1paWwD-00009Y-5c; Fri, 10 Mar 2023 08:13:13 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1paWwA-0007IL-PW; Fri, 10 Mar 2023 08:13:10 +0100
Date:   Fri, 10 Mar 2023 08:13:10 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        Woojung.Huh@microchip.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, kernel@pengutronix.de
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: add
 ksz_setup_tc_mode() function
Message-ID: <20230310071310.GB29822@pengutronix.de>
References: <20230308091237.3483895-1-o.rempel@pengutronix.de>
 <20230308091237.3483895-2-o.rempel@pengutronix.de>
 <6263ddb2ad1fb38dcde524197b5897676c3ddf8c.camel@microchip.com>
 <95ca2bceeb4326b993a160f5c4e8b060e4f47392.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <95ca2bceeb4326b993a160f5c4e8b060e4f47392.camel@microchip.com>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 04:22:34AM +0000, Arun.Ramadoss@microchip.com wrote:
> On Fri, 2023-03-10 at 04:00 +0000, Arun Ramadoss - I17769 wrote:
> > On Wed, 2023-03-08 at 10:12 +0100, Oleksij Rempel wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > > know the content is safe
> > > 
> > > Add ksz_setup_tc_mode() to make queue scheduling and shaping
> > > configuration more visible.
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > 
> > Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com
> > 
> 
> If the ets command is supported only in KSZ9477 series of switch, do we
> need to return Not supported for KSZ87xx/KSZ88xx switch similar to tc
> cbs implementation. I could infer from the patch set that, all the
> register set are for KSZ9477, so invoking the command in
> KSZ87xx/KSZ88xx will have undefined behaviour. Correct me if I am
> wrong.

Ack. You are correct.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
