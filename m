Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC674E4A12
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 01:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240912AbiCWA2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 20:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiCWA2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 20:28:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F0313D50;
        Tue, 22 Mar 2022 17:26:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 117CFB81DB1;
        Wed, 23 Mar 2022 00:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD17EC340EC;
        Wed, 23 Mar 2022 00:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647995203;
        bh=EQYVigOO+QWvB6Jgl+iuBU9bbhhWIcUMQXVSrABFaV4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYqxneprPVALdF6Hj+e7ajlc+u+MC6hXJGPQrsGBPaSwYhUx1XoPE5xTUcayJNKv/
         +9Nzwn/WG5Rbrujq4ALrhMNjDexndBmhb1oCBa3X9ZnaFcRsLNWlWkIsfq8q3Dymtg
         rj/1f51FX6ZSNoWdetVMhTYsbs9LXwDum+jK203Q/KFTqBAoUoROAeO9GsvByzFzvk
         VFNQ3Q3NxfjjbZG7u80xKT2xJFAm37WfWJD/ajrOj/ZrKEF1KNT77f8gEgMiNeQjFp
         HWEG31RD6HfsVcQGa3jd9iSmLKh50va0Z1pRXM/ahOM+TyPd2bhgPqcFVsSP9EqpK5
         TaM3XgaVjRQlw==
Date:   Wed, 23 Mar 2022 09:26:38 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: pull-request: bpf-next 2022-03-21 v2
Message-Id: <20220323092638.41efcf935ba7727a4727e86e@kernel.org>
In-Reply-To: <CAADnVQK0OrNHZRj3M8J8cOpyS99guMSc7103Ac+=EUp+8ubgyw@mail.gmail.com>
References: <20220322050159.5507-1-alexei.starovoitov@gmail.com>
        <20220322233223.5e1a3c418f6d60081fae973e@kernel.org>
        <CAADnVQK0OrNHZRj3M8J8cOpyS99guMSc7103Ac+=EUp+8ubgyw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Mar 2022 09:38:07 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Tue, Mar 22, 2022 at 7:32 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > Hi Alexei,
> >
> > So after this is merged, would you have a plan to merge the tip tree
> > which has IBT to the bpf-next? Or should I wait for merging this series
> > or IBT(ENDBR) series in Linus tree?
> >
> > If I add the no ENDBR annotation to the x86 rethook trampoline on this
> > bpf-next branch, it will cause a build error...
> 
> Right now (after arch bits revert) there are no build errors in bpf-next
> and won't be any after the merge into Linus's tree either.
> 
> linux-next is a proxy of what Linus's tree will look like in a few days.
> Please create a single x86 arch patch against linux-next and make sure
> Peter is happy with it.
> We will land that patch at that time.

OK, I'll make that patch on top of linux-next. That will allow us to
build the rethook correctly.

> 
> That patch will be pretty much the same as what you had earlier
> with ENDBR annotation. And maybe regs->ss set which is future proofing
> optional bit and not a functional part of the patch.

Thank you,



-- 
Masami Hiramatsu <mhiramat@kernel.org>
