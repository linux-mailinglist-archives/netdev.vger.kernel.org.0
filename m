Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFF340D127
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 03:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhIPBTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 21:19:12 -0400
Received: from smtp-3.orcon.net.nz ([60.234.4.44]:35353 "EHLO
        smtp-3.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhIPBTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 21:19:11 -0400
X-Greylist: delayed 2563 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2021 21:19:10 EDT
Received: from [121.99.228.40] (port=37816 helo=tower)
        by smtp-3.orcon.net.nz with esmtpa (Exim 4.90_1)
        (envelope-from <mcree@orcon.net.nz>)
        id 1mQfMJ-0001rk-UM; Thu, 16 Sep 2021 12:34:36 +1200
Date:   Thu, 16 Sep 2021 12:34:34 +1200
From:   Michael Cree <mcree@orcon.net.nz>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
Message-ID: <20210916003434.GB7246@tower>
Mail-Followup-To: Michael Cree <mcree@orcon.net.nz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
References: <20210915035227.630204-1-linux@roeck-us.net>
 <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-GeoIP: NZ
X-Spam_score: -2.9
X-Spam_score_int: -28
X-Spam_bar: --
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 12:18:58PM -0700, Linus Torvalds wrote:
> On Tue, Sep 14, 2021 at 8:52 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > This patch series introduces absolute_pointer() to fix the problem.
> > absolute_pointer() disassociates a pointer from its originating symbol
> > type and context, and thus prevents gcc from making assumptions about
> > pointers passed to memory operations.
> 
> Ok, I've applied this to my tree.
> 
> I note that the physical BOOT_PCB addresses in the alpha setup.h file
> might be useful for things like MILO in user space, but since I
> couldn't even find MILO sources any more, I couldn't really check.
> 
> I suspect alpha is basically on life support and presumably nobody
> would ever compile a bootloader anyway, so it's unlikely to matter.
> 
> If somebody does find any issues, we'll know better and we can ask
> where the user space sources are that might use that alpha setup.h
> file.

I think everyone uses aboot now as the bootloader on Alpha.  So as
long as we can still compile aboot everyone should be happy.

Cheers
Michael.
