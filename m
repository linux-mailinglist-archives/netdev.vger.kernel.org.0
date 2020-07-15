Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78461221427
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGOSTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:19:54 -0400
Received: from verein.lst.de ([213.95.11.211]:60094 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgGOSTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 14:19:53 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 254CC68AFE; Wed, 15 Jul 2020 20:19:50 +0200 (CEST)
Date:   Wed, 15 Jul 2020 20:19:49 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christoph Hellwig <hch@lst.de>, Doug Nazar <nazard@nazar.ca>,
        ericvh@gmail.com, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/9p: validate fds in p9_fd_open
Message-ID: <20200715181949.GA31172@lst.de>
References: <20200710085722.435850-1-hch@lst.de> <5bee3e33-2400-2d85-080e-d10cd82b0d85@nazar.ca> <20200711104923.GA6584@nautica> <20200715073715.GA22899@lst.de> <20200715134756.GB22828@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715134756.GB22828@nautica>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 03:47:56PM +0200, Dominique Martinet wrote:
> Christoph Hellwig wrote on Wed, Jul 15, 2020:
> > FYI, this is now generating daily syzbot reports, so I'd love to see
> > the fix going into Linus' tree ASAP..
> 
> Yes, I'm getting some syzbot warnings as well now.
> 
> I had however only planned to get this in linux-next, since that is what
> the syzbot mails were complaining about, but I see this got into -rc5...
> 
> 
> It's honestly just a warn on something that would fail anyway so I'd
> rather let it live in -next first, I don't get why syzbot is so verbose
> about this - it sent a mail when it found a c repro and one more once it
> bisected the commit yesterday but it should not be sending more?

Yes, I agree that this is just a warning on existing behavior.  But then
again these constant syzbot reports are pretty annoying..

> (likewise it should pick up the fix tag even if it only gets in -next,
> or would it keep being noisy unless this gets merged to mainline?)
> 
> 
> FWIW this is along with the 5 other patches I have queued for 5.9
> waiting for my tests as my infra is still down, I've stopped trying to
> make promises, but I could push at least just this one to -next if that
> really helps.
> Sorry for that, things should be smoother once I've taken the time to
> put things back in place.

No need to be sorry, just through it might be worth to ping you.

Thanks for all your help!
