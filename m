Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B17A58F744
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 07:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiHKFaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 01:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiHKFaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 01:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53890324;
        Wed, 10 Aug 2022 22:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 052E2B81141;
        Thu, 11 Aug 2022 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90E97C433C1;
        Thu, 11 Aug 2022 05:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660195816;
        bh=2b9ASGjdN3kjRN0NwUCoj0I7Nfcy0JbSrudg0FiO8/g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qh3XHFVNyh7zMEjpPHyEINDXfcwZSB9OF9UQ6ebQiU+xooJcHZ+Kdralz3MFsjoGZ
         qQN+Y9MfL2IpdleEFzT+Ms9vNw2fT9s9MbpgBVQLQpC9bnrIpyPXszVJZIjyqdEqk/
         0jh4jKi1VlCrFy4QSpt66fWM12q4qE49YOsSKSs63Cq1rXbAlDVNQOJv3rmXrLXvfg
         SSrOOC8AcykEDRGTv3wqeSx7rarfPZwQRaudqkr2wMIXNCQXQYob0y0c35LM4o0EiV
         vqgOWLVfrOnGP6sxhf8l2LsPtAS0eHcCvn2jhZcjEGU0FU73kR1pG3tcE+DUULZNwA
         sTEc9tzkHO/mA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76415C43142;
        Thu, 11 Aug 2022 05:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-08-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166019581648.16509.10719065434953416857.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 05:30:16 +0000
References: <20220810190624.10748-1-daniel@iogearbox.net>
In-Reply-To: <20220810190624.10748-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 10 Aug 2022 21:06:24 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 23 non-merge commits during the last 7 day(s) which contain
> a total of 19 files changed, 424 insertions(+), 35 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-08-10
    https://git.kernel.org/netdev/net/c/fbe8870f72e8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


