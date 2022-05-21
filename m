Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332A752F7BE
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354389AbiEUCuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354392AbiEUCuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F052116F933
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5510A61EE3
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 02:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2B00C34100;
        Sat, 21 May 2022 02:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653101412;
        bh=qPuxzGGxXmXHtCeVeIW/JQa4U2/WfqJSbk/5EUTduVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M33Q7pKDwJpbXiAmn53OJ1HRA203gOtd6TeuGT+Rk3rp8zd6EQs20wU8pSDj06+SJ
         GeP8t7rryunHkGyQ6cQcRyeZkMTLEQv4WfIc+OrpI9z1/+lf02bly2oo9znpIlCqfM
         bDp14Een7UvIj1zZhwkVnRMAfJEfF2rbKNXnYdjgOT+FsAISk5PFSgxvA7aEit2x/9
         w7b15PfWcqchB1QPKYmW7lqp5TG2QomeRTqHCr2i0dPmA4z0/LD+pgRh8tM2XBfA5A
         LmKqal0e36fnihwHqOd/291mYpKfFRbICTax9FYoNoDK80IK5d2VYAJdtshdfNxYMK
         x9RuuKCrpwmsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 94AB4F03935;
        Sat, 21 May 2022 02:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 resend 0/2] Add a bhash2 table hashed by port +
 address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165310141259.20429.15319889854760330765.git-patchwork-notify@kernel.org>
Date:   Sat, 21 May 2022 02:50:12 +0000
References: <20220520001834.2247810-1-kuba@kernel.org>
In-Reply-To: <20220520001834.2247810-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 19 May 2022 17:18:32 -0700 you wrote:
> Joanne Koong says:
> 
> This patchset proposes adding a bhash2 table that hashes by port and address.
> The motivation behind bhash2 is to expedite bind requests in situations where
> the port has many sockets in its bhash table entry, which makes checking bind
> conflicts costly especially given that we acquire the table entry spinlock
> while doing so, which can cause softirq cpu lockups and can prevent new tcp
> connections.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,resend,1/2] net: Add a second bind table hashed by port and address
    https://git.kernel.org/netdev/net-next/c/d5a42de8bdbe
  - [net-next,v5,resend,2/2] selftests: Add test for timing a bind request to a port with a populated bhash entry
    https://git.kernel.org/netdev/net-next/c/538aaf9b2383

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


