Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DC9B8237
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 22:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392476AbfISUHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 16:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390722AbfISUHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 16:07:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 528A520644;
        Thu, 19 Sep 2019 20:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568923648;
        bh=F21kbg0+FJGAp3x7WrgiyNUhH6+7YhlXA1CXXKlR3to=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N4BibCbhJLL8KPKx/QkHhcOxpvIIITFN1jbshxD/ntFJYTsw5D68sZYh6kIFpZxU4
         0UR0MSmFts9vr35E5wxMO9eRIsYSeU9zI26MAqK92alQWkLiqZvxjU0Hwhc6b9HDRi
         BseCI9FGyLOh6lCgkfnwBSyV+S4AwqsWZ53mctcI=
Date:   Thu, 19 Sep 2019 22:07:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Paasch <christoph.paasch@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v4.14-stable 0/2] Fixes to commit fdfc5c8594c2 (tcp:
 remove empty skb from write queue in error cases)
Message-ID: <20190919200726.GA252076@kroah.com>
References: <20190913200819.32686-1-cpaasch@apple.com>
 <CALMXkpbL+P8ZM+Z8NHg644X7++opx2He5256D7ZLncntQp+8vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMXkpbL+P8ZM+Z8NHg644X7++opx2He5256D7ZLncntQp+8vw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 08:21:43AM -0700, Christoph Paasch wrote:
> Hello Greg & Sasha,
> 
> On Sat, Sep 14, 2019 at 12:20 AM Christoph Paasch <cpaasch@apple.com> wrote:
> >
> >
> > The above referenced commit has problems on older non-rbTree kernels.
> >
> > AFAICS, the commit has only been backported to 4.14 up to now, but the
> > commit that fdfc5c8594c2 is fixing (namely ce5ec440994b ("tcp: ensure epoll
> > edge trigger wakeup when write queue is empty"), is in v4.2.
> >
> > Christoph Paasch (2):
> >   tcp: Reset send_head when removing skb from write-queue
> >   tcp: Don't dequeue SYN/FIN-segments from write-queue
> 
> I'm checking in on these two patches for the 4.14 stable-queue.
> Especially the panic fixed by patch 2 is pretty easy to trigger :-/

Dude, it's been less than a week.  And it's the middle of the merge
window.  And it's the week after Plumbers and Maintainer's summit.

Relax...

I'll go queue these up now, but I am worried about them, given this
total mess the backports seem to have caused.

Why isn't this needed in 4.9.y and 4.4.y also?

thanks,

greg k-h
