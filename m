Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD396DEE65
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 10:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjDLIll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 04:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjDLIlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 04:41:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 353FF729B
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 01:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0616A6300E
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 507BEC4339E;
        Wed, 12 Apr 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681288819;
        bh=9mtRnMH/cPaR63ACVct7vrDqK/mRguKEGu8qQgW/M8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SxXVLvMiuwLA2TfPI0YnOtnbZJVoC9h1kyaXPFdRkHCE/5KvVr6cb1Q22OtPiploU
         kGbtAPxPN6Qw/R44AAmuAyQ4PnDVUT60NVc2Wxx0brkkkgMOT38HSd7XgX05Mn69H1
         ybqntJlaQWnzpTDOGhCq8CiPGfsTda8n4aY8SKv7lf4o9r/DW5sIuThAlKXWTXHGsw
         RU/BaBasp6KLuanJ/sbXMzpIF9HsM7hTWT0POUhfs5O3BUv4jM0ACYOzuYIlqcNhAR
         T54l5EOu0ciTmv2JMOVQxlRHjkjM2i1WXDiCaMIp7vDyiqz6B6NhbCm//HHJ+ziGfz
         nsmuvEkQmVKKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23C03E52444;
        Wed, 12 Apr 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ionic: Don't overwrite the cyclecounter bitmask
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168128881913.3903.15231214701104787137.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Apr 2023 08:40:19 +0000
References: <20230407184539.27559-1-brett.creeley@amd.com>
In-Reply-To: <20230407184539.27559-1-brett.creeley@amd.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, shannon.nelson@amd.com, allen.hubbe@amd.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 7 Apr 2023 11:45:39 -0700 you wrote:
> The driver was incorrectly overwriting the cyclecounter bitmask,
> which was truncating it and not aligning to the hardware mask value.
> This isn't causing any issues, but it's wrong. Fix this by not
> constraining the cyclecounter/hardware mask.
> 
> Luckily, this seems to cause no issues, which is why this change
> doesn't have a fixes tag and isn't being sent to net. However, if
> any transformations from time->cycles are needed in the future,
> this change will be needed.
> 
> [...]

Here is the summary with links:
  - [net-next] ionic: Don't overwrite the cyclecounter bitmask
    https://git.kernel.org/netdev/net-next/c/be690daa224e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


