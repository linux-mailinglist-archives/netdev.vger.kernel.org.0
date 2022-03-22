Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A574E39D1
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 08:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiCVHq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 03:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiCVHqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 03:46:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E407186F1;
        Tue, 22 Mar 2022 00:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qaqvkPIEgyt9bYHOSerHjfpEOfPizMO2MFToz5Mi7DU=; b=Q+NyGJHmz2fS63DBzjUuvB7W0C
        V0iKXmaBZvvIMLLnMW5FmOqKV5udSYRhgoAgkzoYdUqnAiXbxFaLeVCMELizyRdaY6kPPbHktGcvO
        /63BUXJOKquL6B/uqxGE1iGXB3C4DVc85wgTwQYgjRpr5R9OjwuiXr1reAZ27x4IFnnzr65ysfPaG
        AArwDYfUbxYG239tybEJ3+oAzfc16iUMoTrtQZBaYg/uJpXRLCfIHXPjw0qeRBFaH21LylZ/bntSX
        rwLJTGsu3vhtUy9HpBOe3h0JvxNalj7fZdxK7Ps1NN41mqEJ+lw6Gl5m9fau/HTFs/bH08D5VPk97
        h1el3zeg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nWZA0-00BNaR-7l; Tue, 22 Mar 2022 07:42:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2E9A730007E;
        Tue, 22 Mar 2022 08:42:28 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5DD9B2DBA7883; Tue, 22 Mar 2022 08:42:28 +0100 (CET)
Date:   Tue, 22 Mar 2022 08:42:28 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Mike Rapoport <rppt@kernel.org>,
        linux-toolchains <linux-toolchains@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: build warnings after merge of the tip tree
Message-ID: <Yjl95OMvdCKGvwfT@hirez.programming.kicks-ass.net>
References: <Yjh3xZuuY3QcZ1Bn@hirez.programming.kicks-ass.net>
 <Yjh4xzSWtvR+vqst@hirez.programming.kicks-ass.net>
 <YjiBbF+K4FKZyn6T@hirez.programming.kicks-ass.net>
 <YjiZhRelDJeX4dfR@hirez.programming.kicks-ass.net>
 <YjidpOZZJkF6aBTG@hirez.programming.kicks-ass.net>
 <CAHk-=wigO=68WA8aMZnH9o8qRUJQbNJPERosvW82YuScrUTo7Q@mail.gmail.com>
 <YjirfOJ2HQAnTrU4@hirez.programming.kicks-ass.net>
 <CAHk-=wguO61ACXPSz=hmCxNTzqE=mNr_bWLv6GH5jCVZLBL=qw@mail.gmail.com>
 <20220322090541.7d06c8cb@canb.auug.org.au>
 <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJnZpQjUv-dw7SU-WwTOn_tZ8xmy5ydRn=g_m-9UyS2kw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 03:12:05PM -0700, Alexei Starovoitov wrote:
> 
> That makes little sense. It's not an unusual merge conflict.

It is not only that; it is adding code that with an x86 arch maintainer
hat on I've never seen and don't agree with. Same for arm64 apparently.

