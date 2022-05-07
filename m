Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE0851E78C
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385405AbiEGN47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 09:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385316AbiEGN46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 09:56:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F847047;
        Sat,  7 May 2022 06:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F8FBB808D5;
        Sat,  7 May 2022 13:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7928AC385A9;
        Sat,  7 May 2022 13:53:07 +0000 (UTC)
Date:   Sat, 7 May 2022 09:53:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, x86@kernel.org
Subject: Re: : [PATCH] ftrace/x86: Add FTRACE_MCOUNT_MAX_OFFSET to avoid
 adding weak functions
Message-ID: <20220507095304.0688200b@rorschach.local.home>
In-Reply-To: <YnV5NQ6lMwFY05nf@hirez.programming.kicks-ass.net>
References: <20220503150410.2d9e88aa@rorschach.local.home>
        <YnV5NQ6lMwFY05nf@hirez.programming.kicks-ass.net>
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

On Fri, 6 May 2022 21:38:29 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> You forgot about IBT again? __fentry__ no longer lives at +0 on x86
> anymore.

I didn't forget. It was that the kernel I wrote this for didn't have it ;-)

I wasn't sure if it was accepted into mainline yet.

-- Steve
