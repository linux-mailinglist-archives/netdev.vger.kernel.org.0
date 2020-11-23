Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154572C17FB
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbgKWVtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:49:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38586 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgKWVtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 16:49:19 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606168157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWoabT64+bllfkSbYbuvYXig8GKR3JUjvD1l7ZSAJwA=;
        b=PxgsNoRMH0Rr40VpLK8D0PqVJ9cHiuyB2SsXzszyFbnoizn58KGi+0mK/WB+PboPf/X+/7
        BhFlCNONiTSk90MBVfZEMOTUwdAojjEu1i+kigRRy8HSZ7RPWvPEXumE+ktFeDn6jOkPlj
        x8c7UfVbC/8oDEEHkLHJ3YxIjjunA8Um7Hbz3hLwam3fgcHdv8RAiQ3AlHdLgZbHG1FnO1
        6vBA8xxRONKWYZ7HCwlk2y6J6vrwZ2q4TXyruQ1qHo9VMCusWXYHjzNJmK9G2kzUngpZew
        n3RqR3zLeaaZdYWevvQ5zxv0c6x8Tv8O5PYMXtVUWrBxhFZCYFdqRkgoQiBk4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606168157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWoabT64+bllfkSbYbuvYXig8GKR3JUjvD1l7ZSAJwA=;
        b=ieiCQJI+UzpNGa8RZqgGRzoedOkaUxVXJKdL7QdFPi4aTYRb1pLu8vBwVEUPqSm5p5F4mW
        Tp16jMSfqR6mIGBw==
To:     Alex Belits <abelits@marvell.com>,
        "nitesh\@redhat.com" <nitesh@redhat.com>,
        "frederic\@kernel.org" <frederic@kernel.org>
Cc:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "trix\@redhat.com" <trix@redhat.com>,
        "mingo\@kernel.org" <mingo@kernel.org>,
        "catalin.marinas\@arm.com" <catalin.marinas@arm.com>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx\@redhat.com" <peterx@redhat.com>,
        "linux-arch\@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti\@redhat.com" <mtosatti@redhat.com>,
        "will\@kernel.org" <will@kernel.org>,
        "peterz\@infradead.org" <peterz@infradead.org>,
        "leon\@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld\@redhat.com" <pauld@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 2/9] task_isolation: vmstat: add vmstat_idle function
In-Reply-To: <6ac7143e5038614e3950636456cef67b5bc0c9e4.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com> <6ac7143e5038614e3950636456cef67b5bc0c9e4.camel@marvell.com>
Date:   Mon, 23 Nov 2020 22:49:17 +0100
Message-ID: <87blfnn3qa.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23 2020 at 17:56, Alex Belits wrote:
> This function checks to see if a vmstat worker is not running,
> and the vmstat diffs don't require an update.  The function is
> called from the task-isolation code to see if we need to
> actually do some work to quiet vmstat.

A changelog has to explain _WHY_ this change is necessary and not _WHAT_
the patch is doing.

Thanks,

        tglx
