Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5962D1C436D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbgEDR4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgEDR4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:56:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286F8C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:56:36 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1jVfJy-0004nF-Rx; Mon, 04 May 2020 19:56:02 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1jVfJp-0002rR-TC; Mon, 04 May 2020 19:55:53 +0200
Date:   Mon, 4 May 2020 19:55:53 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        alsa-devel@alsa-project.org,
        Olivier Moysan <olivier.moysan@st.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, Jyri Sarha <jsarha@ti.com>,
        Mark Brown <broonie@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Sandy Huang <hjc@rock-chips.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] docs: dt: fix broken links due to txt->yaml renames
Message-ID: <20200504175553.jdm7a7aabloevxba@pengutronix.de>
References: <967df5c3303b478b76199d4379fe40f5094f3f9b.1588584538.git.mchehab+huawei@kernel.org>
 <20200504174522.GA3383@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200504174522.GA3383@ravnborg.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sam,

On Mon, May 04, 2020 at 07:45:22PM +0200, Sam Ravnborg wrote:
> On Mon, May 04, 2020 at 11:30:20AM +0200, Mauro Carvalho Chehab wrote:
> > There are some new broken doc links due to yaml renames
> > at DT. Developers should really run:
> > 
> > 	./scripts/documentation-file-ref-check
> > 
> > in order to solve those issues while submitting patches.
> Would love if some bot could do this for me on any patches that creates
> .yaml files or so.
> I know I will forget this and it can be automated.
> If I get a bot mail that my patch would broke a link I would
> have it fixed before it hits any tree.

What about adding a check to check_patch?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |
