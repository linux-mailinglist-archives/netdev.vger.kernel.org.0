Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A153525757
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358922AbiELVu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358915AbiELVuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E6249F94;
        Thu, 12 May 2022 14:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73894B82B9D;
        Thu, 12 May 2022 21:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04193C34100;
        Thu, 12 May 2022 21:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652392222;
        bh=ukC2TkV3m/5BoYkGkPmQ7P8sXWSu20o32d8ZWw030Rc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sXAzJNnytvKUE4bN5sMjKtNuRFEu/GHcbsWTaSF0PqccQaUcUHtpC/UlCXEDdH+sw
         m3VJkeqM2nQC0W4PU6mcRZfFF/JHDtq+WJm8g594L7ine5WRFK5xbLVBq7bMJYigsi
         DH0YVCpG9LBl9CXkDr7T04YFBYd6g7/Bx3xZ53WNRy+BeRZPBr0WKZ/mgMJVlP3iuC
         oxJe/S6VkFlnTjFvAAZ4CICmUDB8SFIyShONtJU7V+VkVqLKw0J3jDV5W4q7PBugxQ
         +W7IE+OSLvrfFwQssBGHSC66SBCOshvaxbNqnrtRL8dlt/3UH2hayRvVF3rzdILDVd
         zf8nD8gCV/8pg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBCD9F03935;
        Thu, 12 May 2022 21:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.18-rc7
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165239222189.26664.10781901289968383138.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 21:50:21 +0000
References: <20220512183952.3455585-1-kuba@kernel.org>
In-Reply-To: <20220512183952.3455585-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu, 12 May 2022 11:39:52 -0700 you wrote:
> Hi Linus!
> 
> The following changes since commit 68533eb1fb197a413fd8612ebb88e111ade3beac:
> 
>   Merge tag 'net-5.18-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-05-05 09:45:12 -0700)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.18-rc7
    https://git.kernel.org/netdev/net/c/f3f19f939c11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


