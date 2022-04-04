Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5853B4F1437
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 14:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiDDMCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 08:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiDDMCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 08:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0820344F3
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 05:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD81960FDF
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A207C340EE;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649073615;
        bh=QHerUjm3wnUHEiXvg2OnbEhg8svWQx385uMCX8JU9vo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L7tWRokw1ekrr9vrGbUq9IKs1Tx1qPoCPuLJPq/FVD889hUFqyn2imRYRVITVWIWq
         22xLm1QF9vS9OgillgIIH443osGDOvOvzHTM33GUYwPdyuR3ro1U/c1j9uheqPTcVc
         1eqRwin9IKsIB97XNocmRdIti2UakxlH5SWTtJEel85xFVghfvILLwLj7CWTAbXhkv
         1fTsAz29NutQmbKh4wNBCFzqT1zoILT9zq/7TZU+WTawZFYYJCedNQkkSmQb73Hyvt
         S3L+g0j6itOJEkBbnbDr4QkwDyw9i4RtmPwu3IPJ6UsiGgcbPd2RRfeqQJsmsHvu7S
         Dan5NFPLTGIzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F04DE85BCB;
        Mon,  4 Apr 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: Do not free an empty page_ring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164907361505.19769.2944239266163176487.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Apr 2022 12:00:15 +0000
References: <164906933121.20253.7433900739619890644.stgit@palantir17.mph.net>
In-Reply-To: <164906933121.20253.7433900739619890644.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        netdev@vger.kernel.org, ap420073@gmail.com, ecree.xilinx@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 04 Apr 2022 11:48:51 +0100 you wrote:
> When the page_ring is not used page_ptr_mask is 0.
> Do not dereference page_ring[0] in this case.
> 
> Fixes: 2768935a4660 ("sfc: reuse pages to avoid DMA mapping/unmapping costs")
> Reported-by: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc: Do not free an empty page_ring
    https://git.kernel.org/netdev/net/c/458f5d92df48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


