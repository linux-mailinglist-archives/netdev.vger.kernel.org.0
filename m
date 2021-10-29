Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A2E440015
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhJ2QMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhJ2QMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 12:12:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E042610EA;
        Fri, 29 Oct 2021 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635523812;
        bh=ILLsBsnJPVMWjVbPV54Y8QWxVd96XeyAwkndQq9HDGA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KTvaC7s61xC1RvU/Q4IAj+egBnyaswOuidomOwTtWouR4VOmMwRXPYbdvER7Cj2gb
         RMJI4FkXs6917zU/9RLCppRmEPY6/LGPADgJ7rcJL83y91eBzgr72zc1SlO5ZzV11z
         9gneeP71+f2KuBzocTbtClrCquC+zcSOSAZE+Vw/jMSN43lntO3hBbHpUuaOhGFMh/
         LrTT299E4Hx4UZbnSSsBx8lvt9WIwaFT+3oNrnXCUv64LUbN9ZuXpSGexbat6B8sVQ
         yai3RaeH0bMaf/5J0Q/eW/MwAxZRZOol6mfQkeoV6lMuCbpYyPk1RMfmaFe3WZwM+D
         mZNiYjAEeLrEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64A75609E8;
        Fri, 29 Oct 2021 16:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-10-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163552381240.29393.17076956367201637695.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 16:10:12 +0000
References: <20211029134707.DE2B0C4360D@smtp.codeaurora.org>
In-Reply-To: <20211029134707.DE2B0C4360D@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 29 Oct 2021 13:47:07 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-10-29
    https://git.kernel.org/netdev/net-next/c/28131d896d6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


