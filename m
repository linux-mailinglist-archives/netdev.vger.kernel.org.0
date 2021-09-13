Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825F140966F
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 16:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345308AbhIMOv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 10:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346619AbhIMOrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 10:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B02F60F8F;
        Mon, 13 Sep 2021 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631543406;
        bh=dH+ODAaC6MVkMUy+8Y+m6x/4E8UC0m9LCFDS4QZvB98=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NuHlfLZ3QIHPCtg/VbEvzFLWgINuNxWVMQs8v4YoYiUDpbSxG/b9TGlXGZkQmWcMM
         zkBUIqy5uArqhNH0+yb2dugH6PHP3Q9Te1zGk8Rs1nt092zBWBarZh9agHMAUPyxuf
         dhpgyoTSSvOCTwDmuUeoMcCynMNIFTIfpubYlxCLFxLYWusdUiDnxXz5BMscBtWgLh
         ZgbzyG65NkW/QmE+yXkc5fXEsKiBwzet0/M4fnsOJu71RcO324wrjLv/P6BkYSAcl9
         VyD9w40Yl5QxYVYzHrman7SsFzoHU2ssaKIJpuvThv1AYOVUSj4BO3vmwLMc+v9zjB
         2t62DrFsttdig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6DD1960A6F;
        Mon, 13 Sep 2021 14:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: iosm: firmware flashing and coredump
 collection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163154340644.4569.2591879321459631995.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Sep 2021 14:30:06 +0000
References: <20210913130412.898895-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210913130412.898895-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 13 Sep 2021 18:34:12 +0530 you wrote:
> This patch brings-in support for M.2 7560 Device firmware flashing &
> coredump collection using devlink.
> - Driver Registers with Devlink framework.
> - Register devlink params callback for configuring device params
>   required in flashing or coredump flow.
> - Implements devlink ops flash_update callback that programs modem
>   firmware.
> - Creates region & snapshot required for device coredump log collection.
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: iosm: firmware flashing and coredump collection
    https://git.kernel.org/netdev/net-next/c/13bb8429ca98

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


