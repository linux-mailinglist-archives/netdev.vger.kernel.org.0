Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F8A3AF674
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbhFUTwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231490AbhFUTwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 36B8761350;
        Mon, 21 Jun 2021 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624305006;
        bh=rWFcrZMgWyYYyDbhooQHw5BwBudJknEgpDg9eU5NHc4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PqDvVhQe6zxeh0yXLASRc8ED4kLul8HlDtYit8goFRj9k0bJurFCJDT7Cs3B9lP5E
         bR9wh7yUow0xr+lfbGuODsGfE0m3pA2VnQrr2Oq1YINIbV7wMfSJNWYHil7yCgSOTl
         6JgBbR2Jd9uD0ryWuVGO2ReUTUTPdHFY06MIhWDNzISRsJUYX5P1XS4+hfeAqAR2dh
         ft6GSWpB3tyOY/FaHphsfNmX9+RqsMevpV68cBkNWkKmiTdeThM/FlFaU/RNr2iPu0
         bM6mW7kulVPgU6JvGPcxZ8qqaxz2qypwTSGUI/xXvxzqRP6I2CrEUthNvIPmjm5RgL
         EpNualORxKIYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3004360A37;
        Mon, 21 Jun 2021 19:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: c101: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430500619.22375.8728214537788866582.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:50:06 +0000
References: <1624087718-26595-1-git-send-email-lipeng321@huawei.com>
In-Reply-To: <1624087718-26595-1-git-send-email-lipeng321@huawei.com>
To:     Peng Li <lipeng321@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huangguangbin2@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 19 Jun 2021 15:28:35 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (3):
>   net: c101: add blank line after declarations
>   net: c101: replace comparison to NULL with "!card"
>   net: c101: remove redundant spaces
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: c101: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/4f7d2247f839
  - [net-next,2/3] net: c101: replace comparison to NULL with "!card"
    https://git.kernel.org/netdev/net-next/c/7774318b9e5e
  - [net-next,3/3] net: c101: remove redundant spaces
    https://git.kernel.org/netdev/net-next/c/41505d3f0f51

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


