Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C764845E5
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbiADQUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:20:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58138 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiADQUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65918614E6;
        Tue,  4 Jan 2022 16:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9FB8C36AEF;
        Tue,  4 Jan 2022 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641313209;
        bh=FJtuvM8YQnl01zVoAmyXpL2GI3zMzGlsZrtsERlt1tY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TOlk/2RRG1f3/PnNBgW1bztREPtXMenWC2PC3qZIKq5rBZIDZe5I1TVwhFbxLPSSy
         Nlru8k/HCApBxF2n+bBeGOMnfjUgJVc20Hz2YHwMuHn8Jc3G+9UWc1uHV4LCq55/wx
         2qpIUO4BZNotAbJfEaCHO3HDhtrjEET2LBcC24ar3nY01KxCULQfguoAmJoJRopWwB
         6w5ruCyPbq/g/JsRCXJWv7gh+20n8HxIOdqYOHa0UyWXf6ulhQbmXPKDq2wCWq/yd4
         Lfk26BaAKnKE1WPpXV3qXHNMIhJkLA2on2LeBKQjaBkFq7ZkoQMDsAtgoR/RZEeF3p
         h7FlxUGmugMZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA837F79406;
        Tue,  4 Jan 2022 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2022-01-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164131320968.12087.6626970751515749989.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 16:20:09 +0000
References: <20220104144449.64937-1-johannes@sipsolutions.net>
In-Reply-To: <20220104144449.64937-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Jan 2022 15:44:48 +0100 you wrote:
> Hi,
> 
> So I know it's getting late, but two more fixes came to
> me over the holidays/vacations.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2022-01-04
    https://git.kernel.org/netdev/net/c/6f89ecf10af1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


