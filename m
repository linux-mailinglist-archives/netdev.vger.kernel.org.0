Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45C559622E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbiHPSNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236996AbiHPSNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:13:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5713196;
        Tue, 16 Aug 2022 11:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA9560F0E;
        Tue, 16 Aug 2022 18:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38308C433D6;
        Tue, 16 Aug 2022 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660673586;
        bh=XbAc7JtDFaqil7L7oXl65af6y1FHgq7Wjx4yuQUnwHM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KtZ0iolpEQnjcW68XqPt21LF5emDFaAIJyZfIQlqnA47PPWa5U4Pezhwfv6A08k2p
         AnlnoTD86/pPVn9O+e3A5c/++uolriqnOBXLY3qb9H4y1TMmSSdEVFiaGRoa4mKTqU
         TFuAqsxIGOSBuYmDw9OEoFokpD6tuWjN+WjGBDKGr3fHLOVDXYzLeCjvZAVi5KOgG7
         uDOXeOzW2URSliuUpFTnvlf+7ANCFNnkWU5YN0f8dfLBoAZY74CUn948aaIvrs7n/w
         k78khjKE2A7kohMdmMX1A2+w3j/YPpN2mAsu/cc3fA5JXTmcyDLKrETN7DKtghhbVY
         RAUXLpB0eooJA==
Date:   Tue, 16 Aug 2022 11:13:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next,0/3] cleanup of qdisc offload function
Message-ID: <20220816111305.4851a510@kernel.org>
In-Reply-To: <694f07e3-d5ad-1bc5-1cdb-ae814b1a12f7@huawei.com>
References: <20220816020423.323820-1-shaozhengchao@huawei.com>
        <20220815201038.4321b77e@kernel.org>
        <694f07e3-d5ad-1bc5-1cdb-ae814b1a12f7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 11:32:03 +0800 shaozhengchao wrote:
> On 2022/8/16 11:10, Jakub Kicinski wrote:
> > On Tue, 16 Aug 2022 10:04:20 +0800 Zhengchao Shao wrote:  
> >> Some qdiscs don't care return value of qdisc offload function, so make
> >> function void.  
> > 
> > How many of these patches do you have? Is there a goal you're working
> > towards? I don't think the pure return value removals are worth the
> > noise. They don't even save LoC:
> > 
> >   3 files changed, 9 insertions(+), 9 deletions(-)  
>
> 	Thank you for your reply. Recently I've been studying the kernel code 
> related to qdisc, and my goal is to understand how qdisc works. If the 
> code can be optimized, I do what I can to modify the optimization. Is it 
> more appropriate to add warning to the offload return value? I look 
> forward to your reply. Thank you.

Understood. Please stop sending the cleanups removing return values
unless the patches materially improve the code.
