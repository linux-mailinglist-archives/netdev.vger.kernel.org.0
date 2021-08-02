Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53C13DD2FA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 11:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhHBJa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 05:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhHBJaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 05:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E57C610CF;
        Mon,  2 Aug 2021 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627896606;
        bh=r4RY8fqmwftXRkulYlyDvACNomEz1P5hau2kesl981Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aptc8WoHIpLBj+O/BLsPmEbGHjmptHFMKS3rIotTE7K2WgqhP5Jfc1qhqlRcnL5n7
         vNulXUNNA9mLwqoyAMPqKeoB8cCj/cZEZoybuN1DxFFwQ0InW84j2OoKuht8fabmeA
         uWV34xbeWPE7k/QEq9Y7cXRxubo+Kq0Ltfh5Nw+6XMzHEDw7ZaFE1YdZ/EzHRqtJZO
         KT9wNhc+SAqDgeXb1u5hNu5lFodDMBPFIRYpLfdVRIAF3bWT/lQEj84pj2Doq5Vqus
         kJbsqXwEvUIa9Ruazy5BblfGGwZ+hDdy7V2mnKFB/XzdEwxbJ1RTb4Uc/dGquRJpUW
         hHqIS1CzVoggg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 862EE609D2;
        Mon,  2 Aug 2021 09:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] net_sched: refactor TC action init API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162789660654.5679.14884017382761201091.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 09:30:06 +0000
References: <20210729231214.22762-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210729231214.22762-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com, vladbu@nvidia.com,
        jhs@mojatatu.com, jiri@resnulli.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 16:12:14 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> TC action ->init() API has 10 parameters, it becomes harder
> to read. Some of them are just boolean and can be replaced
> by flags. Similarly for the internal API tcf_action_init()
> and tcf_exts_validate().
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net_sched: refactor TC action init API
    https://git.kernel.org/netdev/net-next/c/695176bfe5de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


