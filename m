Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB8B364DBC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhDSWkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhDSWkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CF1A61363;
        Mon, 19 Apr 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618872009;
        bh=rA9pUrgSE7Q92UmHBzZYNdXXwJPa3DAZd1UGEqPwCA4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d9Kq2iR/vxFu5vqUptT9pvUy6vmyJtSPn09f6plun+PBx+8MATU3P1jM8+YzrUw3U
         C31hTjxTYbco2Cq30zi0R/yjwaBYbwhNOvntLvXNmO6LSPbpTjJeqJkWZ6DPOSha58
         3NG2PKeHGQ/trSFTjjVpmraBHvoMwCDvCbITA51NM/MBdZQ3r6H+TAknDPidfj1D7H
         QEhTxLihCgqvJatYOKNcc0Py9Q1Ifsq4SA9Z5Nlol2qS6+zBXOv1VNvckA5yNDg/pT
         9twdh3fnmn8ZBAU9/kPqGCMvUDx4Fg6eZe98EYZh5Xw/LGlAArg6rWbntJeI2PNdJ3
         RgcTsIX2ZuySQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9005660A0B;
        Mon, 19 Apr 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: sched: tapr: prevent cycle_time == 0 in
 parse_taprio_schedule
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887200958.19818.10568820283791492526.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:40:09 +0000
References: <20210416233046.12399-1-ducheng2@gmail.com>
In-Reply-To: <20210416233046.12399-1-ducheng2@gmail.com>
To:     Du Cheng <ducheng2@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org, eric.dumazet@gmail.com,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 17 Apr 2021 07:30:46 +0800 you wrote:
> There is a reproducible sequence from the userland that will trigger a WARN_ON()
> condition in taprio_get_start_time, which causes kernel to panic if configured
> as "panic_on_warn". Catch this condition in parse_taprio_schedule to
> prevent this condition.
> 
> Reported as bug on syzkaller:
> https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c
> 
> [...]

Here is the summary with links:
  - [v4] net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule
    https://git.kernel.org/netdev/net/c/ed8157f1ebf1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


