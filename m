Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0198E5C3
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 09:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbfHOHvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 03:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfHOHvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 03:51:50 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F9F92084D;
        Thu, 15 Aug 2019 07:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565855509;
        bh=OcToxkMk9gwSDl2BUebvNxigaLKXvR3X1ectJPWkRLE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ikYTm+Z+svls9M/L1vwCDEPOjor7PIuUJlBIMrqGDy5t9DD6cJBn+9lPsrRj4k/0A
         YcWUquzHr2EfuIY9gSs9nyeux6mM5QAff0gLwWAHzYsYRDmxc9IYZ1sVFcTHXC8uDK
         fRos8pRMya5Flsy5VvWWyluoO24ZWhf9SFNYxVZc=
Date:   Thu, 15 Aug 2019 08:51:42 +0100
From:   Will Deacon <will@kernel.org>
To:     syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>,
        bvanassche@acm.org
Cc:     akpm@linux-foundation.org, ast@kernel.org, bpf@vger.kernel.org,
        bvanassche@acm.org, daniel@iogearbox.net, davem@davemloft.net,
        dvyukov@google.com, hawk@kernel.org, hdanton@sina.com,
        jakub.kicinski@netronome.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, longman@redhat.com, mingo@kernel.org,
        netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Subject: Re: WARNING in is_bpf_text_address
Message-ID: <20190815075142.vuza32plqtiuhixx@willie-the-truck>
References: <00000000000000ac4f058bd50039@google.com>
 <000000000000e56cb0058fcc6c28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e56cb0058fcc6c28@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bart,

On Sat, Aug 10, 2019 at 05:24:06PM -0700, syzbot wrote:
> syzbot has found a reproducer for the following crash on:
> 
> HEAD commit:    451577f3 Merge tag 'kbuild-fixes-v5.3-3' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=120850a6600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2031e7d221391b8a
> dashboard link: https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130ffe4a600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17137d2c600000
> 
> The bug was bisected to:
> 
> commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Thu Feb 14 23:00:46 2019 +0000
> 
>     locking/lockdep: Free lock classes that are no longer in use
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000

I know you don't think much to these reports, but please could you have a
look (even if it's just to declare it a false positive)?

Cheers,

Will
