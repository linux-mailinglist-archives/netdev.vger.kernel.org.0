Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076714360E6
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhJUMC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229765AbhJUMC0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 08:02:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5E93960F9E;
        Thu, 21 Oct 2021 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634817610;
        bh=LjxLzV+RTYqFwMPpNZnK9drf+mkPKeYj+QbsRTfqVYI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H39bujwJBUQilS2VrG7D73SiYKNX3GmfpqquakJYZWrm5ZSR3C4FvgBch+owao9De
         RJaco7hcR9Fz5dr1cukhhiWTgR1g88UpbwYbWh1Ix73ELhlMGKiFRoMyYYhIRjYwdk
         U57hXBvYepX9ZfF2/Memi/IIpi6b0+Jtt1NZeRQhdLFNCN6dCfWfEJss2tXppEUSDH
         BWRebkS+1rKHlVP67JrQCqVzJw7cK7fqE/ckjmmflEERBYLNHXQig2WPTlnh9sfiVm
         sOKzomUV3q8VMp1yMebPHjewyCku6j2rQcTJO1plNgzxpqti6lCGMVb141DOkZ8E0I
         7pX9GE3ch/zZw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 54B0060A22;
        Thu, 21 Oct 2021 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -net] ptp: free 'vclock_index' in ptp_clock_release()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163481761034.21729.18037093655482212990.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 12:00:10 +0000
References: <20211021091353.457508-1-yangyingliang@huawei.com>
In-Reply-To: <20211021091353.457508-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Oct 2021 17:13:53 +0800 you wrote:
> 'vclock_index' is accessed from sysfs, it shouled be freed
> in release function, so move it from ptp_clock_unregister()
> to ptp_clock_release().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/ptp/ptp_clock.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Here is the summary with links:
  - [-net] ptp: free 'vclock_index' in ptp_clock_release()
    https://git.kernel.org/netdev/net/c/b6b19a71c8bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


