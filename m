Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321BF6E4EAE
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDQQ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQQ7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:59:46 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2AEB4;
        Mon, 17 Apr 2023 09:59:45 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id CEC681B28D;
        Mon, 17 Apr 2023 19:59:41 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id B557B1B257;
        Mon, 17 Apr 2023 19:59:41 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id A51913C043A;
        Mon, 17 Apr 2023 19:59:36 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 33HGxZgk120021;
        Mon, 17 Apr 2023 19:59:35 +0300
Date:   Mon, 17 Apr 2023 19:59:35 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@kernel.org>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
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
In-Reply-To: <20230409-ipvs-cleanup-v3-0-5149ea34b0b9@kernel.org>
Message-ID: <a873ffc-bcdf-934f-127a-80188e8b33e6@ssi.bg>
References: <20230409-ipvs-cleanup-v3-0-5149ea34b0b9@kernel.org>
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


	Hello,

On Mon, 17 Apr 2023, Simon Horman wrote:

> Hi Julian,
> 
> this series aims to clean up IPVS in several ways without
> implementing any functional changes, aside from removing
> some debugging output.
> 
> Patch 1/4: Update width of source for ip_vs_sync_conn_options
>            The operation is safe, use an annotation to describe it properly.
> 
> Patch 2/4: Consistently use array_size() in ip_vs_conn_init()
>            It seems better to use helpers consistently.
> 
> Patch 3/4: Remove {Enter,Leave}Function
>            These seem to be well past their use-by date.
> 
> Patch 4/4: Correct spelling in comments
> 	   I can't spell. But codespell helps me these days.
> 
> All changes: compile tested only!
> 
> ---
> Changes in v3:
> - Patch 2/4: Correct division by 1024.
>              It was applied to the wrong variable in v2.
> - Add Horatiu's Reviewed-by tag.
> 
> Changes in v2:
> - Patch 1/4: Correct spelling of 'conn' in subject.
> - Patch 2/4: Restore division by 1024. It was lost on v1.
> 
> ---
> Simon Horman (4):
>       ipvs: Update width of source for ip_vs_sync_conn_options
>       ipvs: Consistently use array_size() in ip_vs_conn_init()
>       ipvs: Remove {Enter,Leave}Function
>       ipvs: Correct spelling in comments

	The patchset looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

>  include/net/ip_vs.h             | 32 +++++----------------
>  net/netfilter/ipvs/ip_vs_conn.c | 12 ++++----
>  net/netfilter/ipvs/ip_vs_core.c |  8 ------
>  net/netfilter/ipvs/ip_vs_ctl.c  | 26 +----------------
>  net/netfilter/ipvs/ip_vs_sync.c |  7 +----
>  net/netfilter/ipvs/ip_vs_xmit.c | 62 ++++++-----------------------------------
>  6 files changed, 23 insertions(+), 124 deletions(-)
> 
> base-commit: 99676a5766412f3936c55b9d18565d248e5463ee

Regards

--
Julian Anastasov <ja@ssi.bg>

