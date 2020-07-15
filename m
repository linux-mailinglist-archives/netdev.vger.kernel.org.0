Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134DB220E66
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 15:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731871AbgGONsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 09:48:13 -0400
Received: from nautica.notk.org ([91.121.71.147]:42742 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730872AbgGONsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 09:48:12 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 21180C01B; Wed, 15 Jul 2020 15:48:11 +0200 (CEST)
Date:   Wed, 15 Jul 2020 15:47:56 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Doug Nazar <nazard@nazar.ca>, ericvh@gmail.com, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/9p: validate fds in p9_fd_open
Message-ID: <20200715134756.GB22828@nautica>
References: <20200710085722.435850-1-hch@lst.de>
 <5bee3e33-2400-2d85-080e-d10cd82b0d85@nazar.ca>
 <20200711104923.GA6584@nautica>
 <20200715073715.GA22899@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200715073715.GA22899@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig wrote on Wed, Jul 15, 2020:
> FYI, this is now generating daily syzbot reports, so I'd love to see
> the fix going into Linus' tree ASAP..

Yes, I'm getting some syzbot warnings as well now.

I had however only planned to get this in linux-next, since that is what
the syzbot mails were complaining about, but I see this got into -rc5...


It's honestly just a warn on something that would fail anyway so I'd
rather let it live in -next first, I don't get why syzbot is so verbose
about this - it sent a mail when it found a c repro and one more once it
bisected the commit yesterday but it should not be sending more?

(likewise it should pick up the fix tag even if it only gets in -next,
or would it keep being noisy unless this gets merged to mainline?)


FWIW this is along with the 5 other patches I have queued for 5.9
waiting for my tests as my infra is still down, I've stopped trying to
make promises, but I could push at least just this one to -next if that
really helps.
Sorry for that, things should be smoother once I've taken the time to
put things back in place.
-- 
Dominique
