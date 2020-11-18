Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BAD2B7383
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgKRBLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:11:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgKRBLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 20:11:05 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB01241A7;
        Wed, 18 Nov 2020 01:11:03 +0000 (UTC)
Date:   Tue, 17 Nov 2020 20:11:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mullins <mmullins@mmlx.us>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracepoint: Do not fail unregistering a probe due to
 memory allocation
Message-ID: <20201117201101.366bee30@oasis.local.home>
In-Reply-To: <1227896553.48834.1605654499161.JavaMail.zimbra@efficios.com>
References: <20201116175107.02db396d@gandalf.local.home>
        <47463878.48157.1605640510560.JavaMail.zimbra@efficios.com>
        <20201117142145.43194f1a@gandalf.local.home>
        <375636043.48251.1605642440621.JavaMail.zimbra@efficios.com>
        <20201117153451.3015c5c9@gandalf.local.home>
        <20201117155851.0c915705@gandalf.local.home>
        <334460618.48609.1605648143566.JavaMail.zimbra@efficios.com>
        <20201117171637.6aeeadd7@gandalf.local.home>
        <1227896553.48834.1605654499161.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 18:08:19 -0500 (EST)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Because of this end-of-loop condition ^
> which is also testing for a NULL func. So if we reach a stub, we end up stopping
> iteration and not firing the following tracepoint probes.

Ah right. OK, since it's looking like we're going to have to modify the
tracepoint macro anyway, I'll just go with the 1UL approach.

-- Steve
