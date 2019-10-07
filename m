Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A193CEC8F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfJGTQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:16:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbfJGTQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 15:16:19 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E8BF20684;
        Mon,  7 Oct 2019 19:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570475778;
        bh=vmjUwj39TJfCLdZXBkUogtW5Y56lvQtCgPNPWCSU/3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nVK5PcETjQ5ypL9fayQwCeeIJ2F8Os52bZZ1BvkTI/LVKYPu2nw3ot7EXFLiVklKt
         NxLaRxjyVitl7rZHH70u7R3TARIWYWj4ALZmGCSmQl6pEn0kx/FdnIm4tWGTNKp8dJ
         w3yYxYA7TXhZQUfZpbaQF7h4G1UZq3CwWUeSyMdc=
Date:   Mon, 7 Oct 2019 12:16:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     syzbot <syzbot+896295c817162503d359@syzkaller.appspotmail.com>,
        davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in devlink_get_from_attrs
Message-ID: <20191007191615.GC16653@gmail.com>
Mail-Followup-To: Jiri Pirko <jiri@resnulli.us>,
        syzbot <syzbot+896295c817162503d359@syzkaller.appspotmail.com>,
        davem@davemloft.net, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000b11343059456a5f5@google.com>
 <20191007191102.GD2326@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007191102.GD2326@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 09:11:02PM +0200, Jiri Pirko wrote:
> Mon, Oct 07, 2019 at 08:59:11PM CEST, syzbot+896295c817162503d359@syzkaller.appspotmail.com wrote:
> >Hello,
> >
> >syzbot found the following crash on:
> >
> >HEAD commit:    056ddc38 Merge branch 'stmmac-next'
> >git tree:       net-next
> >console output: https://syzkaller.appspot.com/x/log.txt?x=1590218f600000
> >kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
> >dashboard link: https://syzkaller.appspot.com/bug?extid=896295c817162503d359
> >compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a6a6c3600000
> >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fd50dd600000
> >
> >IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >Reported-by: syzbot+896295c817162503d359@syzkaller.appspotmail.com
> >
> >kasan: CONFIG_KASAN_INLINE enabled
> >kasan: GPF could be caused by NULL-ptr deref or user memory access
> >general protection fault: 0000 [#1] PREEMPT SMP KASAN
> >CPU: 1 PID: 8790 Comm: syz-executor447 Not tainted 5.4.0-rc1+ #0
> >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> >Google 01/01/2011
> >RIP: 0010:devlink_get_from_attrs+0x32/0x300 net/core/devlink.c:124
> 
> This is fixed already by:
> 5c23afb980b2 ("net: devlink: fix reporter dump dumpit")
> 

Great, let's tell syzbot so that it will close this bug report:

#syz fix: net: devlink: fix reporter dump dumpit

(It's actually commit 82a843de41d42, by the way.)

- Eric
