Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23795311F35
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 18:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhBFRut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 12:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhBFRus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 12:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B0B7E60233;
        Sat,  6 Feb 2021 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612633807;
        bh=H1V81hpAl7b5UHm5eloWljxJGDlR07HgNP9s1nYU4Y8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ruktzYA+409ebtaXAHglbA9RiaamEQKdIWBM1i17YtkQdTE2Z1ya4TLDrMlYKiFIS
         n3MmMMllWdvB1MvoZzsoRjE7LaqoCx2yyKyBVvU2Xs445Sdyhk4qYFbpiqIPzIZn1s
         lbQL06q12vP4n3IA8TodyLGQVJUGb52du6UK/qHUxdpmgP0SkZm+0iDihY7stG7Yox
         g1huXeVoQkiMgXocBF80MVVKeQiBn+Ekbnbq0EZzo+WppqnBMbwNzlMEFGd8A6L4wN
         rdUE8ce6k9l+EmB3jL0wvZbeTvvqwXrBEPYOAenpClMZcsMLzd2cOXGXIp9EmeWLE2
         dd3r8ZvHpsV5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A4870609F7;
        Sat,  6 Feb 2021 17:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-02-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161263380766.19726.10360229022737793677.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 17:50:07 +0000
References: <20210205161901.C7F83C433ED@smtp.codeaurora.org>
In-Reply-To: <20210205161901.C7F83C433ED@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri,  5 Feb 2021 16:19:01 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-02-05
    https://git.kernel.org/netdev/net-next/c/c90597bdebb5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


