Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD88730189A
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 22:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbhAWVk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 16:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbhAWVku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 16:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EE2A222795;
        Sat, 23 Jan 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611438010;
        bh=fjNj50Z+Coyuw0Se4H4wpoEF2gBSv5bq63ViIAOyDlg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iQwFKq3xzFlpW5s5uah8pdia5kPMH7w2ugYZLfXIfbQ3Zl1yvi7TlZz/jLkuB+W2x
         S4G0T5tt21OD9BXVq+dhd8SEycmKDTWD5+z05k+5G7L9wJlek5L7wCQjVCsv6Xuj7L
         suj9k8/D5YJZjl6ptlsJvnyh6Fm1/vorKF708UzY7YKC8gEFHFve0DUkC+1keeUMRC
         n5AckKZn4zmjFL6Du67lO0cpQ+er+ZHi1RTKM8UlWGkP4isFzskJx5L20qMNwU0+0r
         cIIIUjbpaNAPwhkGu2/DbiBD2WHhMN2QaivG6aoVlpU0aLEI4/Fp5TUf0/Tg2RhVGa
         wD/ZtirslXg3A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E134F652E6;
        Sat, 23 Jan 2021 21:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: fix possible resource leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161143800991.9404.6115468760500564146.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 21:40:09 +0000
References: <20210121153745.122184-1-bianpan2016@163.com>
In-Reply-To: <20210121153745.122184-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        laniel_francis@privacyrequired.com, bodefang@126.com,
        sameo@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 21 Jan 2021 07:37:45 -0800 you wrote:
> Put the device to avoid resource leak on path that the polling flag is
> invalid.
> 
> Fixes: a831b9132065 ("NFC: Do not return EBUSY when stopping a poll that's already stopped")
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  net/nfc/netlink.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - NFC: fix possible resource leak
    https://git.kernel.org/netdev/net/c/d8f923c3ab96

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


