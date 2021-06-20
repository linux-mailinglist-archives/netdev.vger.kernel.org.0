Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B9C3ADF21
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 16:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhFTO4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 10:56:22 -0400
Received: from www.linux-watchdog.org ([185.87.125.42]:55846 "EHLO
        www.linux-watchdog.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhFTO4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 10:56:14 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jun 2021 10:56:13 EDT
Received: by www.linux-watchdog.org (Postfix, from userid 502)
        id 6C971409DF; Sun, 20 Jun 2021 15:30:36 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 www.linux-watchdog.org 6C971409DF
Date:   Sun, 20 Jun 2021 15:30:36 +0200
From:   gituser@www.linux-watchdog.org
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] watchdog: Remove MV64x60 watchdog driver
Message-ID: <20210620133036.GA18128@www.linux-watchdog.org>
References: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
 <31d702e5-22d1-1766-76dd-e24860e5b1a4@roeck-us.net>
 <87im3hk3t2.fsf@mpe.ellerman.id.au>
 <e2a33fc1-f519-653d-9230-b06506b961c5@roeck-us.net>
 <87czsyfo01.fsf@mpe.ellerman.id.au>
 <20210607112950.GB314533@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210607112950.GB314533@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

On Mon, Jun 07, 2021 at 04:29:50AM -0700, Guenter Roeck wrote:
> On Mon, Jun 07, 2021 at 11:43:26AM +1000, Michael Ellerman wrote:
> > Guenter Roeck <linux@roeck-us.net> writes:
> > > On 5/17/21 4:17 AM, Michael Ellerman wrote:
> > >> Guenter Roeck <linux@roeck-us.net> writes:
> > >>> On 3/18/21 10:25 AM, Christophe Leroy wrote:
> > >>>> Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
> > >>>> removed the last selector of CONFIG_MV64X60.
> > >>>>
> > >>>> Therefore CONFIG_MV64X60_WDT cannot be selected anymore and
> > >>>> can be removed.
> > >>>>
> > >>>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> > >>>
> > >>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > >>>
> > >>>> ---
> > >>>>   drivers/watchdog/Kconfig       |   4 -
> > >>>>   drivers/watchdog/Makefile      |   1 -
> > >>>>   drivers/watchdog/mv64x60_wdt.c | 324 ---------------------------------
> > >>>>   include/linux/mv643xx.h        |   8 -
> > >>>>   4 files changed, 337 deletions(-)
> > >>>>   delete mode 100644 drivers/watchdog/mv64x60_wdt.c
> > >> 
> > >> I assumed this would go via the watchdog tree, but seems like I
> > >> misinterpreted.
> > >> 
> > >
> > > Wim didn't send a pull request this time around.
> > >
> > > Guenter
> > >
> > >> Should I take this via the powerpc tree for v5.14 ?
> > 
> > I still don't see this in the watchdog tree, should I take it?
> > 
> It is in my personal watchdog-next tree, but afaics Wim hasn't picked any
> of it up yet. Wim ?

Picking it up right now.

Kind regards,
Wim.

