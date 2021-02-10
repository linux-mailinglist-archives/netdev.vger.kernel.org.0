Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BE316DC4
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhBJSDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:03:54 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:34978 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbhBJSBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:01:06 -0500
Date:   Wed, 10 Feb 2021 21:00:07 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/16] net: stmmac: Add DW MAC GPIOs and Baikal-T1 GMAC
 support
Message-ID: <20210210180007.tjuvbjw7rpmxhsll@mobilestation>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
 <YCGSwZnSXIz5Ssef@lunn.ch>
 <20210209111609.tjxoqr6stkcf22jy@mobilestation>
 <YCKYHay9PsR2o04z@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YCKYHay9PsR2o04z@lunn.ch>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 03:11:41PM +0100, Andrew Lunn wrote:
> > Regarding splitting the series up. I don't see a problem in just
> > sending the cover-letter patch and actual GPIO-related patches to
> > the GPIO-maintainers with no need to have them added to Cc in the rest
> > of the series.
> 

> The Linux community has to handle a large number of patches. I don't
> particularly want patches which are of no relevance to me landing in
> my mailbox. It might take 4 or 5 rounds for the preparation patches to
> be accepted. That is 4 or 5 times you are spamming the GPIO
> maintainers with stuff which is not relevant to them.

I don't really understand what you are arguing with. My suggestion
didn't contradict to what you said. I exactly meant to omit sending
the patches to GPIO maintainers, which they had no relevance to. So
they wouldn't be spammed with unwanted patches. The GPIO maintainers
can be Cc/To-ed only to the messages with GPIO-related patches. It's
normal to have intermixed patchsets, but to post individual patches to
the maintainers they might be interested in or they need to review. So
splitting up isn't required in this case.  Moreover doing as you
suggest would extend the time of the patches review with no really
much gain in the emailing activity optimization.

> 
> One of the unfortunately things about the kernel process is, there are
> a lot of developers, and not many maintainers. So the processes need
> to make the life of maintainers easier, and not spamming them helps.

Can't argue with that.)

-Sergey

> 
>    Andrew
