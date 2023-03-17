Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514226BE02D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCQEaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjCQEaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5B151C9B
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 21:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE3846217B
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 04:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D96FC433EF;
        Fri, 17 Mar 2023 04:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679027422;
        bh=toUPUpWmBMvAN8gQBRHscAke0+8WnuFlr/2X17iQ+Xk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fNTHdOjP64b8p3+ic9bBEbOIw2p1rpMrdoJC6cGlG4qM6QtsO2XpZFmESlEFW6XIl
         gLm3Jj7ZTTrcaR7k7VaRRiPZo6cA2nBjZEXEJtgyzzdzDmhTI9DqDfe2NVCKLG5NP2
         nf2+OQnQ7ItprmdU9Wwh7DJixIoi1aGJ3LRRYFlf2f8nI1DMWvH1JbOe7+d4WDSQds
         cQv/3FInafDLWocD5xTUXOHo8h2D7H8HLzvZDufPVBSX/+l14DDuy0g5Lgm5Hp3pE2
         1Wz6jn0FY/uHHhtNm6xKoQ3mms4eVq2NikEZZ21eC2v//EMQhkSUtQwMwemXYYPDLA
         nZMuY6gcr0Pcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E00A2E21EE6;
        Fri, 17 Mar 2023 04:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ynl: another license adjustment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167902742191.2591.16100149181556138691.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 04:30:21 +0000
References: <20230315230351.478320-1-kuba@kernel.org>
In-Reply-To: <20230315230351.478320-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, chuck.lever@oracle.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 16:03:48 -0700 you wrote:
> Hopefully the last adjustment to the licensing of the specs.
> I'm still the author so should be fine to do this.
> 
> Jakub Kicinski (3):
>   tools: ynl: make definitions optional again
>   ynl: broaden the license even more
>   ynl: make the tooling check the license
> 
> [...]

Here is the summary with links:
  - [net,1/3] tools: ynl: make definitions optional again
    https://git.kernel.org/netdev/net/c/054abb515f34
  - [net,2/3] ynl: broaden the license even more
    https://git.kernel.org/netdev/net/c/4e16b6a748df
  - [net,3/3] ynl: make the tooling check the license
    https://git.kernel.org/netdev/net/c/cfab77c0b545

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


