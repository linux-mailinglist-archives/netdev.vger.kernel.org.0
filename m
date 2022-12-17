Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6EF64F7CB
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 06:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLQFUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 00:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLQFUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 00:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1CE13DF8
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 21:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4719DB81ECC
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1156C433F0;
        Sat, 17 Dec 2022 05:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671254417;
        bh=m28IMzLf4TNwP/2HgZDObrXTReRqSiM/f5ws4ufC1UY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T/yBCGtXNG20Vk/p6T7gEGvpM30c3itvBOL08xrGJ2fvLka4uEJi1Z8LerxC/ItfY
         iY65YDRXLECmxvaJ4zl3L1N8n4jCrv9r52xOh9YOzMjh9aPvs73JDAxW3KeXLNPH/r
         9/FpmO+2lxrbyUFwsg3qcQ79AhQYJZPhIhgZdtXXKiI+srVfW++h67zeG6sb6mMupn
         xV0jWOJ404tFjLFN0S9z49+CLyaqGCMOOw1W+fa97iWHzH6UdsYDc//qRuCgD1ODb3
         0Wez1qPO9Op0gnNc1fRlw9KM3Qu1K6ND/GOTTm5dKv4RhpDe1woEakBkDThbZ0R3Ja
         JGxF752qCZh/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7ABFE451BC;
        Sat, 17 Dec 2022 05:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] devlink: protect devlink dump by the instance lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167125441687.30458.16755819507282755779.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Dec 2022 05:20:16 +0000
References: <20221216044122.1863550-1-kuba@kernel.org>
In-Reply-To: <20221216044122.1863550-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@nvidia.com,
        moshe@mellanox.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Dec 2022 20:41:22 -0800 you wrote:
> Take the instance lock around devlink_nl_fill() when dumping,
> doit takes it already.
> 
> We are only dumping basic info so in the worst case we were risking
> data races around the reload statistics. Also note that the reloads
> themselves had not been under the instance lock until recently, so
> the selection of the Fixes tag is inherently questionable.
> 
> [...]

Here is the summary with links:
  - [net] devlink: protect devlink dump by the instance lock
    https://git.kernel.org/netdev/net/c/214964a13ab5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


