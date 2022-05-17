Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6521D52A05A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344263AbiEQLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiEQLZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:25:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532AF4BBB5;
        Tue, 17 May 2022 04:25:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nqvKW-0000ij-Fb; Tue, 17 May 2022 13:25:32 +0200
Date:   Tue, 17 May 2022 13:25:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20220517112532.GE5118@breakpoint.cc>
References: <20220517110303.723a7148@canb.auug.org.au>
 <20220517190332.4506f7e8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517190332.4506f7e8@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
> 
> On Tue, 17 May 2022 11:03:03 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the net-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > net/netfilter/nf_conntrack_netlink.c:1717:12: warning: 'ctnetlink_dump_one_entry' defined but not used [-Wunused-function]
> >  1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
> >       |            ^~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Introduced by commit
> > 
> >   8a75a2c17410 ("netfilter: conntrack: remove unconfirmed list")
> 
> So for my i386 defconfig build this became on error, so I have applied
> the following patch for today.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 17 May 2022 18:58:43 +1000
> Subject: [PATCH] fix up for "netfilter: conntrack: remove unconfirmed list"
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks Stephen.

Acked-by: Florian Westphal <fw@strlen.de>
