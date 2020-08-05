Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD31423D049
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgHETbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgHERIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 13:08:17 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AA6A22D00;
        Wed,  5 Aug 2020 17:08:09 +0000 (UTC)
Date:   Wed, 5 Aug 2020 13:08:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     naveen.n.rao@linux.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, mhiramat@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, sfr@canb.auug.org.au, mingo@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [External] Re: [PATCH v2] kprobes: fix NULL pointer dereference
 at kprobe_ftrace_handler
Message-ID: <20200805130807.268cc1a8@oasis.local.home>
In-Reply-To: <CAMZfGtW2LJTUB6OaixF-V0tVPXt5kEzVvUvOSbO551r0vvZGbg@mail.gmail.com>
References: <20200805162713.16386-1-songmuchun@bytedance.com>
        <20200805125056.1dfe74b5@oasis.local.home>
        <CAMZfGtW2LJTUB6OaixF-V0tVPXt5kEzVvUvOSbO551r0vvZGbg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Aug 2020 00:59:41 +0800
Muchun Song <songmuchun@bytedance.com> wrote:

> > The original patch has already been pulled into the queue and tested.
> > Please make a new patch that adds this update, as if your original
> > patch has already been accepted.  
> 
> Will do, thanks!

Also, if you can, add the following:

Link: https://lore.kernel.org/r/20200805142136.0331f7ea@canb.auug.org.au

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")

It's no big deal if you don't, because I will ;-)

-- Steve
