Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7923DFDAE
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhHDJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235532AbhHDJKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 71A3260F14;
        Wed,  4 Aug 2021 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628068205;
        bh=wU1sePW5LQXTiqR5t/F90MthP19CVS/q0HOaY27mMJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RrFqIriGRFPCHujc9wbcKGJVV+vHRSxljufZS9B/Q/N4M33MwyBVf6vxKzOa66Rju
         juE3Q+o45Z0YjvNE0zHntBiBAP27geTMpSOFBS4/7giVBUVlSX8qf6wlRz2rCtYIgR
         j4iRwXqPpOq2Dtdl7PVFeveNB0f7ava3AC7CI8oWY21F77m/v3H4KDEEbUiLZllJTU
         J3ZuXBgfJ5jUbe2iDArN5dE9HbPAEUW8KwjlPWRmuDpaTyv6O3NtxT0takhHawR84S
         Pzh8pAnMp2J0bjeIAY5T9wnBmM9ZSRhRe35MURkMGixnXVyq3lH0N5T7PB4/28VNBY
         iI92mZUi0VDKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6733260A72;
        Wed,  4 Aug 2021 09:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: fix lockdep_set_class() typo error for
 sch->seqlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162806820541.32022.5420198468163406896.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:10:05 +0000
References: <1627988301-55801-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1627988301-55801-1-git-send-email-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, pabeni@redhat.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 3 Aug 2021 18:58:21 +0800 you wrote:
> According to comment in qdisc_alloc(), sch->seqlock's lockdep
> class key should be set to qdisc_tx_busylock, due to possible
> type error, sch->busylock's lockdep class key is set to
> qdisc_tx_busylock, which is duplicated because sch->busylock's
> lockdep class key is already set in qdisc_alloc().
> 
> So fix it by replacing sch->busylock with sch->seqlock.
> 
> [...]

Here is the summary with links:
  - [net] net: sched: fix lockdep_set_class() typo error for sch->seqlock
    https://git.kernel.org/netdev/net/c/06f5553e0f0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


