Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12405A1CF5
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243241AbiHYXKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbiHYXKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:10:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6353625597;
        Thu, 25 Aug 2022 16:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA8061D1C;
        Thu, 25 Aug 2022 23:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EB8BC43470;
        Thu, 25 Aug 2022 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661469035;
        bh=Mlo+PySskNd6A4dVvJDLFUqydODhHXxHBJ8wb6MuGHo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q9+2hFHkBxxsmwjFRhkBENtFRn/UNvCG+/pN0jq4Vms26A8xDf60d0MlTtAppMlAg
         7fq4vQJgdFIGQo0sOCjua74wKs7N2cdmeoE4QqJbmsuf0y9FOHlGQGSRKBFt0SwtgN
         uuHtnu4UMMxn/THO70Ashf3lLUKZPJokCUKghPzOy0H6ax75MUzuje6CLpLlw5M6v9
         GJKrTijBj77woCxLEFVer5AJDtwYDLY/o8NslTSyZ7W8CVBQNyWWhrDwmtPKmd5iHV
         N79prtywHa0BSa0APqTbr+n8+YxxbwMyVpLczu+S+Lm5FTuwqiGaTFi4xJB1U8gqJ3
         PHZqmK2IvORNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3182BE2A041;
        Thu, 25 Aug 2022 23:10:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] netdev: Use try_cmpxchg in napi_if_scheduled_mark_missed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166146903519.7419.8348863262097347695.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 23:10:35 +0000
References: <20220822143243.2798-1-ubizjak@gmail.com>
In-Reply-To: <20220822143243.2798-1-ubizjak@gmail.com>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Aug 2022 16:32:43 +0200 you wrote:
> Use try_cmpxchg instead of cmpxchg (*ptr, old, new) == old in
> napi_if_scheduled_mark_missed. x86 CMPXCHG instruction returns
> success in ZF flag, so this change saves a compare after cmpxchg
> (and related move instruction in front of cmpxchg).
> 
> Also, try_cmpxchg implicitly assigns old *ptr value to "old" when cmpxchg
> fails, enabling further code simplifications.
> 
> [...]

Here is the summary with links:
  - netdev: Use try_cmpxchg in napi_if_scheduled_mark_missed
    https://git.kernel.org/netdev/net-next/c/b9030780971b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


