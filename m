Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13FC69417F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjBMJlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjBMJk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:40:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDB93C21
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 501CCB80EFE
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7AB4C4339B;
        Mon, 13 Feb 2023 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676281218;
        bh=r/wjjAb5YcEzkCdAID+P03UbezFEhzjowMJezC1g8Lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VKZNDEGBqSK7rCxri0NTcxP1XOfnzxPOjCMT20wIeiSInlhSMIfTxS6XbMxRgqQmV
         QAWGMHXVVcBZ0a5FkfkpJxaSh7SPhvUpImhoSJjAH0EZH1bWf7/ZSHDfgqz+6UxJ7f
         +R9LUo3DLznJuKjr5zAwhE+jU61UGr2Z2IHpWnxsVMWjc5IcwQE2Kc8FtR69loLPtu
         5rjaRMhbQlOvofLQyj1YtfvA0E0wlKpl4WhwzDqg6RG7uGXOKLsu0Wbtv8xn9d+0Wj
         /Qr9g5Dgns9zhqawvK/FNmfz7HObcnpbOz1u8+X/lX2A9HjEEkhdL58vPQxYeyDmJV
         gYRtrSi5yWqEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C74E3E68D39;
        Mon, 13 Feb 2023 09:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] af_key: Fix heap information leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628121781.7814.7330631698896201442.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 09:40:17 +0000
References: <20230209091648.GA5858@ubuntu>
In-Reply-To: <20230209091648.GA5858@ubuntu>
To:     Hyunwoo Kim <v4bel@theori.io>
Cc:     herbert@gondor.apana.org.au, sd@queasysnail.net,
        steffen.klassert@secunet.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        imv4bel@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 9 Feb 2023 01:16:48 -0800 you wrote:
> Since x->encap of pfkey_msg2xfrm_state() is not
> initialized to 0, kernel heap data can be leaked.
> 
> Fix with kzalloc() to prevent this.
> 
> Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> [...]

Here is the summary with links:
  - [v2] af_key: Fix heap information leak
    https://git.kernel.org/netdev/net/c/2f4796518315

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


