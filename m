Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A332F369BEB
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhDWVLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244032AbhDWVKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4183961466;
        Fri, 23 Apr 2021 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619212216;
        bh=rDMBLdFs+wWL4z8l73Ta3ms6lsUsUYvjWn7OycMAWrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QLyZqjb2oQVdCDJR4PLPBA4GzR51hIl1bfv7bqkxnp9dPjoSAWjrCB7mKpHsGL95n
         hJkVJfRXJohefZqT7Gxfm1RiFRf3gUda4kZsuMtMfRtrz0/WjmYxk15wUqOKupdAA8
         kDHuOSv1uhwLl3CcgKuTLSvqBAvL6HfeMCLY2HFQv0I9gUxikUSUEmqVKnz5n1SGEd
         +y2DoZMI1RMgV3gf5gvze2t+LmagJghVhyvYnkGdI+/20eXb5xwOdJNwWMj6oAcykv
         yPEn6Fl7wg7B+nVV3wPaFRzyU/Q6HqDjFNp14ftqKFTx8TKQJvYi6/kYFHBk7YokUY
         R68Ex5ap/qwNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3898860A53;
        Fri, 23 Apr 2021 21:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] selftests: mlxsw: Fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161921221622.24005.11828493414067253441.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 21:10:16 +0000
References: <cover.1619179926.git.petrm@nvidia.com>
In-Reply-To: <cover.1619179926.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com, idosch@nvidia.com, danieller@nvidia.com,
        jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Apr 2021 14:19:42 +0200 you wrote:
> This patch set carries fixes to selftest issues that we have hit in our
> nightly regression run. Almost all are in mlxsw selftests, though one is in
> a generic forwarding selftest.
> 
> - In patch #1, in an ERSPAN test, install an FDB entry as static instead of
>   (implicitly) as local.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static
    https://git.kernel.org/netdev/net-next/c/c8d0260cdd96
  - [net-next,2/6] selftests: mlxsw: Remove a redundant if statement in port_scale test
    https://git.kernel.org/netdev/net-next/c/b6fc2f212108
  - [net-next,3/6] selftests: mlxsw: Remove a redundant if statement in tc_flower_scale test
    https://git.kernel.org/netdev/net-next/c/1f1c92139e36
  - [net-next,4/6] selftests: mlxsw: Return correct error code in resource scale tests
    https://git.kernel.org/netdev/net-next/c/059b18e21c63
  - [net-next,5/6] selftests: mlxsw: Increase the tolerance of backlog buildup
    https://git.kernel.org/netdev/net-next/c/dda7f4fa5583
  - [net-next,6/6] selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test
    https://git.kernel.org/netdev/net-next/c/1233898ab758

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


