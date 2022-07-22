Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B31A57E96C
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 00:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbiGVWAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 18:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiGVWAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 18:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C36E001
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 15:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30F55621D8
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 22:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EA25C341CB;
        Fri, 22 Jul 2022 22:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658527213;
        bh=+A76/NX8IEK0/x+HB22R62Qwpzc70otxI9fHImITa8Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M/g6uI3kFKy3CLPP99RsRulBGCyjp7Ssh5RigxFqMDh2Ax/WD/wzmHrlDXtDeuynl
         CWyfBZptDBdopoQiszje0wTDpHCj7XJ5wKqhlvuBKHwYwAJD4VN7PCF30yeBHsGH9D
         LzUyaHqA8QD5sgBLG7EMUK3lafsdCqWkhyR0gudQLaMmgLIMxxNBgMXjPoaKkb4IZb
         JozXGTCBRKEEBa2GIRkTjDSU9g9cIFect6UXSjef04ZnZ5CNNiUlNJbqZ8ZrQ3GJex
         WJv2wc/Vsh9nrAVMVZTQ1FcllP3B8vaCnBqrV3Yh8sX1YeZTgZIrJfHRYD4QEz1JCv
         AbPbuCGAIPOrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 631E1E451BC;
        Fri, 22 Jul 2022 22:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next] mlxsw: core: Fix use-after-free calling
 devl_unlock() in mlxsw_core_bus_device_unregister()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165852721340.8145.2493127771455482762.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 22:00:13 +0000
References: <20220721142424.3975704-1-jiri@resnulli.us>
In-Reply-To: <20220721142424.3975704-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 21 Jul 2022 16:24:24 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Do devl_unlock() before freeing the devlink in
> mlxsw_core_bus_device_unregister() function.
> 
> Reported-by: Ido Schimmel <idosch@nvidia.com>
> Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: core: Fix use-after-free calling devl_unlock() in mlxsw_core_bus_device_unregister()
    https://git.kernel.org/netdev/net-next/c/1b5995e370e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


