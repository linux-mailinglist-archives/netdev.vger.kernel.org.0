Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18257312052
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 23:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBFWkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 17:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhBFWks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 17:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CB7664E7B;
        Sat,  6 Feb 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612651208;
        bh=RgbzWY4E0e/ihRJLR7LKQqN/HwUdSYHHCuL+f6VcZZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OaeYdqUCFX4jH3gnpCELlj+GnsK0ZuBf2NXC8ZkSMohekfAl2qzBQK4phPeuCeoX6
         ogoVfBp4eek9RJ+l77y0ATQL8+74Zcn++M756gOXTREw8BcNFQDsKOAGO0WnVjim/t
         BBgOU4hWJAOIzDK7lf2uok8cSCI2hG+soahscmudseYvb9Zu6YnqYosVM6DLuBOUq0
         z4oLXC5MiHX/7Mgq86Jar8DcR8+A5HSuWxvoJ2+nB9mMgCrjYSpv8klbxsp0mGvUuG
         GhPaEBdIyeoMRu019dNobkYwjFNmjjKMhxrt5z3UCiNDuytTg+VC6zsFkPmdZTBAew
         /247FFRUXxGDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 138A6609F6;
        Sat,  6 Feb 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/6] net: hns3: updates for -nex
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265120807.6465.11965466344099394550.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 22:40:08 +0000
References: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1612513969-9278-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 5 Feb 2021 16:32:43 +0800 you wrote:
> This series adds some code optimizations and compatibility
> handlings for the HNS3 ethernet driver.
> 
> change log:
> V2: refactor #2 as Jukub Kicinski reported and remove the part
>     about RSS size which will not be different in different hw.
>     updates netdev->max_mtu as well in #4 reported by Jakub Kicinski.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/6] net: hns3: add api capability bits for firmware
    https://git.kernel.org/netdev/net-next/c/1cef42c8474f
  - [V2,net-next,2/6] net: hns3: RSS indirection table use device specification
    https://git.kernel.org/netdev/net-next/c/87ce161e8c67
  - [V2,net-next,3/6] net: hns3: optimize the code when update the tc info
    https://git.kernel.org/netdev/net-next/c/693e44157d31
  - [V2,net-next,4/6] net: hns3: add support for obtaining the maximum frame size
    https://git.kernel.org/netdev/net-next/c/e070c8b91ac1
  - [V2,net-next,5/6] net: hns3: debugfs add max tm rate specification print
    https://git.kernel.org/netdev/net-next/c/2783e77b8df9
  - [V2,net-next,6/6] net: hns3: replace macro of max qset number with specification
    https://git.kernel.org/netdev/net-next/c/3f094bd11a37

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


