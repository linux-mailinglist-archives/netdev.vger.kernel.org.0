Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534BC6874EF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjBBFKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjBBFKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:10:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367666DFD2
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 21:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5DC619FF
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18450C433D2;
        Thu,  2 Feb 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675314619;
        bh=M68VXRe7AfZvAiem/CKRDCWOv18O0NG510TyPklGxDU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S38KXkc4W+BjNF5G+7c9bxcvSbIDVV66iqF1x2Y5kl1WQLQVqv0TgwcX5Y9auPl8k
         /M8Ww3uB7XqBUo+cBlBb39wHumqclVLENUHqRx43TaFQ6hITDEyxGLI43xUwEZW6uY
         v97XWvYxhKKACnpJ5JFE3RzpqUwg/Qlq8Zt6kUWPNlDbxu4OpL8GcQi1DAIxciH9jN
         fe0z43fccRAfMWKBYYOjJtai6Pq5QWkszqHTHT4/lbJ/ZmL5gka0g2C1EQJ20NFDvx
         AUZDufJXkFjRAgkcBdDzw4PF2FFHrzgXKsn1HDPxf9tpcRCZMRzuw27yV22/Nf5qEG
         FIOW3dPyD2lug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E63FAE5250B;
        Thu,  2 Feb 2023 05:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] neighbor: fix proxy_delay usage when it is zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531461893.3090.6533134521882441665.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 05:10:18 +0000
References: <20230130171428.367111-1-haleyb.dev@gmail.com>
In-Reply-To: <20230130171428.367111-1-haleyb.dev@gmail.com>
To:     Brian Haley <haleyb.dev@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
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

On Mon, 30 Jan 2023 12:14:28 -0500 you wrote:
> When set to zero, the neighbor sysctl proxy_delay value
> does not cause an immediate reply for ARP/ND requests
> as expected, it instead causes a random delay between
> [0, U32_MAX). Looking at this comment from
> __get_random_u32_below() explains the reason:
> 
> /*
>  * This function is technically undefined for ceil == 0, and in fact
>  * for the non-underscored constant version in the header, we build bug
>  * on that. But for the non-constant case, it's convenient to have that
>  * evaluate to being a straight call to get_random_u32(), so that
>  * get_random_u32_inclusive() can work over its whole range without
>  * undefined behavior.
>  */
> 
> [...]

Here is the summary with links:
  - [net-next,v3] neighbor: fix proxy_delay usage when it is zero
    https://git.kernel.org/netdev/net-next/c/62e395f82d04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


