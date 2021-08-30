Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8689C3FB498
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhH3LbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 07:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236438AbhH3LbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 07:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 015ED61153;
        Mon, 30 Aug 2021 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630323007;
        bh=TsaQJl8TkP79rrhNEFGVTvNok8L1PgiOds4htHDGOxY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dC/Cjr3IJiZOO7uY7bH8tsgfCU2hxTIqOZ7ZSo8oHTJpfHfJthil6le+zmMQULjLx
         XnIpvcdUdD2Vt8TjycQWfRlx2E+oTz5IulsmK3hXdcpXXMZF8547JVpQ7Iyvq/Mz6o
         xScmeN/orotR0IMScjUg+bWMc48UlRN5/MRlgz90gVP0uz7CjAOaiUSYiVNc7oMGh8
         s1RJixT0qs4Yfuhlm0qxArDzjjGYxOhDWUdbNnCVmKhZXVvE3nuzyuc6pM79BKr87y
         5uzLYsM9hPT2cbk9FrblMkaLnCFrmlXZVErVpHAxGlRxQZrt5fPvg7sfV4+bDpdWYX
         C33+THD6sjTMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB2A860A6C;
        Mon, 30 Aug 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] fix array-index-out-of-bounds in taprio_change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163032300695.3135.11373235819151215482.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 11:30:06 +0000
References: <1630295221-9859-1-git-send-email-tcs_kernel@tencent.com>
In-Reply-To: <1630295221-9859-1-git-send-email-tcs_kernel@tencent.com>
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tcs_kernel@tencent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 11:47:01 +0800 you wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> syzbot report an array-index-out-of-bounds in taprio_change
> index 16 is out of range for type '__u16 [16]'
> that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
> the return value of netdev_set_num_tc.
> 
> [...]

Here is the summary with links:
  - [V2] fix array-index-out-of-bounds in taprio_change
    https://git.kernel.org/netdev/net-next/c/efe487fce306

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


