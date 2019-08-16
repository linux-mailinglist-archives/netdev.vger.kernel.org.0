Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FD28FDAF
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfHPIVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbfHPIVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:21:40 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEA64206C2;
        Fri, 16 Aug 2019 08:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565943699;
        bh=45xE287d0eM04My2txp6SH/3Wubo253uv59ZVJNr3VE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NbVyzIfb5MQEr6j7Y68FkNmVHLmnWhZAp/RXXMr37iQb7uEdjcJvTGpAm3OWaxMn7
         KoZ3FgZA1MSqEEQUvlKLIfdxnG694Hk9b/RtcaQLEazfJWAb/lFHzrw0i10uDKqAm5
         Oqz/4mXpbrFX8rP3Lo6HqdOoJTJbjvoDqsxD3s+g=
Date:   Fri, 16 Aug 2019 09:21:31 +0100
From:   Will Deacon <will@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dvyukov@google.com,
        hawk@kernel.org, hdanton@sina.com, jakub.kicinski@netronome.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, longman@redhat.com, mingo@kernel.org,
        netdev@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org,
        torvalds@linux-foundation.org, will.deacon@arm.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Subject: Re: WARNING in is_bpf_text_address
Message-ID: <20190816082130.2shhirk53qofn6bj@willie-the-truck>
References: <00000000000000ac4f058bd50039@google.com>
 <000000000000e56cb0058fcc6c28@google.com>
 <20190815075142.vuza32plqtiuhixx@willie-the-truck>
 <456d0da6-3e16-d3fc-ecf6-7abb410bf689@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <456d0da6-3e16-d3fc-ecf6-7abb410bf689@acm.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 06:39:56PM -0700, Bart Van Assche wrote:
> On 8/15/19 12:51 AM, Will Deacon wrote:
> > On Sat, Aug 10, 2019 at 05:24:06PM -0700, syzbot wrote:
> > > The bug was bisected to:
> > > 
> > > commit a0b0fd53e1e67639b303b15939b9c653dbe7a8c4
> > > Author: Bart Van Assche <bvanassche@acm.org>
> > > Date:   Thu Feb 14 23:00:46 2019 +0000
> > > 
> > >      locking/lockdep: Free lock classes that are no longer in use
> > > 
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152f6a9da00000
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=172f6a9da00000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=132f6a9da00000
> > 
> > I know you don't think much to these reports, but please could you have a
> > look (even if it's just to declare it a false positive)?
> 
> Had you already noticed the following message?
> 
> https://lore.kernel.org/bpf/d76d7a63-7854-e92d-30cb-52546d333ffe@iogearbox.net/
> 
> From that message: "Hey Bart, don't think it's related in any way to your
> commit. I'll allocate some time on working on this issue today, thanks!"

Apologies, but I hadn't received that when I sent my initial email. Anyway,
just wanted to make sure somebody was looking into it!

Will
