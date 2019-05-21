Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011D925A07
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfEUVgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbfEUVgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 17:36:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAFF82173E;
        Tue, 21 May 2019 21:36:19 +0000 (UTC)
Date:   Tue, 21 May 2019 17:36:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521173618.2ebe8c1f@gandalf.local.home>
In-Reply-To: <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
        <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
        <20190521184137.GH2422@oracle.com>
        <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 13:55:34 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > The reasons for these patches is because I cannot do the same with the existing
> > implementation.  Yes, I can do some of it or use some workarounds to accomplish
> > kind of the same thing, but at the expense of not being able to do what I need
> > to do but rather do some kind of best effort alternative.  That is not the goal
> > here.  
> 
> what you call 'workaround' other people call 'feature'.
> The kernel community doesn't accept extra code into the kernel
> when user space can do the same.

If that was really true, all file systems would be implemented on
FUSE ;-)

I was just at a technical conference that was not Linux focused, and I
talked to a lot of admins that said they would love to have Dtrace
scripts working on Linux unmodified.

I need to start getting more familiar with the workings of eBPF and
then look at what Dtrace has to see where something like this can be
achieved, but right now just NACKing patches outright isn't being
helpful. If you are not happy with this direction, I would love to see
conversations where Kris shows you exactly what is required (from a
feature perspective, not an implementation one) and we come up with a
solution.

-- Steve
