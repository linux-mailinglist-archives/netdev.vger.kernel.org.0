Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CB6E875D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjDTBUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjDTBUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A508C4C1B
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3243864240
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E2A7C4339B;
        Thu, 20 Apr 2023 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953619;
        bh=cUhuCvPhroNyQnQ2OJdCz6xKlSKs6UytLRLgLLlH2MA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ejoz/bo4tzp2q6HsLJ/3nZjxPYk6JeTG+CRDmouX24R1hw2k1xfyu4Fithv2q3Nb8
         CNZ6Sp4db76biMX7G+cWApxYzoTHtmD1uJ6FvdCqEEMoh6lloMPlCyXVQu3TFNniwk
         dhn0xETCUaecaX69hHs7/Wpu7BIDZoqgG+6CCHy3MKtkhswLQwjY2hWUyRTBkNiqln
         3JAaXpD46zCv5xotmIRC+E41Vkfhx38qiTUl4FWiso2ILsFjXe8/UsOjv0LZPRR5qW
         psHqsMZW7LF5Qr39qFiLyqzog0MgXbL0Mi42DJOo12dhMloeYFyYRuWeyY7dQf7FP7
         3GrEBWtAopn6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6009BC395EA;
        Thu, 20 Apr 2023 01:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] MAINTAINERS: Resume MPTCP co-maintainer role
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195361938.31134.13530843113629049903.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:20:19 +0000
References: <20230418231318.115331-1-martineau@kernel.org>
In-Reply-To: <20230418231318.115331-1-martineau@kernel.org>
To:     Mat Martineau <martineau@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 16:13:18 -0700 you wrote:
> I'm returning to the MPTCP maintainer role I held for most of the
> subsytem's history. This time I'm using my kernel.org email address.
> 
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Link: https://lore.kernel.org/mptcp/af85e467-8d0a-4eba-b5f8-e2f2c5d24984@tessares.net/
> Signed-off-by: Mat Martineau <martineau@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] MAINTAINERS: Resume MPTCP co-maintainer role
    https://git.kernel.org/netdev/net/c/52b37ae8aa67

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


