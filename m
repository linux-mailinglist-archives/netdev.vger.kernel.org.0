Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994F238F437
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhEXUVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:21:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232929AbhEXUVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 16:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F05DD6140A;
        Mon, 24 May 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621887610;
        bh=WD1WlcaqgJEAbb+MY71fSFH8w4+3+qX6vYFPWULCnXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gmmFNLVmdElze/MGsU2lWEhZ6w5/p0+ekXoZUQWrK2SGpPjfGuwq+AIYnxiB2i5XR
         uUs4sKx7CpKKr4AVPd+DE+sirvd8aRCRFC1r0A+VjsBFn6WVVsPZ6+jfDOO3u9b5An
         31k3zAH3dq05kM7lG2vZnfBSVBv7Yu54286ocxA5VAZa5Bduuk0kstMINH2HhrSeG0
         iCSjlz6jC04+Cu3DmhQMdcm/f5HE9qXR9X7+15mbkIAUnTseuwgeZkBglUwbCg8+5V
         pk/b9HH4DErzATGTxZUVePnnU5a8F08a8YKfzMmuG2zkfECJRJbrraVTOTQiw1XWSB
         nal+jmpdvGUHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E102060BCF;
        Mon, 24 May 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_dsmark: fix a NULL deref in qdisc_reset()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162188760991.19394.5741178812670347661.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 20:20:09 +0000
References: <20210523143853.8227-1-ap420073@gmail.com>
In-Reply-To: <20210523143853.8227-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 23 May 2021 14:38:53 +0000 you wrote:
> If Qdisc_ops->init() is failed, Qdisc_ops->reset() would be called.
> When dsmark_init(Qdisc_ops->init()) is failed, it possibly doesn't
> initialize dsmark_qdisc_data->q. But dsmark_reset(Qdisc_ops->reset())
> uses dsmark_qdisc_data->q pointer wihtout any null checking.
> So, panic would occur.
> 
> Test commands:
>     sysctl net.core.default_qdisc=dsmark -w
>     ip link add dummy0 type dummy
>     ip link add vw0 link dummy0 type virt_wifi
>     ip link set vw0 up
> 
> [...]

Here is the summary with links:
  - [net] sch_dsmark: fix a NULL deref in qdisc_reset()
    https://git.kernel.org/netdev/net/c/9b76eade1642

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


