Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D14AF5CB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiBIPxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbiBIPxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:53:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC52C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:53:40 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHpHm-0006r8-Hg; Wed, 09 Feb 2022 16:53:38 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nHpHl-00089m-Jb; Wed, 09 Feb 2022 16:53:37 +0100
Date:   Wed, 9 Feb 2022 16:53:37 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1] dt-bindings: net: ethernet-controller:
 document label property
Message-ID: <20220209155337.GA26024@pengutronix.de>
References: <20220209082820.2210753-1-o.rempel@pengutronix.de>
 <CAL_Jsq+nWLrs0eAvNwV3suT4Xw+sLo6=yJhV9CyZXj+-xRE+Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+nWLrs0eAvNwV3suT4Xw+sLo6=yJhV9CyZXj+-xRE+Zg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:45:52 up 61 days, 31 min, 83 users,  load average: 0.14, 0.17,
 0.18
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 09:34:36AM -0600, Rob Herring wrote:
> On Wed, Feb 9, 2022 at 2:28 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >
> > "label" provides human readable name used on a box, board or schematic
> > to identify Ethernet port.
> 
> Do you still need this?

Yes. No need to force label based name from kernel, but user space
should be able to use it to rename interface if needed or use it for
GUI. Otherwise user space will need to have date base of all boards to
provide this information.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
