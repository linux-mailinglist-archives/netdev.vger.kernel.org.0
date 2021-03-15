Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A1C33C711
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhCOTuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232636AbhCOTuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E775164E83;
        Mon, 15 Mar 2021 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615837807;
        bh=4fLlPm/9VSsPMLZa2tMwINUvecz8rvqjBO2aQ2Zn618=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Woj83wKwgIcLFBKBuF3SZdfj+BrPnT0WS5FCaRGlHG7SQFsCiGpfCCGMcsKv47jNl
         zOYYfO2SH8b36nTiNEbj5vhNP0EfyIGbjgVAgv+kCCMxMEBN70JDutiRXb1QVj/bnK
         /VsUIF9aPne3RTqhw8/Moz8KndogK4a3+y7c3RuMYZxUA77nZqB+3/XIhFCcKU6kzi
         WrjGhyeZ3e/xkHc2Vg37uY0+NhZBqrUeiHmBjvroEYqXH2R8Gjll3Mqedd/BaaNPd1
         HK/hoD9zRPI7QlrGIuPiJy9GkG6iEvJrHSJzRA4bVyIAiv9YgsZXEatvfOdkEd5sJy
         tapWDXGa9pAgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D387B60A19;
        Mon, 15 Mar 2021 19:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] bonding: Added -ENODEV interpret for slaves
 option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161583780786.26940.3627083522237017380.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 19:50:07 +0000
References: <20210314145629.376155-1-Jianlin.Lv@arm.com>
In-Reply-To: <20210314145629.376155-1-Jianlin.Lv@arm.com>
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, iecedge@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Mar 2021 22:56:29 +0800 you wrote:
> When the incorrect interface name is stored in the slaves/active_slave
> option of the bonding sysfs, the kernel does not record the log that
> interface does not exist.
> 
> This patch adds a log for -ENODEV error, which will facilitate users to
> figure out such issue.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] bonding: Added -ENODEV interpret for slaves option
    https://git.kernel.org/netdev/net-next/c/acdff0df5426

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


