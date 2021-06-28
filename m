Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44563B6A74
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 23:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbhF1Vch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 17:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233738AbhF1Vca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 17:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C70BC61D03;
        Mon, 28 Jun 2021 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624915804;
        bh=RlKn/uG7il2czF/tL/EHur48GxSLDTEhkqSDFuK0Vjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fy/Z8F2NBaJoXfkn2d79e7FVLcKZkzMzyNYCL5cVGUXzrDDgYXRNlbB688ksa70tJ
         wxb6SLgwqFxY2HPOzscl+UMA8sP314/DLkPvKiW/9Tr64d/iQB/nLxBbbb/kI4H+3k
         4gahpyPD8oPfGtpcETfxfnR+zK2shTdPNXi/QVr607dlbEzI/azJ/e9FmuZcF+rfYP
         0SCckddawNDi6ZmNOyzHhFP0SUyC2bs6hIOIhP8YkIND/FuP0qKsk1aXMyITDJPqEW
         uZTaErDdhUSEnDsMMYVdSq0FHxt33rC3smAOkdg00nhPLHTOLLw7lX78EX2N6P3nui
         /06CuvrOmIdyg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C218F60A38;
        Mon, 28 Jun 2021 21:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] fix some bugs for sparx5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491580479.14567.15798437034527401265.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 21:30:04 +0000
References: <20210626044420.390517-1-yangyingliang@huawei.com>
In-Reply-To: <20210626044420.390517-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 26 Jun 2021 12:44:17 +0800 you wrote:
> Yang Yingliang (3):
>   net: sparx5: check return value after calling platform_get_resource()
>   net: sparx5: fix return value check in sparx5_create_targets()
>   net: sparx5: fix error return code in
>     sparx5_register_notifier_blocks()
> 
>  drivers/net/ethernet/microchip/sparx5/sparx5_main.c      | 8 ++++++--
>  drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c | 4 +++-
>  2 files changed, 9 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next,1/3] net: sparx5: check return value after calling platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/f00af5cc58ec
  - [net-next,2/3] net: sparx5: fix return value check in sparx5_create_targets()
    https://git.kernel.org/netdev/net-next/c/8f4c38f75886
  - [net-next,3/3] net: sparx5: fix error return code in sparx5_register_notifier_blocks()
    https://git.kernel.org/netdev/net-next/c/83300c69e797

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


