Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9477E453ED3
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhKQDNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:13:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232720AbhKQDNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:13:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7213A63215;
        Wed, 17 Nov 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637118609;
        bh=xvvpKMv3n9dn1UYPou3YZDc2ijbgJ/EyVMjkBykdOrw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d03We4CsBOySfNPcHr5vvV8sqj1jAbhBYYRKzgrmvPNZvvaeBnmmngWjZOyjvm/9F
         LCRJN2d37zkUEG49wYrwhShe7XUMveJcaV7uht4kHmcKSjIbwhhoIDtpVtYOrjqUVD
         kWpEY6UjcodHOSszlieT/IOWg2gJB/onsORvrqYZfZWZiel63Z43XV2FyBojOXmIsQ
         w01LX++9PES16DhBSy2N+NO25Emap1OT+8ParJjt5M1ZvkB9pHrP9B/7QbMnxszfrH
         5lPLtlXnBu6YwiPKuc3JL5VMy3hgVk3HIlxOh/oNiewGFC4pMJEOts6+oHL67KdZ+c
         8mCfd0o78hPnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56CF460BBF;
        Wed, 17 Nov 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: Fix compile error regression when
 CONFIG_BNXT_SRIOV is not set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711860934.28737.16471011801645396630.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:10:09 +0000
References: <1637090770-22835-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1637090770-22835-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Nov 2021 14:26:10 -0500 you wrote:
> bp->sriov_cfg is not defined when CONFIG_BNXT_SRIOV is not set.  Fix
> it by adding a helper function bnxt_sriov_cfg() to handle the logic
> with or without the config option.
> 
> Fixes: 46d08f55d24e ("bnxt_en: extend RTNL to VF check in devlink driver_reinit")
> Reported-by: kernel test robot <lkp@intel.com>
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: Fix compile error regression when CONFIG_BNXT_SRIOV is not set
    https://git.kernel.org/netdev/net/c/9f5363916a50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


