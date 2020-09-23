Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE3276109
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 21:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWT2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 15:28:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51774 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgIWT2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 15:28:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLAR3-00FvEk-HY; Wed, 23 Sep 2020 21:28:13 +0200
Date:   Wed, 23 Sep 2020 21:28:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Power cycle phy on PM resume
Message-ID: <20200923192813.GE3764123@lunn.ch>
References: <20200923074751.10527-1-kai.heng.feng@canonical.com>
 <17092088-86ff-2d31-b3de-2469419136a3@molgen.mpg.de>
 <AC6D77B8-244D-4816-8FFE-A4480378EC4C@canonical.com>
 <79f01082-c9b1-f80a-7af4-b61bdbf40c90@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79f01082-c9b1-f80a-7af4-b61bdbf40c90@molgen.mpg.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > How much does this increase the resume time?

Define resume time? Until you get the display manager unlock screen?
Or do you need working networking?

It takes around 1.5 seconds for auto negotiation to get a link. I know
it takes me longer than that to move my fingers to the keyboard and
type in my password to unlock the screen. So by the time you actually
get to see your desktop, you should have link.

I've no idea about how the e1000e driver does link negotiation. But
powering the PHY off means there is going to be a negotiation sometime
later. But if you don't turn it off, the driver might be able to avoid
doing an autoneg if the PHY has already done one when it got powered
up.

      Andrew
