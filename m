Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD0533A260
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 03:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhCNCUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 21:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhCNCUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 21:20:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 42EB364EDC;
        Sun, 14 Mar 2021 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615688408;
        bh=cOrJ3vT/h3Tqe2QiGMyNJZpP6NzkaPnk6cc8QItWG6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pcB8oKvZyUsWigGiGuaQY7gn6/Rg+oaRDtRcPwvv7wadUehKaOwE1pdkXxXM2P/J+
         ybIrQxFVM0VU0UwQ1Kgr7KAP6K70dOvXvaULA2uo3wAI8zI/+bfWSAZWtUE2gczM3B
         doc2gEZQ0JxvDk646vGS66IslEAku7M6x+MzmNKE7+jWEP1sQCZDdpd9j99iEWUs2Q
         ewjBIK9bp1hGy2mEfUWEcNNQl4/T+raOiR45CWTem71P8+ItrDfaSBlRha28BbVAgt
         9ZeIoXYAbhVVhYJJCBrjk6pMXBeTs1YSgKXRkfpBdn4en79zbpxzr7yiYIU25WN0Tt
         gs16eeJ+A9ofQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3E2A060A2D;
        Sun, 14 Mar 2021 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] docs: net: tweak devlink health documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161568840825.14251.18192827532284166181.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 02:20:08 +0000
References: <20210313003026.1685290-1-kuba@kernel.org>
In-Reply-To: <20210313003026.1685290-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ayal@mellanox.com,
        eranbe@nvidia.com, jiri@nvidia.com, linux-doc@vger.kernel.org,
        jacob.e.keller@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Mar 2021 16:30:25 -0800 you wrote:
> Minor tweaks and improvement of wording about the diagnose callback.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/devlink/devlink-health.rst | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Here is the summary with links:
  - [net,1/2] docs: net: tweak devlink health documentation
    https://git.kernel.org/netdev/net-next/c/3cc9b29ac0e1
  - [net,2/2] docs: net: add missing devlink health cmd - trigger
    https://git.kernel.org/netdev/net-next/c/6f1629093399

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


