Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9044CE803
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 02:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiCFBKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 20:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiCFBKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 20:10:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E709735DC3;
        Sat,  5 Mar 2022 17:09:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ECE3B80DF0;
        Sun,  6 Mar 2022 01:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0C2C004E1;
        Sun,  6 Mar 2022 01:09:40 +0000 (UTC)
Date:   Sat, 5 Mar 2022 20:09:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 0/8] bpf: Add kprobe multi link
Message-ID: <20220305200939.2754ba82@yoga.local.home>
In-Reply-To: <CAEf4BzaugZWf6f_0JzA-mqaGfp52tCwEp5dWdhpeVt6GjDLQ3Q@mail.gmail.com>
References: <20220222170600.611515-1-jolsa@kernel.org>
        <CAEf4BzaugZWf6f_0JzA-mqaGfp52tCwEp5dWdhpeVt6GjDLQ3Q@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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

On Fri, 4 Mar 2022 15:10:55 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> Masami, Jiri, Steven, what would be the logistics here? What's the
> plan for getting this upstream? Any idea about timelines? I really
> hope it won't take as long as it took for kretprobe stack trace
> capturing fixes last year to land. Can we take Masami's changes
> through bpf-next tree? If yes, Steven, can you please review and give
> your acks? Thanks for understanding!

Yeah, I'll start looking at it this week. I just started a new job and
that's been taking up a lot of my time and limiting what I can look at
upstream.

-- Steve
