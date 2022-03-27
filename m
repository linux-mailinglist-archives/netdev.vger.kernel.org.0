Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BF94E84C1
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 01:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiC0ALu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 20:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiC0ALs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 20:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1C42656A
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 17:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 225E860ECD
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 00:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B271C340F3;
        Sun, 27 Mar 2022 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648339810;
        bh=MGxeuBWeKsD33lWeY9jt+3JBeWE/HW3F1PJXyPaXT9g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ipcZb6I/qQQqzcdTCc6n7CwPSv7LZdx01cLxgCt8s96Ux0xBpg21IJoXfY/9yREo/
         ehNuGNVeZ31xJkr4pTpuaAm81yQEa4uZqFUj05B6TQ82+GuOK3VAws0yBKqP83XiOC
         l7Bhg46mIYXFm50rI1hTTThrFLcNrkEdqmNFs6G6XaUuJAEXIWkWekBbQ9AvfS1wzW
         /m443L9iSNt0HcCljLd+z3jHZcLTCum69z3jHQEE7mQi/zXzeTLGujM+ZqunG8sBDH
         uYN5DFHrxlz1HGmv+6hl4NbvNAZtZ1Pujo9VF+bF6ni8thX5P0PlsouWlv00imUbuR
         w34lMEADg1M/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A14CEAC081;
        Sun, 27 Mar 2022 00:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_ct: fix ref leak when switching zones
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164833981043.9928.13914220992098033920.git-patchwork-notify@kernel.org>
Date:   Sun, 27 Mar 2022 00:10:10 +0000
References: <9925b0003629c6f3421f6b36819fa1edabd44f4f.1648149598.git.marcelo.leitner@gmail.com>
In-Reply-To: <9925b0003629c6f3421f6b36819fa1edabd44f4f.1648149598.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, fw@strlen.de, paulb@nvidia.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 24 Mar 2022 16:22:10 -0300 you wrote:
> When switching zones or network namespaces without doing a ct clear in
> between, it is now leaking a reference to the old ct entry. That's
> because tcf_ct_skb_nfct_cached() returns false and
> tcf_ct_flow_table_lookup() may simply overwrite it.
> 
> The fix is to, as the ct entry is not reusable, free it already at
> tcf_ct_skb_nfct_cached().
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_ct: fix ref leak when switching zones
    https://git.kernel.org/netdev/net/c/bcb74e132a76

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


