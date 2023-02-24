Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FE6A215D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBXSUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBXSUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:20:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E00688E8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50C16195E
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 18:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3847DC4339C;
        Fri, 24 Feb 2023 18:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677262817;
        bh=G1VxZHzlG5GBCQk1j7GOVxuIX7Pn2r5CS46EJaCtpRA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZkIXYBufiednlG0/txefSOfuehpWEfU98T+bKSSTQF1A+4UqifB3Kb707LuMEM/X/
         yFfIHnGmFAmqMt/WU5yyicfUQ+W1kJrkSdA6wWvQUXMavYByaBT+NTIQUeNOQbTEqP
         rnbr5RFngCOQU77saGqfAA5dLviVlszGGQL5EbvxF8KasKXkTisBfzic0uLkxCJrSY
         XfiX/KFPnUGHWUDaB09rbjoqvchm5BvhCeDjB5eop4V52v4S3Ruhcu9xuFkZjKrng5
         GRoeVe2J6hc2hwcMMPtIxQ3aPL1F9KUukfmfvsxzX38xsBf1TNzrBe4tuTfZ/vy6hK
         SRndj6Ah+ussA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11E91E68D36;
        Fri, 24 Feb 2023 18:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] tc: add missing separator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167726281707.23174.11231039333199498754.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Feb 2023 18:20:17 +0000
References: <20230223101503.52222-1-list@eworm.de>
In-Reply-To: <20230223101503.52222-1-list@eworm.de>
To:     Christian Hesse <list@eworm.de>
Cc:     netdev@vger.kernel.org, mail@eworm.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 23 Feb 2023 11:15:03 +0100 you wrote:
> From: Christian Hesse <mail@eworm.de>
> 
> This is missing a separator, that was removed in commit
> 010a8388aea11e767ba3a2506728b9ad9760df0e. Let's add it back.
> 
> Signed-off-by: Christian Hesse <mail@eworm.de>
> 
> [...]

Here is the summary with links:
  - [1/1] tc: add missing separator
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=4e0e56e0ef05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


