Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8970E6AF802
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjCGVua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbjCGVuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8C19E325
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 13:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2168B81A64
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22107C433A4;
        Tue,  7 Mar 2023 21:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678225821;
        bh=in8ZLQfps5HXX0X6zBYpKjW8w2RuG2JE1xguvUZWpGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HJZDxzx1gdtB9XhWx7mmtbcvzO6x7seyy+kyryrRwS069xpfGQV6wiH9ZhWtFxc5C
         uKw97puOZc4oic1aFnO/vuLuG6qoUXmgVidwzWgou/saQBglK362l8LTZLBfklaFg7
         IEsyRX0p9I4LaPdFCmYeCuSd5pIbYRYfrhCbJ7JSpkbSWliO0zvzPkQlQ6eXpmdyy4
         I7/VjdCNCNHac5N1+8tNmaqyWcvjXrKOGgxqY7JU5gJ0AiN88P2pFSuI0gLKyWjbaG
         upXnoAeDlOO3YdWjoM8z97meHr2OToUsqV09Hmc6PRyGEIB8zKSazH/H1uLrJb4J1l
         /IsbBwhgXR4rA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01EA6E61B69;
        Tue,  7 Mar 2023 21:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ynl: re-license uniformly under GPL-2.0 OR BSD-3-Clause
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167822582099.6774.17154332629128439562.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 21:50:20 +0000
References: <20230306200457.3903854-1-kuba@kernel.org>
In-Reply-To: <20230306200457.3903854-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, tariqt@nvidia.com, lorenzo@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Mar 2023 12:04:57 -0800 you wrote:
> I was intending to make all the Netlink Spec code BSD-3-Clause
> to ease the adoption but it appears that:
>  - I fumbled the uAPI and used "GPL WITH uAPI note" there
>  - it gives people pause as they expect GPL in the kernel
> As suggested by Chuck re-license under dual. This gives us benefit
> of full BSD freedom while fulfilling the broad "kernel is under GPL"
> expectations.
> 
> [...]

Here is the summary with links:
  - [net] ynl: re-license uniformly under GPL-2.0 OR BSD-3-Clause
    https://git.kernel.org/netdev/net/c/37d9df224d1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


