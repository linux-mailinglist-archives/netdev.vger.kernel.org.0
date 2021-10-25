Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA97843975E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhJYNWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhJYNWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 09:22:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8ABBA60F9B;
        Mon, 25 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635168008;
        bh=ujSE2caxfniuYu8rQ9DiwvzkjY5JcPyu0rdT0g5lxs4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ti6xqqot0WfwW6CHMG/0t+cLkQVqWLIt6i9Gk4n93ETABCrBeoX/cJSdZIju8UEpl
         xwnb/tt6Vw2Uc8GAqsLymxuLT+eNGVNZ1NBfwHTlNDOBMmEsfAWPY4bATX9uetliXm
         pgRyjkCW6Fczx19ZYW5D46h0LVwwUv12nT1QkcI3Cy4BBzqu0Zgy85V7g3p42GPaEJ
         S4rFwGNlZVXphrJfBgxDC0IJcCpXYtrTyY+dq+XSM1JSeCDav2H9RAIKbXP4cQfySW
         BdgCA+dqhAqWyA8SqzsGcTmFqHkD9AhpFq/VKzaZ8MfTmVOcRPSbmNP+jgO4upABg7
         0ecSpasVf1waA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 803DB60AA5;
        Mon, 25 Oct 2021 13:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-10-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163516800852.2904.10606125792742184473.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 13:20:08 +0000
References: <20211025084410.BB75DC4360D@smtp.codeaurora.org>
In-Reply-To: <20211025084410.BB75DC4360D@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 08:44:10 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-10-25
    https://git.kernel.org/netdev/net-next/c/2b30da451062

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


