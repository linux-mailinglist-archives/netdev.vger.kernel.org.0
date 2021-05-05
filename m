Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9993748E2
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 21:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhEETvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 15:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233525AbhEETvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 15:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3FC28613C9;
        Wed,  5 May 2021 19:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620244210;
        bh=U8LMdv0JzIYhXc/6KDfOVx48prcJMPjDwjj1MSlj6Kk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ABVBlWRKXjrCdMSSsNsrUai5WLE7uPSvBchKIQLKgl2VZUPhPyi5MxrBlFBWa3zQk
         FMrOZ3lhb7JdI4cvVcBDA92u+tpBoYKqJlISTebMNRfmOvrKlA8sZoQ/vWhIKyHnDy
         4qm+qGmBuH2elwfgRyqIEpkxN3ejiE39u0I/UV3uloyJxIgQKCHOUoPtJMfoYefsTH
         d17/UdmAdFexPF9XPZyy6XVYbvegJlnbjOKrgFq/d4gOqeysHwFpQMQlPGLRYk+rWA
         VvBThju+JTxvy1NJihVMZpoWEl5P1IWiqe9ltaBD0xYPoUEmcnS766ImUxpCNXD5nA
         Lm36iPNkbBEmw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2EFFE60A21;
        Wed,  5 May 2021 19:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: fix missing NLM_F_MULTI flag when dumping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162024421018.18947.12160999420020892426.git-patchwork-notify@kernel.org>
Date:   Wed, 05 May 2021 19:50:10 +0000
References: <20210504224714.7632-1-ffmancera@riseup.net>
In-Reply-To: <20210504224714.7632-1-ffmancera@riseup.net>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, atenart@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  5 May 2021 00:47:14 +0200 you wrote:
> When dumping the ethtool information from all the interfaces, the
> netlink reply should contain the NLM_F_MULTI flag. This flag allows
> userspace tools to identify that multiple messages are expected.
> 
> Link: https://bugzilla.redhat.com/1953847
> Fixes: 365f9ae ("ethtool: fix genlmsg_put() failure handling in ethnl_default_dumpit()")
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> 
> [...]

Here is the summary with links:
  - [net] ethtool: fix missing NLM_F_MULTI flag when dumping
    https://git.kernel.org/netdev/net/c/cf754ae331be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


