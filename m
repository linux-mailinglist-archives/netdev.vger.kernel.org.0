Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D494ED140
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 03:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352283AbiCaBQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 21:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352356AbiCaBOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 21:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E843673FA;
        Wed, 30 Mar 2022 18:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F436191A;
        Thu, 31 Mar 2022 01:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9663FC340EC;
        Thu, 31 Mar 2022 01:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648689164;
        bh=FEGbUV3EOpeIGd1b/UaMSnTOcwrajYzV6G3qVWfa1oo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j31ghZYbSx2F4eZYkkB0PPx4Y6iQfTjFCn+JBMnc0rz1YIPpqBxZPo8D7vAjqV4V3
         Tx4iySCU1kc3wC6cQSrVaMcZAlPWt3z324nyZTpJ61UFyJXpnx4jB4ivmyXewduPde
         lA7Rvc/PQ/uDCa6AmMIsXKx8241bHDjnWGDdsOtL2C8wg8ls+R616yHHXqERNG9gX3
         uuKhv/s8IAdlfIB3Q9Zt7x721xN1fEtLRhQFdfHfk9dVDmQJkRlem3CBH1FSPIWu4I
         25i6tIssrzbbILc7x6unrIAgIMNtDQ7w7i4xBZLKdxC2YV4ko3vISzar3QKrxV+oa1
         d1KB2ZBTFMoGw==
Date:   Thu, 31 Mar 2022 10:12:39 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf 2022-03-29
Message-Id: <20220331101239.09d1959884de5831c16d3d73@kernel.org>
In-Reply-To: <CAADnVQJvzYn3Yw4-exrvUUTFijq0yEJruLkxfzutEgJUVtUj3g@mail.gmail.com>
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
        <20220329184123.59cfad63@kernel.org>
        <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
        <20220330135217.b6d0433831f2b3fa420458ae@kernel.org>
        <20220330181539.c1d289f010cf46e873c16b6c@kernel.org>
        <CAADnVQJvzYn3Yw4-exrvUUTFijq0yEJruLkxfzutEgJUVtUj3g@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 08:09:59 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Mar 30, 2022 at 2:15 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Wed, 30 Mar 2022 13:52:17 +0900
> > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > > On Tue, 29 Mar 2022 18:51:22 -0700
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > >
> > > > On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > >
> > > > > On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> > > > > > Hi David, hi Jakub,
> > > > > >
> > > > > > The following pull-request contains BPF updates for your *net* tree.
> > > > > >
> > > > > > We've added 16 non-merge commits during the last 1 day(s) which contain
> > > > > > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> > > > > >
> > > > > > The main changes are:
> > > > > >
> > > > > > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> > > > > >
> > > > > > 2) ice/xsk fixes, from Maciej and Magnus.
> > > > > >
> > > > > > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.
> > > > >
> > > > > There are some new sparse warnings here that look semi-legit.
> > > > > As in harmless but not erroneous.
> > > >
> > > > Both are new warnings and not due to these patches, right?
> > > >
> > > > > kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
> > > > > kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
> > > > > kernel/trace/rethook.c:68:9:    void ( * )( ... )
> > > > >
> > > > > 66 void rethook_free(struct rethook *rh)
> > > > > 67 {
> > > > > 68         rcu_assign_pointer(rh->handler, NULL);
> > > > > 69
> > > > > 70         call_rcu(&rh->rcu, rethook_free_rcu);
> > > > > 71 }
> > > > >
> > > > > Looks like this should be a WRITE_ONCE() ?
> > > >
> > > > Masami, please take a look.
> > >
> > > Yeah, I think we should make this rcu pointer (and read side must use rcu_dereference())
> > > because this rh->handler becomes the key to disable this rethook.
> > > Let me fix that.
> >
> > Sorry, please ignore this. Since the handler pointed by rh->handler never
> > be removed (unless removed by modules, but this will not happen while
> > the rethook is running), YES, WRITE_ONCE() is enough.
> > Please add below.
> >
> > From 92c9c784458f03900823360981812220ce3c7bf3 Mon Sep 17 00:00:00 2001
> > From: Masami Hiramatsu <mhiramat@kernel.org>
> > Date: Wed, 30 Mar 2022 18:13:42 +0900
> > Subject: [PATCH] rethook: Fix to use WRITE_ONCE() for rethook::handler
> >
> > Since the function pointered by rethook::handler never be removed when
> > the rethook is alive, it doesn't need to use rcu_assign_pointer() to
> > update it. Just use WRITE_ONCE().
> >
> > Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> 
> Could you please send it as a proper patch so it registers in patchwork?

Sure, I sent the patch. BTW, I marked it as "bpf" instead of "bpf-next",
was that OK? (It seems bpf-next was not updated yet)

Thank you,

> 
> > ---
> >  kernel/trace/rethook.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > index ab463a4d2b23..b56833700d23 100644
> > --- a/kernel/trace/rethook.c
> > +++ b/kernel/trace/rethook.c
> > @@ -65,7 +65,7 @@ static void rethook_free_rcu(struct rcu_head *head)
> >   */
> >  void rethook_free(struct rethook *rh)
> >  {
> > -       rcu_assign_pointer(rh->handler, NULL);
> > +       WRITE_ONCE(rh->handler, NULL);
> >
> >         call_rcu(&rh->rcu, rethook_free_rcu);
> >  }
> > --
> > 2.25.1
> > --
> > Masami Hiramatsu <mhiramat@kernel.org>


-- 
Masami Hiramatsu <mhiramat@kernel.org>
