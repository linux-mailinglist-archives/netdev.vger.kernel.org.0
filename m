Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F064D1044
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbiCHGbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiCHGbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:31:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F195C3C73C;
        Mon,  7 Mar 2022 22:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DE5E6159E;
        Tue,  8 Mar 2022 06:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78978C340EC;
        Tue,  8 Mar 2022 06:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646721010;
        bh=oQ18lgNoYFU+P1cuSECSbe2PiBEyVyLpvsuYeCOz6PM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZkPIrJblLZTek7xgTxZOiEoj8198nEYDj/5BIR1L679c1wn2CCwd3UQJbUeOIAYEp
         Zigt0BMDXO9o8eAlqCHGs4ETqTHbDSEziUSAJp8ZLajSkE76FStys7AIJyOpDxHapF
         ozXYweBZTwwjkAjNXuHow8aUfoMy5dWlE86jcIwBaqRYVMFArGHu8U/lU4vVAiVZ9F
         /uLCbqE37hRNpdNVlleJmIV0pLQog6nMtix1ScGrnpxqqMVJJxdW1NdNZfRzbuBetL
         p6lIpO3Xb4e+9xtuUIUGFAb5vDXyDXYRCuqRUzrxwHafCPrQACi0YA1vZfdDNtzir9
         F/EduwZrwCfdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B6F4F0383B;
        Tue,  8 Mar 2022 06:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Remove redundant slash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164672101036.16776.9038565963181298704.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 06:30:10 +0000
References: <20220305161013.361646-1-ytcoode@gmail.com>
In-Reply-To: <20220305161013.361646-1-ytcoode@gmail.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Sun,  6 Mar 2022 00:10:13 +0800 you wrote:
> The trailing slash of LIBBPF_SRCS is redundant, remove it.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  kernel/bpf/preload/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] bpf: Remove redundant slash
    https://git.kernel.org/bpf/bpf-next/c/4989135a8533

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


