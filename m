Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4194E571B6D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiGLNg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiGLNg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:36:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1B2B6548;
        Tue, 12 Jul 2022 06:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01682B818CF;
        Tue, 12 Jul 2022 13:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C604AC3411C;
        Tue, 12 Jul 2022 13:36:51 +0000 (UTC)
Date:   Tue, 12 Jul 2022 09:36:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 0/5] ftrace: host klp and bpf trampoline
 together
Message-ID: <20220712093650.5520d4a2@gandalf.local.home>
In-Reply-To: <8B0FCB44-6241-4220-A1AE-CF91AAA25777@fb.com>
References: <20220602193706.2607681-1-song@kernel.org>
        <20220711195552.22c3a4be@gandalf.local.home>
        <8B0FCB44-6241-4220-A1AE-CF91AAA25777@fb.com>
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

On Tue, 12 Jul 2022 05:15:26 +0000
Song Liu <songliubraving@fb.com> wrote:

> > On Jul 11, 2022, at 4:55 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > I just realized that none of the live kernel patching folks are Cc'd on
> > this thread. I think they will care much more about this than I do.  
> 
> vger.kernel.org often drops my email when the CC list is too long. So I

Oh, they fixed that. I've had over 20 Cc's and it still works. ;-)

> try to keep the list short. In this case, since we are not changing live
> patch code, and there isn't any negative impact for live patch side, I 
> didn't CC live patch folks. 

It affects them indirectly, and they should be aware of what is happening
underneath.

> 
> I will at least CC live-patching@ in the next version. 

Thanks.

-- Steve
