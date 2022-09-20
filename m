Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D065BEB3B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 18:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiITQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 12:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiITQkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 12:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1623B31DCE;
        Tue, 20 Sep 2022 09:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8666B82B04;
        Tue, 20 Sep 2022 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61268C433C1;
        Tue, 20 Sep 2022 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663692015;
        bh=2SAKmcvD2cv6AyD8mCteq4UipyHj7aUapWRkVB2CsTk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XD70qGcHq7fx5fDfkvf/lfr/BKLuXhyeyPPyyPl2nmlkwwy+zb7SVbIvltTmG9uPR
         N2C6gz3HkxKdhU4YnzA/QGGfQdqQTq+FC6SEcKwQBa3s5syS6rzkneRJsFSnTkpY+b
         QiaM0zgjNGRQV6SFFxGeyCt0HMeOEIPK60XEgcocQFLi0IjSQUzf3u6LiPECnL8pm3
         2GQKShXHIqRAp5DFLwTs8x0ZKqQ5R02UD4YW2XqR7vnXQv7znx2fQCx74mQycBzeJX
         Rab+qpE1js6fnok0EWyAQzWDvjmFXcBCDVFK2yTsy+X3u/oHQWD4bZF9euyZlkMRMO
         NccVuby5ggDQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40C2BE21EE1;
        Tue, 20 Sep 2022 16:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] headers: Remove some left-over license text
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166369201525.9874.10555683654198133861.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 16:40:15 +0000
References: <0e5ff727626b748238f4b78932f81572143d8f0b.1662896317.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <0e5ff727626b748238f4b78932f81572143d8f0b.1662896317.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jchapman@katalix.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
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

On Sun, 11 Sep 2022 13:39:01 +0200 you wrote:
> Remove a left-over from commit 2874c5fd2842 ("treewide: Replace GPLv2
> boilerplate/reference with SPDX - rule 152")
> 
> There is no need for an empty "License:".
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - headers: Remove some left-over license text
    https://git.kernel.org/netdev/net-next/c/17df341d3526

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


