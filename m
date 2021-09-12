Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350D0408194
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 22:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhILUlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 16:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231560AbhILUlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 16:41:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02BA460EE7;
        Sun, 12 Sep 2021 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631479206;
        bh=n3JpqVSXz8AU9zovjmWDqHMs1PKcjnwuSKxVZC5xKhc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O5FTMBWqcF6vcLER22in8/jNPxU05BRNsluboAmz8JGkH8UF7MZU9McEh3HhtnO5t
         6fFEPn25N1xClWvmMf6XKR4FGLGIB88I9wkSVpXEGof4Sd0feTFbxoR4zxm2Gg2e+u
         rIkZznjUD2GGyAiUp9WC9Xv/ypO99/HylkxXlBcEVFG3Wk3eKC8VW1sh+fbktC4tp0
         iLOpn9L5nsDM22UJoXaxcSsrG4CGMvurAAS3rE7Jo3bbFiM8sWu6Xp4kgfg60AkwOr
         znNvY/v1V3eS55yaoflT0WgcWT9jj8SbehSNeP01m6Ntk4Rz+YL/D/A8YUCmzUS+3G
         8FiXLC47rcZ5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E6349609ED;
        Sun, 12 Sep 2021 20:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 ethtool-next] netlink: settings: add netlink support for
 coalesce cqe mode parameter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163147920593.4586.11164318755712068396.git-patchwork-notify@kernel.org>
Date:   Sun, 12 Sep 2021 20:40:05 +0000
References: <1630290953-52439-1-git-send-email-moyufeng@huawei.com>
In-Reply-To: <1630290953-52439-1-git-send-email-moyufeng@huawei.com>
To:     moyufeng <moyufeng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mkubecek@suse.cz,
        amitc@mellanox.com, idosch@idosch.org, andrew@lunn.ch,
        o.rempel@pengutronix.de, f.fainelli@gmail.com,
        jacob.e.keller@intel.com, mlxsw@mellanox.com,
        netdev@vger.kernel.org, lipeng321@huawei.com, linuxarm@huawei.com,
        linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (refs/heads/next):

On Mon, 30 Aug 2021 10:35:53 +0800 you wrote:
> Add support for "ethtool -C <dev> cqe-mode-rx/cqe-mode-tx on/off"
> for setting coalesce cqe mode.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> ---
> ChangeLogs:
> V1 -> V2:
>          1. update the man page for new paremeters cqe-mode-rx/cqe-mode-tx.
>          2. add '\n' in coalesce_reply_cb() after showing new paremeters.
> 
> [...]

Here is the summary with links:
  - [V2,ethtool-next] netlink: settings: add netlink support for coalesce cqe mode parameter
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=ecfb7302cfe6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


