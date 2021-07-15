Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1DF3CA4F9
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbhGOSNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231970AbhGOSNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 14:13:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CF75613CF;
        Thu, 15 Jul 2021 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626372606;
        bh=980hbBsJABCEjATWJ06u9M+rcFOPlac9rYpVNpEV8jw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UxaCaciyGS+HUBbep5ZIgyD6to3yDbje+81HfaMobC5R1/AQeam3BQtaDHJl/oZeh
         lvA3UkWIpq+t8sEqURLcH2Z4IfcDDZDiJbes3LXTjxkxerkDObEiUi7bGFpule9B3m
         rd7REiwgSVcXeN4MJgfj4sAwCzMm8yndhcCasmpk8ppi45+eNNXqToUTu2IfJG8QDk
         qyjTVsW2iHYJqDARPdECREmXlySsPPnU9fpn+tG2pUzRq/JRdUggsJzj6BSw48bnP4
         PN1yg4NC+g9HqhtXgEe5eq2gnRAZWPYtbdqSic6pQ95oQ54SHCMph7TyYmqTtJXT3O
         cmONdCxGP//kQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 979B0609EF;
        Thu, 15 Jul 2021 18:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next resend v2] net_sched: use %px to print skb address in
 trace_qdisc_dequeue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637260661.877.8562259690892160817.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 18:10:06 +0000
References: <20210715060021.43249-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210715060021.43249-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, qitao.xu@bytedance.com,
        cong.wang@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Jul 2021 23:00:21 -0700 you wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> Print format of skbaddr is changed to %px from %p, because we want
> to use skb address as a quick way to identify a packet.
> 
> Note, trace ring buffer is only accessible to privileged users,
> it is safe to use a real kernel address here.
> 
> [...]

Here is the summary with links:
  - [net-next,resend,v2] net_sched: use %px to print skb address in trace_qdisc_dequeue()
    https://git.kernel.org/netdev/net/c/851f36e40962

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


