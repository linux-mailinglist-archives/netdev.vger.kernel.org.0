Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764B3605E5A
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 13:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiJTLAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 07:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiJTLAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 07:00:01 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8026351439
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:59:58 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id AAB5D1C95E;
        Thu, 20 Oct 2022 13:59:56 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 963171C959;
        Thu, 20 Oct 2022 13:59:55 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id C4C513C043D;
        Thu, 20 Oct 2022 13:59:52 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 29KAxo78046839;
        Thu, 20 Oct 2022 13:59:52 +0300
Date:   Thu, 20 Oct 2022 13:59:50 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] ip: rework the fix for dflt addr selection for
 connected nexthop"
In-Reply-To: <20221020100952.8748-1-nicolas.dichtel@6wind.com>
Message-ID: <53f1178f-9a6-5f73-5ea8-bdae73d7b26b@ssi.bg>
References: <20221020100952.8748-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Thu, 20 Oct 2022, Nicolas Dichtel wrote:

> This series reworks the fix that is reverted in the second commit.
> As Julian explained, nhc_scope is related to nhc_gw, it's not the scope of
> the route.
> 
>  net/ipv4/fib_frontend.c  | 4 ++--
>  net/ipv4/fib_semantics.c | 2 +-
>  net/ipv4/nexthop.c       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> Comments are welcome.

	Patchset looks good to me, thanks!

Reviewed-by: Julian Anastasov <ja@ssi.bg>

Regards

--
Julian Anastasov <ja@ssi.bg>

