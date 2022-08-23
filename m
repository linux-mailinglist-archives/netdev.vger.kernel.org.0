Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C79159CE16
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 03:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbiHWBuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 21:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiHWBuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 21:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C092A5A3FC
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 18:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D93D6119C
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C473DC433D6;
        Tue, 23 Aug 2022 01:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661219415;
        bh=vaBJnClqntkhYPVQwmTSqC/IGbdcYlD+bRqt5PzLGXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vPDkN5D+SU7VxmmxixGyh2ckSqABZTSpz+YMoimkhzJcZxAyxmXA2qDI2awrip3bk
         Bno/QRI5GL4n+n7seOiCFXj4Z72bAbKTB7huqnGkUewmsUvPfDGUhSlWH/YIsFRqPu
         Rar2pT02SOReHiA3vC5yz95d52u/c4b3zgptj3e43/KN/2pZnAHRvQ4plaw8k84g6W
         s06t3HDNJ/PzgqlQHl8MuKaHlmgpQh7pvnTw4JCB3mYNA6wD6U9hYGmCy1N+8zp7jq
         G8RiFQUfY020+ktsPubv0CPjGTSrLv3Y7gsyrjOevvUyhN2O8nmkrv85rMiDJ6Xw1u
         U612n6jWsR5VQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A39B7E2A03F;
        Tue, 23 Aug 2022 01:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5 0/3] bonding: 802.3ad: fix no transmission of LACPDUs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166121941566.6989.972005981127087529.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Aug 2022 01:50:15 +0000
References: <cover.1660919940.git.jtoppins@redhat.com>
In-Reply-To: <cover.1660919940.git.jtoppins@redhat.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, jay.vosburgh@canonical.com,
        liuhangbin@gmail.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 Aug 2022 11:15:11 -0400 you wrote:
> Configuring a bond in a specific order can leave the bond in a state
> where it never transmits LACPDUs.
> 
> The first patch adds some kselftest infrastructure and the reproducer
> that demonstrates the problem. The second patch fixes the issue. The
> new third patch makes ad_ticks_per_sec a static const and removes the
> passing of this variable via the stack.
> 
> [...]

Here is the summary with links:
  - [net,v5,1/3] selftests: include bonding tests into the kselftest infra
    https://git.kernel.org/netdev/net/c/c078290a2b76
  - [net,v5,2/3] bonding: 802.3ad: fix no transmission of LACPDUs
    https://git.kernel.org/netdev/net/c/d745b5062ad2
  - [net,v5,3/3] bonding: 3ad: make ad_ticks_per_sec a const
    https://git.kernel.org/netdev/net/c/f2e44dffa97f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


