Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C56725A2B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbfEUVsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfEUVsO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 17:48:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8272217F9;
        Tue, 21 May 2019 21:48:12 +0000 (UTC)
Date:   Tue, 21 May 2019 17:48:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521174757.74ec8937@gandalf.local.home>
In-Reply-To: <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
        <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
        <20190521184137.GH2422@oracle.com>
        <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
        <20190521173618.2ebe8c1f@gandalf.local.home>
        <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 14:43:26 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> Steve,
> sounds like you've missed all prior threads.

I probably have missed them ;-)

> The feedback was given to Kris it was very clear:
> implement dtrace the same way as bpftrace is working with bpf.
> No changes are necessary to dtrace scripts
> and no kernel changes are necessary.

Kris, I haven't been keeping up on all the discussions. But what
exactly is the issue where Dtrace can't be done the same way as the
bpftrace is done?

-- Steve
