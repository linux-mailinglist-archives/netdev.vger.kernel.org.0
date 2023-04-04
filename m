Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1D46D6823
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbjDDQBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbjDDQBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:01:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274BF2D55
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 09:00:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjj5S-00033Z-VH; Tue, 04 Apr 2023 18:00:46 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjj5Q-00043l-2C; Tue, 04 Apr 2023 18:00:44 +0200
Date:   Tue, 4 Apr 2023 18:00:44 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun.Ramadoss@microchip.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        Woojung.Huh@microchip.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, kernel@pengutronix.de
Subject: Re: [PATCH net-next v1 3/7] net: dsa: microchip: ksz8: Make
 ksz8_r_sta_mac_table() static
Message-ID: <20230404160044.GC4044@pengutronix.de>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-4-o.rempel@pengutronix.de>
 <6d428dfa9b1e3e008a4ecc8c8f8653843afad794.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6d428dfa9b1e3e008a4ecc8c8f8653843afad794.camel@microchip.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 03:11:02PM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Oleksij,
> On Tue, 2023-04-04 at 12:18 +0200, Oleksij Rempel wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > As ksz8_r_sta_mac_table() is only used within ksz8795.c, there is no
> > need
> > to export it. Make the function static for better encapsulation.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz8.h    | 2 --
> >  drivers/net/dsa/microchip/ksz8795.c | 4 ++--
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz8.h
> > b/drivers/net/dsa/microchip/ksz8.h
> > index ad2c3a72a576..d87f8ebc6323 100644
> > --- a/drivers/net/dsa/microchip/ksz8.h
> > +++ b/drivers/net/dsa/microchip/ksz8.h
> > @@ -21,8 +21,6 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16
> > reg, u16 *val);
> >  int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val);
> >  int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8
> > *mac_addr,
> >                          u8 *fid, u8 *src_port, u8 *timestamp, u16
> > *entries);
> > -int ksz8_r_sta_mac_table(struct ksz_device *dev, u16 addr,
> > -                        struct alu_struct *alu);
> 
> 
> ksz8_r_dyn_mac_table() also not used outside KSZ8795.h. It can
> also be made static

:) Ack, i have pending series of patch for dyn MAC table.

> Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>



-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
