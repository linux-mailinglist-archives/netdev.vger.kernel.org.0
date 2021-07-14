Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B603C937D
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 00:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbhGNWC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 18:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhGNWC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 18:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8975E613BE;
        Wed, 14 Jul 2021 22:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626300004;
        bh=zx5gdlCj1dw+CBckZo5PmnwPWF3Vjc0ow9vWeinMeyk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FRl59+9M6cLRTQi4fXEHKYhmDo8BVdstvBlZjPG88w7fcswbrAFyNhPbi0sGCvSZQ
         AgZvamv8KA4fvBAz1pRqTpIaZhQ6UdM3sNhgf8UuhytDSJQbWb20n7BCCgCMqHXgP6
         T7BRaFZJdOwI2OHDD3zGiDU9fU2T2jvWRzxdwBzIxSrDiEkpTKXUKVMh9DJ27G51z8
         yG3kLhd2Jt2/HWQlbQ24IQp4bN9jOImb3ldyR4ErQI76lPF0fDj6U8vFyF0Ryyg+zi
         FK1TqOiIkkRXTKhoUkSeZ7dtiI8mTFc36x253gKJii8UVsJD61jHWx4djqGUMqInzr
         Ctpoi0OvWg7jA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7AC9F60C29;
        Wed, 14 Jul 2021 22:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] r8152: Fix a couple of PM problems
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162630000449.32220.17532101783175093246.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Jul 2021 22:00:04 +0000
References: <20210714170022.8162-1-tiwai@suse.de>
In-Reply-To: <20210714170022.8162-1-tiwai@suse.de>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        hayeswang@realtek.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Jul 2021 19:00:20 +0200 you wrote:
> Hi,
> 
> it seems that r8152 driver suffers from the deadlock at both runtime
> and system PM.  Formerly, it was seen more often at hibernation
> resume, but now it's triggered more frequently, as reported in SUSE
> Bugzilla:
>   https://bugzilla.suse.com/show_bug.cgi?id=1186194
> 
> [...]

Here is the summary with links:
  - [1/2] r8152: Fix potential PM refcount imbalance
    https://git.kernel.org/netdev/net/c/9c23aa51477a
  - [2/2] r8152: Fix a deadlock by doubly PM resume
    https://git.kernel.org/netdev/net/c/776ac63a986d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


