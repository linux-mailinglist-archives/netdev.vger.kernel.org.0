Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62E4400AAA
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 13:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhIDKBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 06:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234618AbhIDKBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 06:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B202561056;
        Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630749605;
        bh=ylmsh0vL4rvwx9sSRgSyqQInuxwwEAUGh3DY5WRrZz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fv6PYBOZ09EBpaMtwC1DVgSLa8wnYcyOfc0MsaFxA1bs5eS0YSkOrtqZwmCYdtXwH
         a35pxxCegq+s/ba6w+T2p36fkWmpF9h1cbd2kIPgp81V9DxJ3MLA3I/tf+2tA9QXlc
         0HvOeYFAJ9HZeCOwQnDu6PcV04olvwgt+1js1oe68R53Gut5HxX5GvYil9eMS4lXRT
         VR7NtX2qOAMdnA6dh1EEE9608McOE/RF9z62VsotGEIO9GPYCrZIUPwN4RnGfmLk0D
         VjoEBuVaAj+VW3iTRT5XM+I9dpj5hT3nEbUI/F7CaC1vk0WqF1RDsi27iVQ3HSj460
         2CbNbwNISU9rg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A516460986;
        Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163074960567.20299.3371264143272818975.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Sep 2021 10:00:05 +0000
References: <20210903073543.16797-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20210903073543.16797-1-dinghao.liu@zju.edu.cn>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sony.chacko@qlogic.com, anirban.chakraborty@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 15:35:43 +0800 you wrote:
> Previous commit 68233c583ab4 removes the qlcnic_rom_lock()
> in qlcnic_pinit_from_rom(), but remains its corresponding
> unlock function, which is odd. I'm not very sure whether the
> lock is missing, or the unlock is redundant. This bug is
> suggested by a static analysis tool, please advise.
> 
> Fixes: 68233c583ab4 ("qlcnic: updated reset sequence")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> 
> [...]

Here is the summary with links:
  - qlcnic: Remove redundant unlock in qlcnic_pinit_from_rom
    https://git.kernel.org/netdev/net/c/9ddbc2a00d7f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


