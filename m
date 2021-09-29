Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8241F41C251
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245341AbhI2KLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245330AbhI2KLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 21F4D613DA;
        Wed, 29 Sep 2021 10:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632910208;
        bh=QU88gdxAQKxhHUQXF5N7ud55cYRdrIC2ho+vk3rpsJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DBNF8100Qc+lpmA0Jzxfg0ii47GdYcxkETVhmRFZ/aUTXZgHw6kfAtwozCBjBBszc
         B1P+slHLbXO4XYz6smr6/dYazbdcTG2O+EuCHxSpgps9CuyppiZdJv8pactJOVzVZs
         RP59WyJdWfGwNjxodYulr7SMDBDuMChTYOW3RUu7q3IemM3kG3UziXJ9F/eRFFJUgl
         CVgXbgwixuci5MnBh0VYJFtoBY9H0k0oTPoE9mZB35+2o9hdl//x94O1VouumbnwYo
         16+hXgqv6J3EyeRKn6Ly6xKjkN19oPuBClHQhyN0yWU2o3aTVagTfOOSLPU1z+vkrF
         dzjhHCzBrK4FQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 110D3609D6;
        Wed, 29 Sep 2021 10:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/8] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291020806.13642.6595140708181277709.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:10:08 +0000
References: <20210929093556.9146-1-huangguangbin2@huawei.com>
In-Reply-To: <20210929093556.9146-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 29 Sep 2021 17:35:48 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (3):
>   net: hns3: PF enable promisc for VF when mac table is overflow
>   net: hns3: fix always enable rx vlan filter problem after selftest
>   net: hns3: disable firmware compatible features when uninstall PF
> 
> [...]

Here is the summary with links:
  - [net,1/8] net: hns3: do not allow call hns3_nic_net_open repeatedly
    https://git.kernel.org/netdev/net/c/5b09e88e1bf7
  - [net,2/8] net: hns3: remove tc enable checking
    https://git.kernel.org/netdev/net/c/a8e76fefe3de
  - [net,3/8] net: hns3: don't rollback when destroy mqprio fail
    https://git.kernel.org/netdev/net/c/d82650be60ee
  - [net,4/8] net: hns3: fix mixed flag HCLGE_FLAG_MQPRIO_ENABLE and HCLGE_FLAG_DCB_ENABLE
    https://git.kernel.org/netdev/net/c/0472e95ffeac
  - [net,5/8] net: hns3: fix show wrong state when add existing uc mac address
    https://git.kernel.org/netdev/net/c/108b3c7810e1
  - [net,6/8] net: hns3: PF enable promisc for VF when mac table is overflow
    https://git.kernel.org/netdev/net/c/276e60421668
  - [net,7/8] net: hns3: fix always enable rx vlan filter problem after selftest
    https://git.kernel.org/netdev/net/c/27bf4af69fcb
  - [net,8/8] net: hns3: disable firmware compatible features when uninstall PF
    https://git.kernel.org/netdev/net/c/0178839ccca3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


