Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744ED35E871
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346754AbhDMVkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhDMVkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 17:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1676613C1;
        Tue, 13 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618350012;
        bh=vsJwV1TqBOc8SjTLWkjWYnrEngpn+yQaSOO7SM/DTJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sjnClO4VP81wddgU+pnxPT89Kdje5MzGsdjusvK9tKfQBcJpaATjkEPDjtB7KykX0
         LCmDfjQT7TkABODDjzkSQYVhAL1ISTX42LUtJ18ns7RHPQcPd3Fj5qwxIALjM7GwiW
         ZVjniEvxRYAAZj90wZrDovQpg+OA9ZE9v7I9pDW3tAWvMYSgBFrSMMFshh+1hyER/n
         RiyEZRGYNm41n5ehJWyVkxGQ4sXngf0J77lSpBpbE2CPOe9YMx5CBnoICCXCOFZ+Lt
         ZaSA502dVSyqluNvORMrl84JUY+vx5YHBmHAlZnqs4u5NRg0HBYrvAu0mVxOZ5t7D3
         D7OKjMs+vX0/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AEFFC60BD8;
        Tue, 13 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835001271.18297.6600658216026899811.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 21:40:12 +0000
References: <20210413053345.0D53FC433ED@smtp.codeaurora.org>
In-Reply-To: <20210413053345.0D53FC433ED@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Tue, 13 Apr 2021 05:33:45 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-04-13
    https://git.kernel.org/netdev/net-next/c/5fff4c14ae01

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


