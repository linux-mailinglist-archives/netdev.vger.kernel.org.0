Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825B845F564
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhKZTu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhKZTs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:48:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A6EC06175F;
        Fri, 26 Nov 2021 11:30:10 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33BA962346;
        Fri, 26 Nov 2021 19:30:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id A90A46024A;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955009;
        bh=dmZjjxF0kpvN51hC6J3wKkaZ5YW+fKIWoqs/Sw9sprQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rlw0ffbeANT4nFEhAvklxsjfoZNt+1kGRzflZvEjUDVivTodODouWGG2qkTGoyNBQ
         tVhKFW8ysfntcPI0vbNSR+LVy4IhNKJbOvWjtllU5nG4cSSxM6RQNmXE1/qLcD9NOH
         LTE0ZXB369BPwaWBlme1sOTQyVXoY5D3YOcD9YT/IP9GAc7tGQKVwVWEnycqJxYxmF
         rXSS7h5E0ZJPjzBq7R/ZetTHzznOljUQVcFqHCbYo9VhvNl6trZo4oUcGnbc8fxFl6
         b8gkCF2Xk8KSjkam3SfYh+6dOHvpV4PYi6yz6SBlrk3w63ydD2UVng27IkVsvsSh4k
         Ik3Znr2Q+2SMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 924C460A6C;
        Fri, 26 Nov 2021 19:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: ioctl: fix potential NULL deref in
 ethtool_set_coalesce()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163795500959.14661.4830039441198215968.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 19:30:09 +0000
References: <20211126175543.28000-1-jwi@linux.ibm.com>
In-Reply-To: <20211126175543.28000-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, moyufeng@huawei.com,
        tanhuazhong@huawei.com, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Nov 2021 18:55:43 +0100 you wrote:
> ethtool_set_coalesce() now uses both the .get_coalesce() and
> .set_coalesce() callbacks. But the check for their availability is
> buggy, so changing the coalesce settings on a device where the driver
> provides only _one_ of the callbacks results in a NULL pointer
> dereference instead of an -EOPNOTSUPP.
> 
> Fix the condition so that the availability of both callbacks is
> ensured. This also matches the netlink code.
> 
> [...]

Here is the summary with links:
  - [net] ethtool: ioctl: fix potential NULL deref in ethtool_set_coalesce()
    https://git.kernel.org/netdev/net/c/0276af2176c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


