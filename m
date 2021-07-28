Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B113D8E07
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhG1MkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235246AbhG1MkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 08:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A2666023D;
        Wed, 28 Jul 2021 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627476005;
        bh=P/patSdPpoSvI2/EXp6K9Arl9hbiwe2ywkXVfdMaMHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CbZ0JbTHv6+O+kHuk7TvqCqDpA58NwhFCu2xxkD0EuXoNuEwdhDagtyZ2nyL1bBO6
         cuyug4nPZZE5ReHMJAHGHQhXPGrsW+6hav1w9La2PHSYzBSGtIWefOGhKdNnc0VxK7
         DJXbFjLQIM2egvVKTH0OsXEIb1TLaOGKMLRygiR+49JNUZOdoXMmQ2vPqf7B2QJ4rz
         JtR6ohVD0N5FtnzZG5qLZZ47Rc+EUo+3BfV1zfO5k5xdMdNwa5neS5tuVkiaWLtIth
         rvvS9/xr9ADjfxjvcHQZ/LytsFHky/SBKW/xnyxLjinNxM+EFwL2+1b/9ORwVlkqoy
         MVyqP6oCvmm4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7CB7B60A6C;
        Wed, 28 Jul 2021 12:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 1/2] net/sched: act_skbmod: Add SKBMOD_F_ECN
 option support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162747600550.31652.10734754907124081471.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 12:40:05 +0000
References: <f5bd3c60662ec0982cccd8951990796b87d1f985.1627434177.git.peilin.ye@bytedance.com>
In-Reply-To: <f5bd3c60662ec0982cccd8951990796b87d1f985.1627434177.git.peilin.ye@bytedance.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cong.wang@bytedance.com,
        peilin.ye@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Jul 2021 18:33:15 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently, when doing rate limiting using the tc-police(8) action, the
> easiest way is to simply drop the packets which exceed or conform the
> configured bandwidth limit.  Add a new option to tc-skbmod(8), so that
> users may use the ECN [1] extension to explicitly inform the receiver
> about the congestion instead of dropping packets "on the floor".
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/2] net/sched: act_skbmod: Add SKBMOD_F_ECN option support
    https://git.kernel.org/netdev/net-next/c/56af5e749f20
  - [RESEND,net-next,2/2] tc-testing: Add control-plane selftest for skbmod SKBMOD_F_ECN option
    https://git.kernel.org/netdev/net-next/c/68f9884837c6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


