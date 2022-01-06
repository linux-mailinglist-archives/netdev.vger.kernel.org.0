Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE159486671
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbiAFPDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbiAFPDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 10:03:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE4FC061245;
        Thu,  6 Jan 2022 07:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D76E3B8222C;
        Thu,  6 Jan 2022 15:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E932C36AE0;
        Thu,  6 Jan 2022 15:02:55 +0000 (UTC)
Date:   Thu, 6 Jan 2022 10:02:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
Message-ID: <20220106100254.29920bcf@gandalf.local.home>
In-Reply-To: <20220106225943.87701fcc674202dc3e172289@kernel.org>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
        <YdaoTuWjEeT33Zzm@krava>
        <20220106225943.87701fcc674202dc3e172289@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jan 2022 22:59:43 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > at the moment there's not ftrace public interface for the return
> > probe merged in, so to get the kretprobe working I had to use
> > kprobe interface  
> 
> Yeah, I found that too. We have to ask Steve to salvage it ;)

I have one more week of being unemployed (and I'm done with my office
renovation), so perhaps I'll start looking into this.

This was the work to merge function graph tracer with kretprobes, right?

-- Steve
