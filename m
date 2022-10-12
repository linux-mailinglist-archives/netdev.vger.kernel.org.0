Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA1F5FCE49
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJLWS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 18:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJLWS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 18:18:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB3FA5710;
        Wed, 12 Oct 2022 15:18:54 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oik3l-0005in-4F; Thu, 13 Oct 2022 00:18:41 +0200
Date:   Thu, 13 Oct 2022 00:18:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        bpf@vger.kernel.org, memxor@gmail.com
Subject: Re: [PATCH bpf-next v4 2/3] selftests/bpf: Add connmark read test
Message-ID: <20221012221841.GA11818@breakpoint.cc>
References: <cover.1660254747.git.dxu@dxuuu.xyz>
 <d3bc620a491e4c626c20d80631063922cbe13e2b.1660254747.git.dxu@dxuuu.xyz>
 <43bf4a5f-dac9-4fe9-1eba-9ab9beb650aa@linux.dev>
 <20221012220953.i2xevhu36kxyxscl@k2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012220953.i2xevhu36kxyxscl@k2>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Xu <dxu@dxuuu.xyz> wrote:
> > Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
> >   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> > Invalid argument

Martin,

can you give result of

modinfo xt_CONNMARK
and
modinfo nft_compat?

I suspect your kernel lacks nf_tables support.

> >   iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
> > Invalid argument

Probably a kernel without nftables support?

> So perhaps iptables/nftables suffered a regression somewhere. I'll take
> a closer look tonight / tomorrow morning.

Possible but unlikely, all those tests pass for me.
