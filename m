Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E49136CDD0
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbhD0VXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238040AbhD0VXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD51561408;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619558567;
        bh=nqOKCKEV7TEgV/uQ9U9lwn82QuT6PpzDjaTyJSxNzRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WkxJAwxGyobmVp44thr1ODoad/SXoO9jSsJHu/CesEzWhG07lcUT72wO4mcm/s8ih
         XvhzIZTv0E2oLENRFZv+d5RJaaeLt54LxQN2ODrP+mx0pUJRSuywA2CxS1PGGn2Ja4
         Mq8LdBwBgtuTEr3ONK8NeyCHBG3Ii/YStUtcv87Xqi137iCQ2YpZLhmResVKHrxxKp
         bZLiaZLmQmqe/YBdrVpH+9Nj3evGjvGO4FXUzsPEMNR2xylGDAzm7KcWu2ybVYWaAl
         B9n4QHZVnfBjNwDc645KwKrzPhFWBQpiqRIoQHKBy/X5y32GyYIUfRwXtygDtJvdU2
         HQmJt0fNlRUUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B303260A36;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rds: Remove redundant assignment to nr_sig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955856772.21098.15914264833247958689.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:22:47 +0000
References: <1619519087-55904-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619519087-55904-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, inux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 18:24:47 +0800 you wrote:
> Variable nr_sig is being assigned a value however the assignment is
> never read, so this redundant assignment can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> net/rds/ib_send.c:297:2: warning: Value stored to 'nr_sig' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - rds: Remove redundant assignment to nr_sig
    https://git.kernel.org/netdev/net-next/c/4db6187d721e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


