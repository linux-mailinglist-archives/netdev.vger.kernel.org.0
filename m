Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576AD34D674
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhC2SAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 14:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhC2SAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 14:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28EE061936;
        Mon, 29 Mar 2021 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617040809;
        bh=lWwcuVCtAAxnlyn73aGuyID1dvTl/FwLn2CUUN0ZQ4g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J9XAQbdnu63JZQHN/kf6lXg9IZ38pJ4YOFeiqzPIFH4l0RscPTLbBHgJxTBQc/dcH
         4vZ1BIHZPCl8ViQfYAuvKuoghNjSzpDLmRuQl2KbvlpcnGzI47bFqBbh8Zx099eRnn
         f7cUeu7Ncye609S34dMWz9sZ4xegzRO6nG/PC4vdowmQrKFxVi1WGAwt1R0/CykjX2
         ezxAnFDANNHPAlVZllNjlS0tYM8VbFFis+j39RqGuDxlA1GLZlgTBRVIjSp5dqQu88
         2ipt74BKXMfK+Knj2w6JI0evXzkyo4MDHOM9v02w9s4PO58jDyeCUols4avqyy9G63
         GfUXtzsMHvR0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18F8160A48;
        Mon, 29 Mar 2021 18:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lan743x: remove redundant intializations of pointers adapter
 and phydev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161704080909.12422.10474465568742407078.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 18:00:09 +0000
References: <20210328214647.66220-1-colin.king@canonical.com>
In-Reply-To: <20210328214647.66220-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 28 Mar 2021 22:46:47 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointers adapter and phydev are being initialized with values that
> are never read and are being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - lan743x: remove redundant intializations of pointers adapter and phydev
    https://git.kernel.org/netdev/net-next/c/37f368d8d09d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


