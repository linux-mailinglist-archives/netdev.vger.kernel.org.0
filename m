Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869C72EC7A1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbhAGBRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:17:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbhAGBRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 20:17:30 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F2862311E;
        Thu,  7 Jan 2021 01:16:47 +0000 (UTC)
Date:   Wed, 6 Jan 2021 20:16:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [BUG] from x86: Support kmap_local() forced debugging
Message-ID: <20210106201645.72f57a47@oasis.local.home>
In-Reply-To: <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
References: <20201118194838.753436396@linutronix.de>
        <20201118204007.169209557@linutronix.de>
        <20210106180132.41dc249d@gandalf.local.home>
        <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 17:03:48 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> (although I wonder how/why the heck you've enabled
> CC_OPTIMIZE_FOR_SIZE=y, which is what causes "memcpy()" to be done as
> that "rep movsb". I thought we disabled it because it's so bad on most
> cpus).

Why?

Because to test x86_32, I have a Fedora Core 13 (yes 13!) partition
(baremetal) that I use. And the .config I use for it hasn't changed
since that time ;-) (except to add new features that I want to test on
x86_32).

Anyway, I'll test out your patch. Thanks for investigating this.

-- Steve
