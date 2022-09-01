Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DFC5A91A6
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbiIAIIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbiIAIIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:08:15 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4611132527;
        Thu,  1 Sep 2022 01:08:08 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 57FCF58728BA0; Thu,  1 Sep 2022 10:08:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5741C60E43199;
        Thu,  1 Sep 2022 10:08:06 +0200 (CEST)
Date:   Thu, 1 Sep 2022 10:08:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
In-Reply-To: <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
Message-ID: <r1o5sp18-5041-o7pq-s37n-r18551r389r9@vanv.qr>
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk> <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk> <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk> <20220831152624.GA15107@breakpoint.cc>
 <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com> <20220831155341.GC15107@breakpoint.cc> <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wednesday 2022-08-31 19:26, Alexei Starovoitov wrote:
>
>Right. xt_bpf was a dead end from the start.
>It's time to deprecate it and remove it.

So does that extend to xt_u32, which is like a subset of BPF?
