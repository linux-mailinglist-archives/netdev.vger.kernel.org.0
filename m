Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42C15908C8
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiHKWsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 18:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiHKWsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 18:48:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DD79E2DC;
        Thu, 11 Aug 2022 15:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0434B614AB;
        Thu, 11 Aug 2022 22:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 542E6C433D6;
        Thu, 11 Aug 2022 22:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660258128;
        bh=1pbKxaMWI3i6K2IJFCcl+kDDZwuanMs9/yNI66hv0SY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BQyaC1qplmRQ/Z/5N2IW8uwCZx1MNAT7qJ/h/mrojg28ypzHfVvsKcrDYtym0lLSf
         EM7rotINEOuVWT/cW3t4LMrGE/hYaVhxsuF1wVyScTw6RwhSuvqP1NSyN8ldZLoT3p
         9A9n6AtH93WD5+hMt63VkZ4ZCgFztlmGsB/9y4cHGNN7ETbVe2K4ivO3AwUg3X2Jiq
         fyymyWYJGBunJKsV/og2ETWXAltJfUTHss5El8/DwCk5bQOpxcmLdjXdagQeUH52CV
         NKm8RcllZBUGZn6HA+AAu3NAwfisJagLv6d+MaBhRJjfCZebELATDtVugshqgCpAFs
         ncK5+z3FU9D5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3311DC43143;
        Thu, 11 Aug 2022 22:48:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PULL] Networking for 6.0-rc1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166025812820.16047.5574555449105817627.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 22:48:48 +0000
References: <20220811185102.3253045-1-kuba@kernel.org>
In-Reply-To: <20220811185102.3253045-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com
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

On Thu, 11 Aug 2022 11:51:02 -0700 you wrote:
> Hi Linus!
> 
> The following changes since commit f86d1fbbe7858884d6754534a0afbb74fc30bc26:
> 
>   Merge tag 'net-next-6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-08-03 16:29:08 -0700)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [PULL] Networking for 6.0-rc1
    https://git.kernel.org/netdev/net/c/7ebfc85e2cd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


