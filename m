Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6092F6B57DC
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 03:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCKCk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 21:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjCKCk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 21:40:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DA812C715;
        Fri, 10 Mar 2023 18:40:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ADDD61D4C;
        Sat, 11 Mar 2023 02:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5C12C433D2;
        Sat, 11 Mar 2023 02:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678502424;
        bh=4QhYvq0T+q5oOUPSI4P29yr6E0P3aejG4x6a8OR9m1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vJ6o2cPOrZ+KKH5rhavfhKJY7aMMwUw3uFpwcAOQRFbhXJXFpGfzCnYTzok2X4coA
         JlrfgOFlfcEEhdT5cYsvDKYMwIPYACHNGJgKwCd6a7yC58w1IfzGBQNOyOSslWXIhB
         a2i6LWydMzY5cBdsTBf3qM8udCbvGSzsL69aAGfCRDXCbhAc5ClT4XJ6/NUP/zYvMr
         26FJDZ3y/uiF1QrKlXq6YfAG2bfYYSxYkPGFgjw4TyySYS5mDPO0cqW3SMa3tXtX6Q
         SO+k8GOGnJa1lRGDLKg0c+SyDpUvCmLB86M22vrCkvGhTeqjItGr43fBaqzArM0WrE
         dyoFRShdMUH8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85777E61B66;
        Sat, 11 Mar 2023 02:40:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-03-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167850242454.6286.7992806628827421905.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 02:40:24 +0000
References: <20230310120159.36518-1-johannes@sipsolutions.net>
In-Reply-To: <20230310120159.36518-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Mar 2023 13:01:58 +0100 you wrote:
> Hi,
> 
> And for wireless-next, here's a bigger pull request, though
> I expect much more iwlwifi work in the near future.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-03-10
    https://git.kernel.org/netdev/net-next/c/2af560e5a5d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


