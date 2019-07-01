Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF6E5C255
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbfGARwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727270AbfGARwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:52:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D6C4206A3;
        Mon,  1 Jul 2019 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562003563;
        bh=ZGO7O3XCk7XjU6iuHr6MppSLXCp8g8SbuyRHmjaN+OY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0HMsdmwt132VKBe2H6UUL8Ts2vVnkNW+07F5NQvGJ/DkSDzonMdeUCqZT/2Aupfnr
         CL3gY0yacb348ueLMwT/VR1ye2tD7NpLLHUZP3PQAKjxpyN8Yzl/b4JEEBGDexuGVp
         6D636eOM8rrousg5uMIm6vB5t5xdFtyPdqk6FdKY=
Date:   Mon, 1 Jul 2019 19:52:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Josh Elsasser <jelsasser@appneta.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: net: check before dereferencing netdev_ops during busy poll
Message-ID: <20190701175241.GB9081@kroah.com>
References: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
 <20190628225533.GJ11506@sasha-vm>
 <1560226F-F2C0-440D-9C58-D664DE3C7322@appneta.com>
 <20190629074553.GA28708@kroah.com>
 <CAGnkfhzmGbeQe7L55nEv575XyubWqCLz=7NQPpH+TajDkkDiXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhzmGbeQe7L55nEv575XyubWqCLz=7NQPpH+TajDkkDiXg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 09:39:39PM +0200, Matteo Croce wrote:
> On Sat, Jun 29, 2019 at 9:45 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jun 28, 2019 at 07:03:01PM -0700, Josh Elsasser wrote:
> > > On Jun 28, 2019, at 3:55 PM, Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > > What's the upstream commit id?
> > >
> > > The commit wasn't needed upstream, as I only sent the original patch after
> > > 79e7fff47b7b ("net: remove support for per driver ndo_busy_poll()") had
> > > made the fix unnecessary in Linus' tree.
> > >
> > > May've gotten lost in the shuffle due to my poor Fixes tags. The patch in
> > > question applied only on top of the 4.9 stable release at the time, but the
> > > actual NPE had been around in some form since 3.11 / 0602129286705 ("net: add
> > > low latency socket poll").
> >
> > Ok, can people then resend this and be very explicit as to why this is
> > needed only in a stable kernel tree and get reviews from people agreeing
> > that this really is the correct fix?
> >
> > thanks,
> >
> > greg k-h
> 
> Hi Greg,
> 
> I think that David alredy reviewed the patch here:
> 
> https://lore.kernel.org/netdev/20180313.105115.682846171057663636.davem@davemloft.net/
> 
> Anyway, I tested the patch and it fixes the panic, at least on my
> iwlwifi card, so:
> 
> Tested-by: Matteo Croce <mcroce@redhat.com>

Ok, but what can I do with this?  I need a real patch, in mail form,
that I can apply.  Not a web link to an email archive.

You have read the stable kernel rules, right?  :)

greg k-h
