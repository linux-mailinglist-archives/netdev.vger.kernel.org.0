Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154084E2C08
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350126AbiCUPWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbiCUPWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:22:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A6D25280;
        Mon, 21 Mar 2022 08:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CDA860F8B;
        Mon, 21 Mar 2022 15:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E53E6C340F3;
        Mon, 21 Mar 2022 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647876010;
        bh=2CAHA9p/lUe4Hg4xsMq7t8E74hPfxVHUgBidSh6Ufz8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TYayVpUW+sIGuhmnqmbfNOPtkjUCpzJTiMemmdPkJtQZJQeZ7SMs4/VxgBR+/jMtv
         Y4ttKo298r/gdmFs6n5XmoSLJhMa8qNUBHxiygTkCgo5qE9WiU46Ddm68POcWQlDn8
         7xhiif/PkQldYDjLGMJIvXtQE6LKjng9HADujbLjfCRiSjPTDI9EpMb7VI6wNAwh42
         9tgHQBfk7pECdST/i+6H6vUJIqevFv+rTFMeYXEDlZUOTdNHt3RdfYjJrlS6D9wphw
         l2hci6qrVTfonZnD937rq2BBXQXmxR5oITV1S63NiuP+BRISVz1qFv2OmzOpsNcZTo
         Q1LFEfMj+lndQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7862F03845;
        Mon, 21 Mar 2022 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: bpftool: fix print error when show bpf map
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164787600981.20941.8225798299544558290.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 15:20:09 +0000
References: <20220320060815.7716-1-laoar.shao@gmail.com>
In-Reply-To: <20220320060815.7716-1-laoar.shao@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, joannekoong@fb.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Sun, 20 Mar 2022 06:08:14 +0000 you wrote:
> If there is no btf_id or frozen, it will not show the pids,
> but the pids doesn't depends on any one of them.
> 
> Below is the result after this change,
> $ ./bpftool map show
> 2: lpm_trie  flags 0x1
> 	key 8B  value 8B  max_entries 1  memlock 4096B
> 	pids systemd(1)
> 3: lpm_trie  flags 0x1
> 	key 20B  value 8B  max_entries 1  memlock 4096B
> 	pids systemd(1)
> 
> [...]

Here is the summary with links:
  - bpf: bpftool: fix print error when show bpf map
    https://git.kernel.org/bpf/bpf-next/c/1824d8ea75f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


