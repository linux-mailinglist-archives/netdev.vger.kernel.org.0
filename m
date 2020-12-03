Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB992CE074
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgLCVRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:17:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLCVRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 16:17:45 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkvyI-00A6oU-Tj; Thu, 03 Dec 2020 22:17:02 +0100
Date:   Thu, 3 Dec 2020 22:17:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Edwards <grant.b.edwards@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201203211702.GK2333853@lunn.ch>
References: <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
 <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch>
 <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch>
 <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
 <rq9nih$egv$1@ciao.gmane.io>
 <20201203040758.GC2333853@lunn.ch>
 <rqav0e$4m3$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rqav0e$4m3$1@ciao.gmane.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 03:07:58PM -0000, Grant Edwards wrote:
> On 2020-12-03, Andrew Lunn <andrew@lunn.ch> wrote:
> >> So I can avoid my local hack to macb_main.c by doing a doing a local
> >> hack to macb_main.c?
> >
> > User space drivers were never supported in any meaningful way. The
> > IOCTL call is basically there for mii-tool, and nothing much more.
> 
> I probably wouldn't call a single ioctl() to check the link status a
> user-space-driver, but I guess that's what it is. If it's good enough
> for the mii-tool, it's good enough for me.
> 
> > The way to avoid your local hack is to move your drivers into the
> > kernel, along side all the other drivers for devices on MDIO busses.
> 
> I don't think I can justify the additional effort to devlope and
> maintain a custom kern-space driver.

Why custom? You should contribute it.

> >> Was there some other way I should have done this with a 5.4 kernel
> >> that I was unable to discover?

Ah, i missed you are using 5.4. You should probably jump to 5.10. There
have been quite a few changes in this area in the macb driver.
> 
> BTW Andrew, we're still shipping plenty of product that running
> eCos. :)

Cool. There is still a space for such an RTOS, linux has not yet taken
over the world everywhere.

     Andrew
