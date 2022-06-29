Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437995600FD
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiF2NKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiF2NKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6321B8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 06:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 243EAB82466
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0FF9C341CF;
        Wed, 29 Jun 2022 13:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656508215;
        bh=jh5ASVrRmCVJ3r9xofPxe5m3VxyREPgkEJ/KXRxqVCs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PsVqv80SJKlHz+o9VgEL+/osxai3WJggMKxd4CjdqQjbqiXQn2csIJNLa0nA7UxuW
         Ur2umq+ZZhVfDWy6tatbD/w8IoVce+KOnVFeqCQd3KI98r1qNtwbqf7pXNGSSb/4XR
         SUw2yDLO8Ec+6LVXYa0OYmNAdM4KZ6vvcrczpE1TsmQYk3uNqA/f9r4s0C5Xk2qYZb
         ghpLsF9KCcH+nXpXK9Oh3rvB8fFtmptxT9ULA1WAU6VkS3jz+fQrxOD9Z5xUv/Lz5z
         t470mfQ7fg7WFtHnHtEhNC8gcuGTWCBhy6JQDNvq20VxuXm6dwPfgJMTUrtMiw7ol9
         1XFZTDNDByZ5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD1F4E49F61;
        Wed, 29 Jun 2022 13:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: flower: fix comment typos and formatting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165650821570.20617.8744410468518863649.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Jun 2022 13:10:15 +0000
References: <20220628121802.450999-1-simon.horman@corigine.com>
In-Reply-To: <20220628121802.450999-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        walter.heymans@corigine.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Jun 2022 14:18:02 +0200 you wrote:
> From: Walter Heymans <walter.heymans@corigine.com>
> 
> A number of spelling and language mistakes in the flower section are
> fixed. The spacing between the text inside some comments and the comment
> symbols are also updated for consistency.
> 
> Signed-off-by: Walter Heymans <walter.heymans@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: fix comment typos and formatting
    https://git.kernel.org/netdev/net-next/c/9bacb93bcfb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


