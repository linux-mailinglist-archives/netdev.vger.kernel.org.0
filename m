Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D97ED8B25
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389094AbfJPIhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:37:31 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34685 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfJPIhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 04:37:31 -0400
Received: from kresse.hi.pengutronix.de ([2001:67c:670:100:1d::2a])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1iKeoC-0001WI-RN; Wed, 16 Oct 2019 10:37:28 +0200
Message-ID: <0426ad33c45627627512f636c45e35481d2b77da.camel@pengutronix.de>
Subject: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Christian Herber <christian.herber@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Oct 2019 10:37:27 +0200
In-Reply-To: <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
         <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::2a
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fr, 2019-08-16 at 22:59 +0200, Heiner Kallweit wrote:
> On 15.08.2019 17:32, Christian Herber wrote:
> > This patch adds basic support for BASE-T1 PHYs in the framework.
> > BASE-T1 PHYs main area of application are automotive and industrial.
> > BASE-T1 is standardized in IEEE 802.3, namely
> > - IEEE 802.3bw: 100BASE-T1
> > - IEEE 802.3bp 1000BASE-T1
> > - IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S
> > 
> > There are no products which contain BASE-T1 and consumer type PHYs like
> > 1000BASE-T. However, devices exist which combine 100BASE-T1 and 1000BASE-T1
> > PHYs with auto-negotiation.
> 
> Is this meant in a way that *currently* there are no PHY's combining Base-T1
> with normal Base-T modes? Or are there reasons why this isn't possible in
> general? I'm asking because we have PHY's combining copper and fiber, and e.g.
> the mentioned Aquantia PHY that combines NBase-T with 1000Base-T2.

There are PHYs combining both Base-T1 and other Base-T capabilities.
E.g. the Broadcom BCM54811 support both Base-T1, as well as 1000BASE-T
and 100BASE-TX.

Regards,
Lucas

