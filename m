Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446CF54BFA7
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 04:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244355AbiFOC0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 22:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbiFOCZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 22:25:59 -0400
Received: from smtp3.emailarray.com (smtp3.emailarray.com [65.39.216.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AEC18359
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 19:25:55 -0700 (PDT)
Received: (qmail 40272 invoked by uid 89); 15 Jun 2022 02:25:54 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANTAuMjM2LjE4NC4xMg==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 15 Jun 2022 02:25:54 -0000
Date:   Tue, 14 Jun 2022 19:25:53 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v7 3/3] net: phy: Add support for 1PPS out and
 external timestamps
Message-ID: <20220615022553.kkw7hoqm72r3yvmd@bsd-mbp>
References: <20220614050810.54425-1-jonathan.lemon@gmail.com>
 <20220614050810.54425-4-jonathan.lemon@gmail.com>
 <81e43c3f-a10e-3167-a868-61794bd66466@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e43c3f-a10e-3167-a868-61794bd66466@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 09:25:38AM -0700, Florian Fainelli wrote:
> On 6/13/22 22:08, Jonathan Lemon wrote:
> > The perout function is used to generate a 1PPS signal, synchronized
> > to the PHC.  This is accomplished by a using the hardware oneshot
> > functionality, which is reset by a timer.
> > 
> > The external timestamp function is set up for a 1PPS input pulse,
> > and uses a timer to poll for temestamps.
> > 
> > Both functions use the SYNC_OUT/SYNC_IN1 pin, so cannot run
> > simultaneously.
> > 
> > Co-developed-by: Lasse Johnsen <l@ssejohnsen.me>
> > Signed-off-by: Lasse Johnsen <l@ssejohnsen.me>
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > Acked-by: Richard Cochran <richardcochran@gmail.com>
> 
> Not sure whether we could apply just patch 1 and 2 and leave this one aside
> as I do see a few things that IMHO would be worth updating before merging
> this one, more on the stylistic aspect though, so you be the judge.

If you feel strongly about it, I can spin up some style fixes.

Personally, I prefer the simpler statements, and the compiler will
likely generate the same code.
-- 
Jonathan
