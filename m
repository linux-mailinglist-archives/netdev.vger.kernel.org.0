Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCC367C4CA
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjAZHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjAZHUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4515E52D;
        Wed, 25 Jan 2023 23:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4180B81CFA;
        Thu, 26 Jan 2023 07:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84373C4339B;
        Thu, 26 Jan 2023 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717617;
        bh=XtWLPD0DoO/ijK5giuEfVejG/nmFUlEaMGVL/auQKdI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PN4fXHmoZX8HytAr+eP5u1oaTHi+PPaWX6p9+kSTeJGsiZAcL95lmjA0aGHprjHiU
         f1u/TdP4V22vm0o/7M1C5mFHa368z8uDIrM7TGhzHzzTsfrBHLmrkGWqgkjokJude1
         rxsJIQaf5IspQOWf9GHh8altTPPSxFB1QrB6UcCZ0+Q3QTtlmMiohPX7RziouZi+rU
         afV0DEJnkyKkf8NvrApPzBASYi+fh/ennxyZz2sIxUG6ltmb+rB9pqV2iorJd85OrA
         LtQODbTXw/Pcb+02dFriZuk8M6OSUHNJ3CcpWpyxNqjmkJH5oLi0erbAjwOuW4HLXq
         L7HFx3iAwGvHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67764E52508;
        Thu, 26 Jan 2023 07:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Kconfig: fix spellos
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167471761741.28103.11342669095502810718.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 07:20:17 +0000
References: <20230124181724.18166-1-rdunlap@infradead.org>
In-Reply-To: <20230124181724.18166-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Jan 2023 10:17:24 -0800 you wrote:
> Fix spelling in net/ Kconfig files.
> (reported by codespell)
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> 
> [...]

Here is the summary with links:
  - [net-next] net: Kconfig: fix spellos
    https://git.kernel.org/netdev/net-next/c/6a7a2c18a9de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


