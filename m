Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FDA4EB9C4
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242653AbiC3EyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbiC3EyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EAD2611F;
        Tue, 29 Mar 2022 21:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B373EB81AD6;
        Wed, 30 Mar 2022 04:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B26C340F0;
        Wed, 30 Mar 2022 04:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648615942;
        bh=Wmf2JqqUAbQnmapSolDt4dEa/qXQcPvYulQCKcKukOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gQoxN+GFfSmm3IQqm9ovjeluzZGbILS4q5UUt7bqfGyydSsemBtcfQluf2a/h7tj5
         9K45R9Km0B4Vr3eDPBBLo56uibNMdlTjx6AxJUkeMwJ+OvQ9xkqSzlT0mHqV3TNmbp
         jnCEj++LgaAQl3e+2IvUvfi4I1xjZu09jFmI88QavTnfKwpgaXthgpLRvWJqR1Xp7q
         E1JOuefndgHGsphvAwT3IfPjATdTRGHQTyqEmxGhKuVYL4O5YzfsdacdMyqZgtmrTE
         ZssiFGOkX0U5UzHE8xboidfIuAtO8Pz0Q/bXakhoVu9TnmdT75sd5L794pmPucInGv
         3NGLASNpLNxdA==
Date:   Wed, 30 Mar 2022 13:52:17 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf 2022-03-29
Message-Id: <20220330135217.b6d0433831f2b3fa420458ae@kernel.org>
In-Reply-To: <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com>
        <20220329184123.59cfad63@kernel.org>
        <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
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

On Tue, 29 Mar 2022 18:51:22 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> > > Hi David, hi Jakub,
> > >
> > > The following pull-request contains BPF updates for your *net* tree.
> > >
> > > We've added 16 non-merge commits during the last 1 day(s) which contain
> > > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> > >
> > > The main changes are:
> > >
> > > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> > >
> > > 2) ice/xsk fixes, from Maciej and Magnus.
> > >
> > > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.
> >
> > There are some new sparse warnings here that look semi-legit.
> > As in harmless but not erroneous.
> 
> Both are new warnings and not due to these patches, right?
> 
> > kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
> > kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
> > kernel/trace/rethook.c:68:9:    void ( * )( ... )
> >
> > 66 void rethook_free(struct rethook *rh)
> > 67 {
> > 68         rcu_assign_pointer(rh->handler, NULL);
> > 69
> > 70         call_rcu(&rh->rcu, rethook_free_rcu);
> > 71 }
> >
> > Looks like this should be a WRITE_ONCE() ?
> 
> Masami, please take a look.

Yeah, I think we should make this rcu pointer (and read side must use rcu_dereference())
because this rh->handler becomes the key to disable this rethook.
Let me fix that.

Thanks,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
