Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCBC406D22
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 15:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhIJNvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 09:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233554AbhIJNvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 09:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C0FA611CC;
        Fri, 10 Sep 2021 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631281806;
        bh=ymTAeqeU7FRew1jvpRLg04g6PljeHQDtqM1TeeA2uD8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YziWsMZyCrHuu7t/EODgFm7nVtE5FBhn4gIkSiZZenzJKVonoYRYHNApzFOz0O20X
         Yh6eBQaZH3pYjyTeDVX0IjNSEROSFMq/9SdPpOU189TgIqn4d5B3zzpeWSOahRcO2d
         pdAoKCGBRgphAx0Rv6lhtdvGnIXuCprdfHcFt3mawi3/CSxjanbI5fUV+VxqMd6XeG
         hHcfWH+0+02XbKCWVFmvUiokZPhHgOEnwR7UzaHtdCHpw9VyqgG0Uu85882tyanng2
         4Sg2BkM7HoTyTl5cbY1Zejx/LbHRiw8lx9pwo2+9y/hS9uVqFhhTfhbOZgNtPeCzpK
         maGQ6NkKmq4sA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 70B2E609FF;
        Fri, 10 Sep 2021 13:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: Remove redundant initialization of variable ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163128180645.19053.13072280068396330579.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Sep 2021 13:50:06 +0000
References: <20210910111511.33796-1-colin.king@canonical.com>
In-Reply-To: <20210910111511.33796-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 10 Sep 2021 12:15:11 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never read, it
> is being updated later on. The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - qlcnic: Remove redundant initialization of variable ret
    https://git.kernel.org/netdev/net/c/666eb96d85dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


