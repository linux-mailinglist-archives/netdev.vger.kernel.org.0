Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35CB3D1DE7
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 08:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhGVFTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 01:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhGVFT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 01:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4498361279;
        Thu, 22 Jul 2021 06:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626933605;
        bh=LWDQeO3KfSMFLqfUAccSHHWAxpvzF15gm4cYHbnVIvc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c9PO+RVvgZGH1ODcFwme+fMTzHvoYlQbTSdGjRfFAOZ8/eZt1Ibn5VGA9g3oZ1bg6
         iOLswpeGdH+zn65rojBpKk6+B4d5uP/sm9tw26zrK8zoEKsWj/xNHUAXE/zeT7Sr10
         TPuK4k0vh3eaZ9feGsHb9xhospB/2MeijABBzqN9jwofK2isioLCFmTf3h3tU5R4Qo
         JUKBDXVDAH/FDpaGvf86GWb1V4TNs0wNZ8aW8DBLolZkmPJDqiM0zL5/ro5zVNnTfu
         5CCqQ8KhhdkVsWezIOzDVGVjUKLM3m3TRuqoDuneqMRCVJmOTSvJ6kbFLvSaYQSlmo
         ArRlXghk1ifwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39C0160CFD;
        Thu, 22 Jul 2021 06:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: disable TFO blackhole logic by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162693360523.26975.16499701394881587097.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 06:00:05 +0000
References: <20210721172738.1895009-1-weiwan@google.com>
In-Reply-To: <20210721172738.1895009-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        edumazet@google.com, ncardwell@google.com, soheil@google.com,
        ycheng@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Jul 2021 10:27:38 -0700 you wrote:
> Multiple complaints have been raised from the TFO users on the internet
> stating that the TFO blackhole logic is too aggressive and gets falsely
> triggered too often.
> (e.g. https://blog.apnic.net/2021/07/05/tcp-fast-open-not-so-fast/)
> Considering that most middleboxes no longer drop TFO packets, we decide
> to disable the blackhole logic by setting
> /proc/sys/net/ipv4/tcp_fastopen_blackhole_timeout_set to 0 by default.
> 
> [...]

Here is the summary with links:
  - [net] tcp: disable TFO blackhole logic by default
    https://git.kernel.org/netdev/net/c/213ad73d0607

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


