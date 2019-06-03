Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179CA337C8
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 20:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfFCSZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 14:25:15 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:38267 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFCSZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 14:25:15 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 125B44000A;
        Mon,  3 Jun 2019 18:25:04 +0000 (UTC)
Date:   Mon, 3 Jun 2019 19:53:09 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     linux-sunxi@googlegroups.com, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [linux-sunxi] [PATCH v6 0/6] Add support for Orange Pi 3
Message-ID: <20190603175309.qjlyfymbl6ybrpag@flea>
References: <20190527162237.18495-1-megous@megous.com>
 <20190531125246.qqfvmgmw2mv442tq@core.my.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190531125246.qqfvmgmw2mv442tq@core.my.home>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 02:52:46PM +0200, Ondřej Jirman wrote:
> Hello,
>
> On Mon, May 27, 2019 at 06:22:31PM +0200, megous via linux-sunxi wrote:
> > From: Ondrej Jirman <megous@megous.com>
> >
> > This series implements support for Xunlong Orange Pi 3 board.
> >
> > Unfortunately, this board needs some small driver patches, so I have
> > split the boards DT patch into chunks that require patches for drivers
> > in various subsystems.
> >
> > Suggested merging plan/dependencies:
> >
> > - stmmac patches are needed for ethernet support (patches 1-3)
> >   - these should be ready now
> > - HDMI support (patches 4-6)
> >   - should be ready
>
> If there are no futher comments, can all these patches please be merged?

I'm waiting for some feedback on the stmmac and the DW-HDMI
developpers to merge the rest

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
