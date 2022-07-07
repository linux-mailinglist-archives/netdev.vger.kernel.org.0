Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3548456AB25
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiGGS7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 14:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiGGS7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:59:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239F027FE0;
        Thu,  7 Jul 2022 11:59:31 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1o9Wid-00047U-6c; Thu, 07 Jul 2022 20:59:19 +0200
Date:   Thu, 7 Jul 2022 20:59:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Will Deacon <will@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        regressions@lists.linux.dev, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>
Subject: Re: [PATCH nf v3] netfilter: conntrack: fix crash due to confirmed
 bit load reordering
Message-ID: <20220707185919.GA14663@breakpoint.cc>
References: <20220706124007.GB7996@breakpoint.cc>
 <20220706145004.22355-1-fw@strlen.de>
 <20220707081949.GA4057@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707081949.GA4057@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will Deacon <will@kernel.org> wrote:
> On Wed, Jul 06, 2022 at 04:50:04PM +0200, Florian Westphal wrote:
> >  net/netfilter/nf_conntrack_core.c       | 22 ++++++++++++++++++++++
> >  net/netfilter/nf_conntrack_netlink.c    |  1 +
> >  net/netfilter/nf_conntrack_standalone.c |  3 +++
> >  3 files changed, 26 insertions(+)
> 
> Acked-by: Will Deacon <will@kernel.org>

Thanks, I pushed this patch to nf.git.
