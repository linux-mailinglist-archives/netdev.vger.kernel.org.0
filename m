Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDB346F479
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhLIUDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:03:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42158 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhLIUDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:03:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3F96B8264A
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 20:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BAABC341CB;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639080011;
        bh=b0Yc0OUWAlHRVXbjsb0FOEkDmC2w/7m7Rflm7P0MjTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KWs9As2+CIiJKAKL0+WeC1pHkJx5rkVvZ5tLyOIXBDMOxEMDH9QSUCfwxTHi4owJ+
         FMJsT6IhMdPb9o84eckTLkwBIXzRQWeTfdz65YMEAeMCCiMNBq4HbbXN1aUlWo8HlR
         XADcSMQmOAkZm3+VvFy/3Ua8ZobaNLhfx+TD8KkDRpiuepNQZPj7xfXiixQUiFYW1i
         xB4bFvK/dlheuHz5yaTQaRyHye48ISu58tA4jhqoWuJFByljgvkFNRiCnONg2hh1kV
         /j/BAIZMXdWa9dgVlQHnrlWX8suj1Oo3jzv8OVClhagFqeop37aIeGJaLaJZUc5kdu
         sx7ufjicm4cPQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B9C260A3C;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xfrm: use net device refcount tracker helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163908001137.24516.4056994602235148987.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 20:00:11 +0000
References: <20211207193203.2706158-1-eric.dumazet@gmail.com>
In-Reply-To: <20211207193203.2706158-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, amwang@redhat.com,
        steffen.klassert@secunet.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Dec 2021 11:32:03 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> xfrm4_fill_dst() and xfrm6_fill_dst() build dst,
> getting a device reference that will likely be released
> by standard dst_release() code.
> 
> We have to track these references or risk a warning if
> CONFIG_NET_DEV_REFCNT_TRACKER=y
> 
> [...]

Here is the summary with links:
  - [net-next] xfrm: use net device refcount tracker helpers
    https://git.kernel.org/netdev/net-next/c/4177e4960594

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


