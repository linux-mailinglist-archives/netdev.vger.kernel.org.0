Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBCD23ADD4
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 21:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgHCT67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 15:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgHCT67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 15:58:59 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70633207DF;
        Mon,  3 Aug 2020 19:58:55 +0000 (UTC)
Date:   Mon, 3 Aug 2020 15:58:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Muchun Song <songmuchun@bytedance.com>, naveen.n.rao@linux.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH] kprobes: fix NULL pointer dereference at
 kprobe_ftrace_handler
Message-ID: <20200803155852.022ef199@oasis.local.home>
In-Reply-To: <20200803235042.6bacaf3eb53b7ab831f4edd3@kernel.org>
References: <20200728064536.24405-1-songmuchun@bytedance.com>
        <CAMZfGtUDmQgDySu7OSBNYv5y2_QJfzDcVeYG2eY6-1xYq+t1Uw@mail.gmail.com>
        <20200803235042.6bacaf3eb53b7ab831f4edd3@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Aug 2020 23:50:42 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Nice catch!
> 
> Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
> 
> Fixes: ae6aa16fdc16 ("kprobes: introduce ftrace based optimization")
> Cc: stable@vger.kernel.org

Thanks Masami,

I'll add this to my queue for the merge window.

-- Steve
