Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826064EBD6C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244690AbiC3JRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243827AbiC3JRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44684252A5;
        Wed, 30 Mar 2022 02:15:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0A47B81B81;
        Wed, 30 Mar 2022 09:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A38DC340EE;
        Wed, 30 Mar 2022 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648631744;
        bh=Mv9Ca0iV69MzP6PWM7uHW2ZsllformFhcdx4Ma6/C0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q4C4jnvcd9mTy4fzyItRHzTmtJjL3ttNp1fxC/K39ClcqCYiodV0Pf1IyPDN5HGGi
         5r1j2qlr8XeSLX4A/5+R3T8CocBU90wddka68CKEcKZTHho2ph97AZZU4hieS4AGaC
         WYPmABhsZDEIBtfogNFNAjF2C0ifFJyYny8DmsT5590NUiwhM5Kr1aTpNVKfC4Bxqh
         svgOJj7xYwpmbhxpa21+MQfGPD9adHa2k/DbJr9PlhFrBtdxMIgmxRmHz4aksu4Fa7
         u8aLGag2bJ+cJ+T6P4tCZB41aHr8aSWAyVCBBatBapfHcIe+vKWX/QmCFLtjojLxB/
         nDvAIAfr8mtHg==
Date:   Wed, 30 Mar 2022 18:15:39 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf 2022-03-29
Message-Id: <20220330181539.c1d289f010cf46e873c16b6c@kernel.org>
In-Reply-To: <20220330135217.b6d0433831f2b3fa420458ae@kernel.org>
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
        <20220329184123.59cfad63@kernel.org>
        <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
        <20220330135217.b6d0433831f2b3fa420458ae@kernel.org>
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

On Wed, 30 Mar 2022 13:52:17 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> On Tue, 29 Mar 2022 18:51:22 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> > > > Hi David, hi Jakub,
> > > >
> > > > The following pull-request contains BPF updates for your *net* tree.
> > > >
> > > > We've added 16 non-merge commits during the last 1 day(s) which contain
> > > > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> > > >
> > > > The main changes are:
> > > >
> > > > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> > > >
> > > > 2) ice/xsk fixes, from Maciej and Magnus.
> > > >
> > > > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.
> > >
> > > There are some new sparse warnings here that look semi-legit.
> > > As in harmless but not erroneous.
> > 
> > Both are new warnings and not due to these patches, right?
> > 
> > > kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
> > > kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
> > > kernel/trace/rethook.c:68:9:    void ( * )( ... )
> > >
> > > 66 void rethook_free(struct rethook *rh)
> > > 67 {
> > > 68         rcu_assign_pointer(rh->handler, NULL);
> > > 69
> > > 70         call_rcu(&rh->rcu, rethook_free_rcu);
> > > 71 }
> > >
> > > Looks like this should be a WRITE_ONCE() ?
> > 
> > Masami, please take a look.
> 
> Yeah, I think we should make this rcu pointer (and read side must use rcu_dereference())
> because this rh->handler becomes the key to disable this rethook.
> Let me fix that.

Sorry, please ignore this. Since the handler pointed by rh->handler never
be removed (unless removed by modules, but this will not happen while
the rethook is running), YES, WRITE_ONCE() is enough.
Please add below.

From 92c9c784458f03900823360981812220ce3c7bf3 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Wed, 30 Mar 2022 18:13:42 +0900
Subject: [PATCH] rethook: Fix to use WRITE_ONCE() for rethook::handler

Since the function pointered by rethook::handler never be removed when
the rethook is alive, it doesn't need to use rcu_assign_pointer() to
update it. Just use WRITE_ONCE().

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/trace/rethook.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
index ab463a4d2b23..b56833700d23 100644
--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -65,7 +65,7 @@ static void rethook_free_rcu(struct rcu_head *head)
  */
 void rethook_free(struct rethook *rh)
 {
-	rcu_assign_pointer(rh->handler, NULL);
+	WRITE_ONCE(rh->handler, NULL);
 
 	call_rcu(&rh->rcu, rethook_free_rcu);
 }
-- 
2.25.1
-- 
Masami Hiramatsu <mhiramat@kernel.org>
