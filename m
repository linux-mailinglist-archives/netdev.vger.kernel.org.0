Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E731315AAF
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhBJAIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:08:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234591AbhBIXuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 18:50:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C849464E37;
        Tue,  9 Feb 2021 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612914611;
        bh=C/8QEGDgU7P/TRR0C2wPrTxFZvgEVTYTiQ5OZY4VCfg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gU1Cnct/vFfmernNlj+nUzeGxDdL9KcjCiN6klPIuN3D0OZAYcYqYfEh+Vtkuz1ys
         /OWxue/EWWo0UhyQb2QvQaMrzJVvy7XxGlbB5gxPXQAdNiC/kZXB3k7fafcO5Ztah4
         VauyT9ZVasyallEjWsUfoBI4B4NCb0hRqirmtu6G+OeDmL0Z9VZMODlcyvLDmf+ijX
         JR2EtNXLcJNtlXjIV2xuk0NP+ficTNkfoBpc+RGCWnD90B1zu+PZFHqIOAP87XIpYx
         tmlHR+EBgllOiSv9TQ4mo+o+Sd9FtHkXLYkxi9+GJqzQu7kfrtXoVsyToH1SvBMP52
         1bi3onLOXSSiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BA8F7609D6;
        Tue,  9 Feb 2021 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v11 0/3] implement kthread based napi poll
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161291461176.1297.15958999110530994258.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 23:50:11 +0000
References: <20210208193410.3859094-1-weiwan@google.com>
In-Reply-To: <20210208193410.3859094-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, hannes@stressinduktion.org,
        alexanderduyck@fb.com, nbd@nbd.name
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  8 Feb 2021 11:34:07 -0800 you wrote:
> The idea of moving the napi poll process out of softirq context to a
> kernel thread based context is not new.
> Paolo Abeni and Hannes Frederic Sowa have proposed patches to move napi
> poll to kthread back in 2016. And Felix Fietkau has also proposed
> patches of similar ideas to use workqueue to process napi poll just a
> few weeks ago.
> 
> [...]

Here is the summary with links:
  - [net-next,v11,1/3] net: extract napi poll functionality to __napi_poll()
    https://git.kernel.org/netdev/net-next/c/898f8015ffe7
  - [net-next,v11,2/3] net: implement threaded-able napi poll loop support
    https://git.kernel.org/netdev/net-next/c/29863d41bb6e
  - [net-next,v11,3/3] net: add sysfs attribute to control napi threaded mode
    https://git.kernel.org/netdev/net-next/c/5fdd2f0e5c64

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


