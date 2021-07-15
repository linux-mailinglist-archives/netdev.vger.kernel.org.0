Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04AC3CA49C
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbhGORnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhGORm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EAB1160FEB;
        Thu, 15 Jul 2021 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626370805;
        bh=P5P4S13o6x1koy2ASgB5ytsOa774SlILd+3hySPp+vU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TviflZjiPXKJy+ofBM3rKttwZ5zEpuudZDfluuAa1Vz8AUTSUjC9WZNW7/Zr3Noji
         +9uGqTyrgfJKK9iXcrxQwbeTtQUwDD2zlhLAInSM/Tnuy3W5aSkbSR6XQOGSvH/TIq
         4xjGSfgui4sBQMTJQIEc6LjD5fFQlmgP3T4gyNfCBMDDYRgCe0X6lFT9NazAY4ppJo
         sInsPxjodonDoZ8f0/qpWTpcLQgbTmUhxpp4hQzCS2M6qeyPtYwmJGgZUh1uicAlkV
         iA7m7lFLNO7vgEP5EeHcKsTLh9e6WFgsyRD/BfEMrWwyDWbGENkJ4zJgGwYbdx2P9f
         hZx1LnwwPzapw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DBD95609CF;
        Thu, 15 Jul 2021 17:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next resend v2] net: use %px to print skb address in
 trace_netif_receive_skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637080489.16853.12396223625931902483.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 17:40:04 +0000
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210715055923.43126-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, qitao.xu@bytedance.com,
        cong.wang@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Jul 2021 22:59:23 -0700 you wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> The print format of skb adress in tracepoint class net_dev_template
> is changed to %px from %p, because we want to use skb address
> as a quick way to identify a packet.
> 
> Note, trace ring buffer is only accessible to privileged users,
> it is safe to use a real kernel address here.
> 
> [...]

Here is the summary with links:
  - [net-next,resend,v2] net: use %px to print skb address in trace_netif_receive_skb
    https://git.kernel.org/netdev/net/c/65875073eddd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


