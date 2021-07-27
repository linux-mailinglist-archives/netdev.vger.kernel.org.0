Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774C23D7EB9
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhG0UAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhG0UAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 16:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F39960F9D;
        Tue, 27 Jul 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627416005;
        bh=ciYTRdrg4jx2nzOWGGg2c6/yepR45rxpIOLE5MTZb5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fu6YJCZ0c++8KADmfPgHd5WdnWkYLb/Rba+GW04LnvNMxKcijNnh59G6+ymiTkkxQ
         7SYSCBaKRwymRsmYKlO/wUyeoHFkbVsCPnO3i6vFFuKshmYfzp0I206c0xpHngsZQX
         bFA2PZqghBKrIwaKJ+29fb8V61JmmXgOnPsI51q/n7VMr4s4u0BibkeiZNSDQeQPCX
         ssxhmq24rcTeAGiHhLy9q0NecbRhN+3bcxmeO0tabLSpYxKNeH33rp1GAORKV1RoLM
         095rdt97m8HTmHv8rCM2mSzx6nNmHazViv4pR2QH2PRBdWVM3YmrTX3oXueKNViilj
         HFSpR4mmAvgPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6171260A59;
        Tue, 27 Jul 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hns3: change the method of obtaining default ptp
 cycle
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162741600539.17427.1739579564596993103.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 20:00:05 +0000
References: <1627394630-33067-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1627394630-33067-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 27 Jul 2021 22:03:50 +0800 you wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> The ptp cycle is related to the hardware, so it may cause compatibility
> issues if a fixed value is used in driver. Therefore, the method of
> obtaining this value is changed to read from the register rather than
> use a fixed value in driver.
> 
> [...]

Here is the summary with links:
  - [net] net: hns3: change the method of obtaining default ptp cycle
    https://git.kernel.org/netdev/net/c/8373cd38a888

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


