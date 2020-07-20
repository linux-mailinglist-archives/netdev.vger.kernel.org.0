Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984012254F6
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 02:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGTAbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 20:31:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgGTAbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 20:31:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxJi3-005wsL-TL; Mon, 20 Jul 2020 02:31:11 +0200
Date:   Mon, 20 Jul 2020 02:31:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool] Fix segfault with cable test and ./configure
 --disable-netlink
Message-ID: <20200720003111.GN1383417@lunn.ch>
References: <20200716220509.1314265-1-andrew@lunn.ch>
 <20200720001251.5nwf7nhcivl6b4yk@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720001251.5nwf7nhcivl6b4yk@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 02:12:51AM +0200, Michal Kubecek wrote:
> On Fri, Jul 17, 2020 at 12:05:09AM +0200, Andrew Lunn wrote:
> > When the netlink interface code is disabled, a stub version of
> > netlink_run_handler() is used. This stub version needs to handle the
> > case when there is no possibility for a command to fall back to the
> > IOCTL call. The two cable tests commands have no such fallback, and if
> > we don't handle this, ethtool tries to jump through a NULL pointer
> > resulting in a segfault.
> > 
> > Reported-by: Chris Healy <cphealy@gmail.com>
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Applied, thank you. I'll need to be more thorough with teseting the
> --disable-netlink builds.

Hi Michal

Yes. We are all focused on retlink, and missed the backwards
compatibility issues like this.

      Andrew
