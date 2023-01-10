Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC50E6637EC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 04:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjAJDuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 22:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjAJDuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 22:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5939111B
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 19:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70C6D614B4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92638C433D2;
        Tue, 10 Jan 2023 03:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673322615;
        bh=J5yhxBRKomta5hxOvyyYgzdxPD94hAg7sj+QWDvlD0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=llo0yyJwjzSJ4fATzatGNKA1AwCYHzjd56oolsEOEYg+LpKvreNlJaDE+GLNwqdfy
         Gvkuhqb3yGQ6ZZBLAZsK963WLLcFLuy6G7jr7b0KMj4GMSmumZZpH/JwRLeY35XS+7
         /YTxq6aYjtbcG+v5DiGG/0ll8Pif0GvPvUQX6n7CeEMmOIEVvdGeb2QlXWdKcXkwxH
         YI5j6Hg653wRj+AG17Sxf4E1inyUGkZVWfOjP31hfwyTubfLQ3+Cg5+7Pg2w5g66QQ
         sAGSWvWbQBJiixuAKSAtZakFXv/7WoHxLNOPKzLCDudfsdjCeU2eA8lz4WsuZf1Qpj
         wjc6kakOuBiRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EEAFE524ED;
        Tue, 10 Jan 2023 03:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: act_mpls: Fix warning during failed attribute
 validation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167332261545.28459.5671168118702472669.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 03:50:15 +0000
References: <20230107171004.608436-1-idosch@nvidia.com>
In-Reply-To: <20230107171004.608436-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, willemb@google.com,
        simon.horman@netronome.com, john.hurley@netronome.com,
        harperchen1110@gmail.com, johannes@sipsolutions.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  7 Jan 2023 19:10:04 +0200 you wrote:
> The 'TCA_MPLS_LABEL' attribute is of 'NLA_U32' type, but has a
> validation type of 'NLA_VALIDATE_FUNCTION'. This is an invalid
> combination according to the comment above 'struct nla_policy':
> 
> "
> Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
>    NLA_BINARY           Validation function called for the attribute.
>    All other            Unused - but note that it's a union
> "
> 
> [...]

Here is the summary with links:
  - [net] net/sched: act_mpls: Fix warning during failed attribute validation
    https://git.kernel.org/netdev/net/c/9e17f99220d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


