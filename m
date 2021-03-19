Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872CC34274E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhCSVA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230468AbhCSVAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 293FB61985;
        Fri, 19 Mar 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616187609;
        bh=51n7YqRNqtrHEAhT7dY3yOWsbSFEncOCiAugh/aBHv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DTt5nmkCdLw1vFCF1mM58mAc/YYVnrdH0dTAP3Ta/eRBwyjnDkZYk/xpd5pm6IN1L
         YMG5XIdu5gZpOCTuB3lRNyP8Cf185krpkajiEH07DtnlRIX583BZdmI40HLjKKb0Ol
         xWEB9881UZGvtP5z9zaMM3Hiz4n66jT6Nuh7lNeO9jKfkhn4JFlEA4WemxYmgZAqwP
         18FkKLpwfmjxkFyxuXd7TspMvTrjLGW38B2cSDMpIT6aBxQoXmQwKbLesce9n++7Oy
         3lCABg+jG138J5Iypx9Gs2Fxw9MXKkgaR4LlmhxDPfQcvjhxH2k9KwlW2j72bm7ClG
         VWQEpjzxRKVrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E796626EF;
        Fri, 19 Mar 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] selinux: vsock: Set SID for socket returned by accept()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618760912.12397.14174236493108534163.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 21:00:09 +0000
References: <20210319130541.2188184-1-dbrazdil@google.com>
In-Reply-To: <20210319130541.2188184-1-dbrazdil@google.com>
To:     David Brazdil <dbrazdil@google.com>
Cc:     selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, paul@paul-moore.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        jeffv@google.com, adelva@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 19 Mar 2021 13:05:41 +0000 you wrote:
> For AF_VSOCK, accept() currently returns sockets that are unlabelled.
> Other socket families derive the child's SID from the SID of the parent
> and the SID of the incoming packet. This is typically done as the
> connected socket is placed in the queue that accept() removes from.
> 
> Reuse the existing 'security_sk_clone' hook to copy the SID from the
> parent (server) socket to the child. There is no packet SID in this
> case.
> 
> [...]

Here is the summary with links:
  - [v2] selinux: vsock: Set SID for socket returned by accept()
    https://git.kernel.org/netdev/net/c/1f935e8e72ec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


