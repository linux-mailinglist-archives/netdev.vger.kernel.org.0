Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD234F020D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390042AbfKEQAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:00:36 -0500
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:41752 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389760AbfKEQAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:00:36 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 1B49218224D6E;
        Tue,  5 Nov 2019 16:00:35 +0000 (UTC)
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2914:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4385:5007:6119:6120:6261:7514:7875:7901:7903:10010:10400:10967:11232:11658:11914:12043:12296:12297:12663:12740:12760:12895:13069:13161:13229:13311:13357:13439:14096:14097:14181:14659:14721:21080:21324:21433:21450:21451:21627:21740:21795:30012:30051:30054:30066:30090:30091,0,RBL:146.247.46.6:@goodmis.org:.lbl8.mailshell.net-62.8.41.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:2:0,LFtime:37,LUA_SUMMARY:none
X-HE-Tag: pail42_5c0b34e3fa954
X-Filterd-Recvd-Size: 2506
Received: from grimm.local.home (unknown [146.247.46.6])
        (Authenticated sender: rostedt@goodmis.org)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Tue,  5 Nov 2019 16:00:32 +0000 (UTC)
Date:   Tue, 5 Nov 2019 11:00:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, peterz@infradead.org, x86@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH bpf-next 0/7] Introduce BPF trampoline
Message-ID: <20191105110028.7775192f@grimm.local.home>
In-Reply-To: <20191105154709.utmzm6qvtlux4hww@ast-mbp.dhcp.thefacebook.com>
References: <20191102220025.2475981-1-ast@kernel.org>
        <20191105143154.umojkotnvcx4yeuq@ast-mbp.dhcp.thefacebook.com>
        <20191105104024.4e99a630@grimm.local.home>
        <20191105154709.utmzm6qvtlux4hww@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.4git49 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 07:47:11 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > If you have to wait you may need to wait. The Linux kernel isn't
> > something that is suppose to put in temporary hacks, just to satisfy
> > someone's deadline.  
> 
> Ok. I will switch to text_poke and will make it hack free.
> ftrace mechanisms are being replaced by text_poke anyway.

I see that Facebook now owns Linux.

Peter's text poke patches most likely not be ready for the next
merge window either. Don't you require them?

The database of function nops are part of the ftrace mechanisms which
are not part of text poke, and there's strong accounting associated to
them which allows the user to see how their kernel is modified. This is
why I was against the live kernel patching modifying the function code
directly, because the user loses out on visibility into how their
kernel is being modified. Any "replacement" would require the same
transparency into the modification of the kernel.

I see how you work. You pressure someone into jumping to do your all
mighty work, and if they don't jump as you would like them too, you
work to circumvent them and try to make them irrelevant.

I'm sure the rest of the community will enjoy working with you too.

-- Steve
