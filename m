Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5595B3EEF28
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbhHQPaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230369AbhHQPai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 11:30:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 339CC60FE6;
        Tue, 17 Aug 2021 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629214205;
        bh=mLboAB6pHrQZz6Y7eM9tXP43gN1MMNnE2vMhILPa7IA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i+5JmAZFVBlyLFiPKsNhRRHtNfASnkpP+22x0jmN3K6iz3eR2stbDh8AcgKECn0kj
         rKCewi+tWpkk6Q7ASk+XBukDrgbld4CgFddvRvgH8DcfxF1BsfEMkuQGMI2hJGNxeB
         C0HyXbpyzHRBCEmH6qTVWGAhbm2psT8s8C82pSr3Eyvqm38lLMmsMph7dj8F9bcvd0
         J6Ozu9Lg1KFMOugAVCjw76PhKt73QsaSvR6I1FVaGpc5zzONF7FXQD2Oh+cRzBTP+O
         ki4D3OKFzm+pSDBPkLOrpGsxtGvv4tr8eCyh5eC0ijtxF6yXb0aSdb6e6ps90wE6Q4
         ZZ4CVllw8RZ5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2652160A22;
        Tue, 17 Aug 2021 15:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162921420515.3798.18086363830655260085.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 15:30:05 +0000
References: <20210816131405.24024-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20210816131405.24024-1-dinghao.liu@zju.edu.cn>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sony.chacko@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Aug 2021 21:14:04 +0800 you wrote:
> qlcnic_83xx_unlock_flash() is called on all paths after we call
> qlcnic_83xx_lock_flash(), except for one error path on failure
> of QLCRD32(), which may cause a deadlock. This bug is suggested
> by a static analysis tool, please advise.
> 
> Fixes: 81d0aeb0a4fff ("qlcnic: flash template based firmware reset recovery")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> 
> [...]

Here is the summary with links:
  - net: qlcnic: add missed unlock in qlcnic_83xx_flash_read32
    https://git.kernel.org/netdev/net/c/0a298d133893

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


