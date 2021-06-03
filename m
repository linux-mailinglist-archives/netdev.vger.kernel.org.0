Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3054A39AC2E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFCVBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhFCVBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8FCB86121D;
        Thu,  3 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754004;
        bh=HpPngmB+9glNRVTA0aVyKBaV3ArWxSfk09rbGm2BcFc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UjHwBk1c7e+KhUDfehoiUnh1jaeC6cv3HvmItYKbqbN/2tO+TyGdYMmiLO/734Uv1
         6a0dM40sSpEH9T/azrxM6q1lbIzALX0wWR76nPv7b27jbJLPfKN1xxtgpq8eI3yVr+
         mQOE1lzsuUzZHnepVFXj0civ/5tcplOUZqNQZbAgvRMBAP1o1sGtqK5JtUbSsGctID
         7mp1JoN9WHWAgVW9j2sAODUqiKq7lWg3oatB6VEGD+s1SjizXMRPoNtBddyFnvU2nB
         jkmDtdFhLhZ4deDP/psgREjHsqkDie2G2FJDO0P16FK3A0G7j9lrUSZw3BPOKRsh/M
         2UGYk75NkaWXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D2E5609D9;
        Thu,  3 Jun 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rtnetlink: Fix missing error code in rtnl_bridge_notify()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275400450.32659.9570791901198917491.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:00:04 +0000
References: <1622628904-93532-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1622628904-93532-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  2 Jun 2021 18:15:04 +0800 you wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> Eliminate the follow smatch warning:
> 
> net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error code
> 'err'.
> 
> [...]

Here is the summary with links:
  - rtnetlink: Fix missing error code in rtnl_bridge_notify()
    https://git.kernel.org/netdev/net/c/a8db57c1d285

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


