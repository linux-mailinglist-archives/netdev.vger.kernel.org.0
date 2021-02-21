Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF12320AAD
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 14:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhBUNwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 08:52:36 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:58328 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhBUNwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 08:52:34 -0500
Date:   Sun, 21 Feb 2021 16:51:32 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Jose Abreu <joabreu@synopsys.com>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/20] net: phy: realtek: Fix events detection failure in
 LPI mode
Message-ID: <20210221135132.5uaogtn7h3gd4inr@mobilestation>
References: <20210208140341.9271-2-Sergey.Semin@baikalelectronics.ru>
 <8300d9ca-b877-860f-a975-731d6d3a93a5@gmail.com>
 <20210209101528.3lf47ouaedfgq74n@mobilestation>
 <a652c69b-94d3-9dc6-c529-1ebc0ed407ac@gmail.com>
 <20210209105646.GP1463@shell.armlinux.org.uk>
 <20210210164720.migzigazyqsuxwc6@mobilestation>
 <20210211103941.GW1463@shell.armlinux.org.uk>
 <20210220090248.oiyonlfucvmgzw6d@mobilestation>
 <4dcecf82-f222-4957-f5fc-e8f9d073599c@gmail.com>
 <YDEvglPLbUcNp0dR@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YDEvglPLbUcNp0dR@lunn.ch>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 04:49:22PM +0100, Andrew Lunn wrote:
> > If in doubt, leaving the patch as is would be fine with me.
> 
> The patch is O.K. as is, no need to export something so simple for a
> single users. When the next user come along, we can reconsider.

Ok. Thanks for clarification. I performed some additional tests to
make sure the bug was on the PHY side. They proved my original
conclusion. It's indeed Realtek PHY to blame for the weird behavior. 
So I've added a few more words into the patch log regarding those
tests. The patch will be resent tomorrow together with the rest of the
STMMAC-driver-related bug-fixes detached from the original series of
the fixes and cleanups (as Andrew asked to do).

-Sergey

> 
>        Andrew
