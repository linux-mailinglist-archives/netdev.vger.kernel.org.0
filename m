Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2321422E3AE
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 03:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgG0Bi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 21:38:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgG0Bi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 21:38:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jzs5s-0072Kp-Uv; Mon, 27 Jul 2020 03:38:20 +0200
Date:   Mon, 27 Jul 2020 03:38:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, cphealy@gmail.com,
        martin.fuzzey@flowbird.group
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727013820.GI1661457@lunn.ch>
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727012354.GT28704@pendragon.ideasonboard.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 04:23:54AM +0300, Laurent Pinchart wrote:
> Hi Fugang,
> 
> On Mon, Apr 27, 2020 at 10:08:04PM +0800, Fugang Duan wrote:
> > This reverts commit 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef.
> > 
> > The commit breaks ethernet function on i.MX6SX, i.MX7D, i.MX8MM,
> > i.MX8MQ, and i.MX8QXP platforms. Boot yocto system by NFS mounting
> > rootfs will be failed with the commit.
> 
> I'm afraid this commit breaks networking on i.MX7D for me :-( My board
> is configured to boot over NFS root with IP autoconfiguration through
> DHCP. The DHCP request goes out, the reply it sent back by the server,
> but never noticed by the fec driver.
> 
> v5.7 works fine. As 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef was merged
> during the v5.8 merge window, I suspect something else cropped in
> between 29ae6bd1b0d8a57d7c00ab12cbb949fc41986eef and this patch that
> needs to be reverted too. We're close to v5.8 and it would be annoying
> to see this regression ending up in the released kernel. I can test
> patches, but I'm not familiar enough with the driver (or the networking
> subsystem) to fix the issue myself.

Hi Laurent

We had a few reverts and reverts of reverts etc. But in the end it
seemed to work fine for a range of boards/SoCs.

What exactly are you testing here? v5.8-rc7?

Thanks
	Andrew
