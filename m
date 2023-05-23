Return-Path: <netdev+bounces-4597-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76ED370D7CD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 929B72812E5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A37C91C759;
	Tue, 23 May 2023 08:45:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920FC1B91E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:45:31 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 627EE95;
	Tue, 23 May 2023 01:45:30 -0700 (PDT)
Date: Tue, 23 May 2023 10:45:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Andrew Paniakin <apanyaki@amazon.com>
Cc: stable@vger.kernel.org, luizcap@amazon.com, benh@amazon.com,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14] netfilter: nf_tables: fix register ordering
Message-ID: <ZGx9JsCjvoDNRTBy@calendula>
References: <20230523025941.1695616-1-apanyaki@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230523025941.1695616-1-apanyaki@amazon.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 07:59:41PM -0700, Andrew Paniakin wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> commit d209df3e7f7002d9099fdb0f6df0f972b4386a63 upstream
> 
> [ We hit the trace described in commit message with the
> kselftest/nft_trans_stress.sh. This patch diverges from the upstream one
> since kernel 4.14 does not have following symbols:
> nft_chain_filter_init, nf_tables_flowtable_notifier ]
> 
> We must register nfnetlink ops last, as that exposes nf_tables to
> userspace.  Without this, we could theoretically get nfnetlink request
> before net->nft state has been initialized.

I have to send pending batch of updates for -stable 4.14.

I take this patch and I will pass it on -stable maintainers.

Thanks.

