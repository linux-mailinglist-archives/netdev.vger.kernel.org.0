Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9353D4EB43E
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 21:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241030AbiC2TtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 15:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiC2TtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 15:49:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443F2B8237;
        Tue, 29 Mar 2022 12:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D38F76168D;
        Tue, 29 Mar 2022 19:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38971C340ED;
        Tue, 29 Mar 2022 19:47:28 +0000 (UTC)
Date:   Tue, 29 Mar 2022 15:47:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] tracing/user_events: Remove eBPF interfaces
Message-ID: <20220329154726.30c187df@gandalf.local.home>
In-Reply-To: <CAADnVQKG0LxsUMFGsFSEA4AqpSa8Kqg5HpUfKzPo9Ze463UDgw@mail.gmail.com>
References: <20220329173051.10087-1-beaub@linux.microsoft.com>
        <CAADnVQKG0LxsUMFGsFSEA4AqpSa8Kqg5HpUfKzPo9Ze463UDgw@mail.gmail.com>
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

On Tue, 29 Mar 2022 11:19:05 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Tue, Mar 29, 2022 at 10:30 AM Beau Belgrave
> <beaub@linux.microsoft.com> wrote:
> >
> > Remove eBPF interfaces within user_events to ensure they are fully
> > reviewed.
> >
> > Link: https://lore.kernel.org/all/20220329165718.GA10381@kbox/
> >
> > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>  
> 
> Thanks for the quick revert.
> 
> Steven,
> 
> since you've applied the initial set please take this one and
> send pull req to Linus asap.
> 

Relax Alexei,

I'll send it to Linus after it goes through my testing process with all my
other patches in queue. An ABI is only defined by the main release "5.18"
and not the rc releases (like 5.18-rc1). But it will definitely be gone
before rc2.

-- Steve

