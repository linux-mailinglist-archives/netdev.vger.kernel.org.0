Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77DBC50263D
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 09:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351103AbiDOHdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 03:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiDOHdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 03:33:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97773A0BCD;
        Fri, 15 Apr 2022 00:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C7BFB82CEB;
        Fri, 15 Apr 2022 07:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D677AC385A8;
        Fri, 15 Apr 2022 07:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650007837;
        bh=WBMs+muxZwDkmCn+wL3BWVKZrpM/Cohd2nps+QW82CU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m8kdcTA97fUGm7yGxnzaZns4H7MQsdNC8XTkI3IjGgH+QQEBVq9bCjPoKX4o7Fvmt
         +HOqRuA0Ulb7TPi/m5EAKvx6CF5npVA10oymJk5ldIf8hIbxqUHh2UUjPiNpEMSbRn
         Ul85TAKlg2DoCM3htROt+A5sZ137FWwjGKFaLdJWnylSFllVWYW8FHMspDuEpZVSgv
         1AG3VpF7MYbCjzf7V3qJgCOdfTIbIIb2REsIgjjqw0sokcql96n8Q06YJm3vM1s3pe
         uYtPX4Y1vHK1+wbEJkfXJEwdN4LD8Cy4ff8kHLIWqqVkdJs+b1Q+4zv9Gh11ZKVVOp
         si8TzXjzbbT1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3B05E8DD6A;
        Fri, 15 Apr 2022 07:30:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.18-rc3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165000783773.22279.3659841781852879824.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 07:30:37 +0000
References: <20220414102641.19082-1-pabeni@redhat.com>
In-Reply-To: <20220414102641.19082-1-pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu, 14 Apr 2022 12:26:41 +0200 you wrote:
> Hi Linus!
> 
> The following changes since commit 73b193f265096080eac866b9a852627b475384fc:
> 
>   Merge tag 'net-5.18-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-04-07 19:01:47 -1000)
> 
> are available in the Git repository at:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.18-rc3
    https://git.kernel.org/netdev/net/c/d20339fa93e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


