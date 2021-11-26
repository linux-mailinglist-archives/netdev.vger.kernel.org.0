Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E39945F58C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbhKZT7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236971AbhKZT5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:57:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D611C0613FA;
        Fri, 26 Nov 2021 11:40:13 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5A47B828AF;
        Fri, 26 Nov 2021 19:40:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 1BA1A60230;
        Fri, 26 Nov 2021 19:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955610;
        bh=CfZqyWw88LVUto7q+8SG3nKcJTsR9qKhcWY796t/NBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FAk6bZHuAQUkzzUCYjq4A1yPAmEWXdMQj+cDvvy2PBUZIX6vfgSrlGXfoVXnhEiqc
         BmO3wWMF/ZvmK9GlbE3eIeq/3mT5PCwGl4Dk0QgL8wJPuCHdxr7coqa4CsscU8qchJ
         VlU5emXa1UmpWQMsu4cUMMhfnIwC6vZdq22IwOv/lUXtdv+TYrTgXdr5DOeeC6VccU
         wfL56hLpp7XdMv//YU44mRy9p5u+FC8tpRy5GuCt4TZQI1rtFE7kswMkFamGBSquWG
         I/xXpjfDcxkzrhev118wkSHtVuNaxcsiLny2jWQWQnrnvlMgbIVbTteZmYBt8V3DGb
         Zc9ho/wcXZFhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F3E2D60A6C;
        Fri, 26 Nov 2021 19:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net/smc: Don't call clcsock shutdown twice when smc
 shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795560999.18431.3973252730060486698.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:40:09 +0000
References: <20211126024134.45693-1-tonylu@linux.alibaba.com>
In-Reply-To: <20211126024134.45693-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Nov 2021 10:41:35 +0800 you wrote:
> When applications call shutdown() with SHUT_RDWR in userspace,
> smc_close_active() calls kernel_sock_shutdown(), and it is called
> twice in smc_shutdown().
> 
> This fixes this by checking sk_state before do clcsock shutdown, and
> avoids missing the application's call of smc_shutdown().
> 
> [...]

Here is the summary with links:
  - [net,v3] net/smc: Don't call clcsock shutdown twice when smc shutdown
    https://git.kernel.org/netdev/net/c/bacb6c1e4769

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


