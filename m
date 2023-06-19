Return-Path: <netdev+bounces-12082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8381A735ECA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 23:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 518881C2085D
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2333413AC2;
	Mon, 19 Jun 2023 21:04:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D5F5234
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 21:04:22 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2559E4E;
	Mon, 19 Jun 2023 14:04:20 -0700 (PDT)
Date: Mon, 19 Jun 2023 23:04:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com
Subject: Re: [PATCH net 02/14] netfilter: nf_tables: fix chain binding
 transaction logic
Message-ID: <ZJDC0QSZpWLY83YQ@calendula>
References: <20230619145805.303940-1-pablo@netfilter.org>
 <20230619145805.303940-3-pablo@netfilter.org>
 <ZJCzcufoMlCGE64U@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZJCzcufoMlCGE64U@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 09:58:42PM +0200, Simon Horman wrote:
> Hi Pablo,
> 
> Maybe something got mixed up here somehow.
> It seems that on x86_64 allmodconfig bind is not defined here.
> 
> gcc says:
> 
>  net/netfilter/nf_tables_api.c: In function 'nft_chain_trans_bind':
>  net/netfilter/nf_tables_api.c:214:63: error: 'bind' undeclared (first use in this function)
>    214 |                                 nft_trans_rule_bound(trans) = bind;
>        |                                                               ^~~~
>  net/netfilter/nf_tables_api.c:214:63: note: each undeclared identifier is reported only once for each function it appears in

Thanks, I will fix and revamp.

