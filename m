Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574424F9F5A
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 23:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbiDHVwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 17:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiDHVwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 17:52:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E40269A41
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B613962090
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12007C385AA;
        Fri,  8 Apr 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649454613;
        bh=6MRcIRBiSxsqNs8u/qV131RFy8n2kQC2K1bhUcXMlBM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kCVjEDyQoy5kJZ5tCtDwUD9UMT86gPQk+PJvZZTgupFWCOG66UavXnDX4mlnll8tq
         l7mN8C0l5WyV5q9T6f1Tmb+NS+0EFm5mLpQHF2mrI/BUTAAX4QxNKFk6aSey56pmop
         UNRufHjvJqsIpWaxqtPlG8TYBkVQQWV3cijG8r5aus6Cyn/l5fY/ACNcWC1XFn0Kb1
         usxJoSFOK48pUn3pgDvUyZJb0nbVRdvcIZIs/Q6hIRMo7as4ITPi4VLBDmsTW9u3gA
         r4+6h05GmZ14cF7Rb1A5R4XbcUeRmlxvJYRlbZXrJodvprA3Q5oyuYiK3VKR6Y8pe+
         gydh8H69fVNkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E020DE85B76;
        Fri,  8 Apr 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: i2c: Fix initialization error flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164945461290.21125.3548250813602076591.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 21:50:12 +0000
References: <20220407070703.2421076-1-idosch@nvidia.com>
In-Reply-To: <20220407070703.2421076-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  7 Apr 2022 10:07:03 +0300 you wrote:
> From: Vadim Pasternak <vadimp@nvidia.com>
> 
> Add mutex_destroy() call in driver initialization error flow.
> 
> Fixes: 6882b0aee180f ("mlxsw: Introduce support for I2C bus")
> Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: i2c: Fix initialization error flow
    https://git.kernel.org/netdev/net/c/d452088cdfd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


