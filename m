Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D806EB597
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjDUXNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjDUXNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:13:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD67626A1;
        Fri, 21 Apr 2023 16:13:19 -0700 (PDT)
Date:   Sat, 22 Apr 2023 01:13:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH nf-next v3 0/4] ipvs: Cleanups for v6.4
Message-ID: <ZEMYjOlXKd+6zsgw@calendula>
References: <20230409-ipvs-cleanup-v3-0-5149ea34b0b9@kernel.org>
 <a873ffc-bcdf-934f-127a-80188e8b33e6@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a873ffc-bcdf-934f-127a-80188e8b33e6@ssi.bg>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 07:59:35PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Mon, 17 Apr 2023, Simon Horman wrote:
> 
> > Hi Julian,
> > 
> > this series aims to clean up IPVS in several ways without
> > implementing any functional changes, aside from removing
> > some debugging output.
> > 
> > Patch 1/4: Update width of source for ip_vs_sync_conn_options
> >            The operation is safe, use an annotation to describe it properly.
> > 
> > Patch 2/4: Consistently use array_size() in ip_vs_conn_init()
> >            It seems better to use helpers consistently.
> > 
> > Patch 3/4: Remove {Enter,Leave}Function
> >            These seem to be well past their use-by date.
> > 
> > Patch 4/4: Correct spelling in comments
> > 	   I can't spell. But codespell helps me these days.
> > 
> > All changes: compile tested only!
> > 
> > ---
> > Changes in v3:
> > - Patch 2/4: Correct division by 1024.
> >              It was applied to the wrong variable in v2.
> > - Add Horatiu's Reviewed-by tag.
> > 
> > Changes in v2:
> > - Patch 1/4: Correct spelling of 'conn' in subject.
> > - Patch 2/4: Restore division by 1024. It was lost on v1.
> > 
> > ---
> > Simon Horman (4):
> >       ipvs: Update width of source for ip_vs_sync_conn_options
> >       ipvs: Consistently use array_size() in ip_vs_conn_init()
> >       ipvs: Remove {Enter,Leave}Function
> >       ipvs: Correct spelling in comments
> 
> 	The patchset looks good to me, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Applied, sorry Julian, I missed your Acked-by: tag.
