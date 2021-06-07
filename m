Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4C739E8E9
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhFGVMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230396AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C299061260;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=qJ9K1hHX5a0KRnFaBz01g1rGPO9bNGCMJVKbrNQle4I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bQ5DeNKaLeK93Q+W0Juu3OonQcMMX04uRY5cA4ds4EnJMwvmGRH8xKkEtfbqFTBFX
         P8NwUGXT2ILMC1vtGlTR8PFoKAqUnToCL52DN8hT2xigKqgUaL8QBoWSBjQvQUT9HK
         3TEid8wL7FK2Fan1HGM8bxtjTZUbWx6r+flIKsgZCG9tKtk3LpGwdXw11AUIpptECk
         Hl80YZSCRzpmdiVvDblHF7p41RdooFvlyKttFCxSqcYIz194YB3PBgtOJxi+jbASO0
         WCr9O6B8DYwVzhCkPtbTWzaWmxp7+nzjLT4cRGetJ70V9xNxyDZAlG4V10OMaOunFy
         UIFgWe0v2nZYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B52BA60CE0;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: hns3: refactors and decouples the error
 handling logic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020573.31357.15915358497567352210.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <1623064692-24205-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623064692-24205-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 19:18:09 +0800 you wrote:
> This patchset refactors and decouples the error handling logic from reset
> logic, it is the preset patch of the RAS feature. It mainly implements the
> function that reset logic remains independent of the error handling logic,
> this will ensure that common misellaneous MSI-X interrupt are re-enabled
> quickly.
> 
> Jiaran Zhang (2):
>   net: hns3: add a separate error handling task
>   net: hns3: add scheduling logic for error handling task
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: hns3: add a separate error handling task
    https://git.kernel.org/netdev/net-next/c/d991452dd790
  - [net-next,2/3] net: hns3: add scheduling logic for error handling task
    https://git.kernel.org/netdev/net-next/c/aff399a638da
  - [net-next,3/3] net: hns3: remove now redundant logic related to HNAE3_UNKNOWN_RESET
    https://git.kernel.org/netdev/net-next/c/e0fe0a38371b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


