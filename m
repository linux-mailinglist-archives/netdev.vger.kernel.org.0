Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27B9314E1D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBILSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:18:50 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:59830 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhBILQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 06:16:56 -0500
Date:   Tue, 9 Feb 2021 14:16:09 +0300
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
Message-ID: <20210209111609.tjxoqr6stkcf22jy@mobilestation>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
 <YCGSwZnSXIz5Ssef@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YCGSwZnSXIz5Ssef@lunn.ch>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:36:33PM +0100, Andrew Lunn wrote:
> On Mon, Feb 08, 2021 at 05:08:04PM +0300, Serge Semin wrote:
> 
> Hi Serge
> 
> I suggest you split this patchset up. This uses the generic GPIO
> framework, which is great. But that also means you should be Cc: the
> GPIO subsystem maintainers and list. But you don't want to spam them
> with all the preparation work, which has little to do with the GPIO
> code.
> 
> So please split the actual GPIO driver and DT binding patches from the
> rest. netdev can review the preparation work, with a comment in the
> 0/X patch about what the big picture is, and then afterwards review
> the GPIO patchset with a wider audience.
> 
> And as Jakub pointed out, nobody is going to review 60 patches all at
> once. Please submit one series at a time, get it merged, and then
> move onto the next.

Hello Andrew
Right, with all that preparation work I've forgotten to Cc the
GPIO-subsystem maintainers. Thanks for noticing this.

Regarding the 60-patches. Please see my response to Jakub' post in the
first series. To cut it short let's start working with that patchset:
Link: https://lore.kernel.org/netdev/20210208135609.7685-1-Sergey.Semin@baikalelectronics.ru/
I'll rebase and resubmit the rest of the work when the time comes.

Regarding splitting the series up. I don't see a problem in just
sending the cover-letter patch and actual GPIO-related patches to
the GPIO-maintainers with no need to have them added to Cc in the rest
of the series. That's a normal practice. Splitting is not really
required. But since I have to split the very first patchset anyway.
I'll split this one up too, when it comes to have this part of changes
reviewed.

-Sergey

> 
> 	 Andrew
