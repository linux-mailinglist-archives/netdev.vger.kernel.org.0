Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F094F0A37
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbiDCOlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiDCOla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19363205E1;
        Sun,  3 Apr 2022 07:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6109611C9;
        Sun,  3 Apr 2022 14:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934EBC340ED;
        Sun,  3 Apr 2022 14:39:34 +0000 (UTC)
Date:   Sun, 3 Apr 2022 10:39:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2] tracing: Set user_events to BROKEN
Message-ID: <20220403103933.787cc4de@rorschach.local.home>
In-Reply-To: <20220330155835.5e1f6669@gandalf.local.home>
References: <20220330155835.5e1f6669@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 15:58:35 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> After being merged, user_events become more visible to a wider audience
> that have concerns with the current API. It is too late to fix this for
> this release, but instead of a full revert, just mark it as BROKEN (which
> prevents it from being selected in make config). Then we can work finding
> a better API. If that fails, then it will need to be completely reverted.
> 
> Link: https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Linus,

I noticed that you pulled in this patch (slightly updated subject). I
had it part of my queue that was going thought my tests, which have
just finished. I was going to send you a pull request today.

Is it OK that I keep that patch? Otherwise, I need to pull it out and
rerun my tests without it.

I would have had this to you earlier but because of the merge
conflicts of my last pull request that this queue depended on, I based
all my new changes off of the merge commit you had made with my
previous pull request, and that contained bugs that would prevent my
tests from passing (as you saw with the one memory mapping issue).

I'll go ahead and send you the pull request that I have that contains
this patch as well, but feel free to reject it if you want me to redo
my queue without it.

-- Steve
