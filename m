Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2D94225AF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 13:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhJELv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 07:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhJELv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 07:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C42AF61409;
        Tue,  5 Oct 2021 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633434608;
        bh=jaTojMCxRuXFcXME9PeSVJhLH5i9NJZpTsCDdGmD9MI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y2HHg1dMEigr6ZMdTi98Ga1CCJSjpW92aeywl0xBZrkPjCEO+TMkenl1A93G3cQGy
         BNli/CyU4ncJGKOIImYEuNDgSCyPrtN0tVgUbtI6iFJjmhfjlciqhhGlPMQrQqQmK/
         w7BCHIm856PM/p5dn+Z88nVvGAjbUjTT2NEcYIFCV7eFh6wzhOfaobDnOv2kB11PhJ
         Sgk8P/a93kEBCvtrMCvEPOUyMYMY82Iq+l1DmeTc3s76HCU5VD9LAgcfrIrPDFPEBA
         Dx3Fnbrq4ZdIORjiUUU3FoT/7sSfzOzFRK55V71o4xjVwdHX7yTxia0f5bEzgeBLC0
         6jKeoIlHZCgXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BAECF60A1B;
        Tue,  5 Oct 2021 11:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: sch_taprio: properly cancel timer from
 taprio_destroy()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163343460876.12488.4550894028979621156.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Oct 2021 11:50:08 +0000
References: <20211004195522.2041705-1-eric.dumazet@gmail.com>
In-Reply-To: <20211004195522.2041705-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, dcaratti@redhat.com,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  4 Oct 2021 12:55:22 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> There is a comment in qdisc_create() about us not calling ops->reset()
> in some cases.
> 
> err_out4:
> 	/*
> 	 * Any broken qdiscs that would require a ops->reset() here?
> 	 * The qdisc was never in action so it shouldn't be necessary.
> 	 */
> 
> [...]

Here is the summary with links:
  - [net] net/sched: sch_taprio: properly cancel timer from taprio_destroy()
    https://git.kernel.org/netdev/net/c/a56d447f196f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


