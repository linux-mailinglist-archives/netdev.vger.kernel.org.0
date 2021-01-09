Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12112F0385
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 21:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAIUkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 15:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAIUks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 15:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BA81023B00;
        Sat,  9 Jan 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610224807;
        bh=XKSIy852Pm56iPu180uxhzBjg53HKi/LixzxnovNe/M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MvBAomOzCBgayx+0SNRgcW3rjsu/tejThzlDdAxqGwGTzGVbJhRvgXuQ/gXnkgjOD
         SxeIhNaHgzee2piOvN+sMk9ErCbpbHvNu3eIz9TKYv26E9fNDyD17/HP6g9fD8VCRi
         PrfGU9V5jgZVXTE0vEWPmjA9OB/o4elfILlmurhzz8t05dcBK6kfPYslUEZxPig466
         Yo/PY/9Y12+lE/IAMLfoB0GTNhzo1/YLKCcAluoi1PT94IogaM+DzjVQcU1pyHvpwv
         4iiiuYd6YHz++3aFICAtH/+7NVeldveXJ+zl0KMxCfqChyZOe0yERA30h9rrUZzz5e
         zSuxiqCukP6pg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id AEA23605AE;
        Sat,  9 Jan 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: merge do_change_param_reset into do_reset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161022480771.28194.17815152556646373652.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jan 2021 20:40:07 +0000
References: <20210106213514.76027-1-ljp@linux.ibm.com>
In-Reply-To: <20210106213514.76027-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Jan 2021 15:35:14 -0600 you wrote:
> Commit b27507bb59ed ("net/ibmvnic: unlock rtnl_lock in reset so
> linkwatch_event can run") introduced do_change_param_reset function to
> solve the rtnl lock issue. Majority of the code in do_change_param_reset
> duplicates do_reset. Also, we can handle the rtnl lock issue in do_reset
> itself. Hence merge do_change_param_reset back into do_reset to clean up
> the code.
> 
> [...]

Here is the summary with links:
  - [net-next] ibmvnic: merge do_change_param_reset into do_reset
    https://git.kernel.org/netdev/net-next/c/3f5ec374ae3f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


