Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377473F8B55
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242981AbhHZPuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhHZPuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 11:50:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B58336101A;
        Thu, 26 Aug 2021 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629993007;
        bh=0zM90CvcDSH6UFy9c0wnLu9bNk+B4Qha+Kf+kRBIj+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tGtb3FErX/2LiBcuWjotgVCE1UWTTD6GJlDiwjT3X3O+OpZP5ciNtGs4JeKpJMp38
         REaxdVuTKTQhXulkw+ZbV2rOZOqPtLFV0la1GsZXyKioFy79NZFd2+2g9+2EYsffTd
         c9xLAbovx7CRZ3mpDEuO39sZwlBf2UWxX6CBksMHtDgdvaxgha9tdo+w+IEjhApTJR
         oWghdQydkP8HrvHnaU08TbqEv5C/Zn/en+SEdzICkfgZXHF56d+w5gT39P6+ZNXPQo
         aFuIUnQjLSpntsihGI8yPUqyue09sxWlPn4YlArYdU9w62Kp6sowF0sP2NfdGsIT5f
         aazCv5kXUjIfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A70F160A14;
        Thu, 26 Aug 2021 15:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162999300767.24975.1201669661390166290.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 15:50:07 +0000
References: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Aug 2021 19:21:54 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (1):
>   net: hns3: fix get wrong pfc_en when query PFC configuration
> 
> Guojia Liao (1):
>   net: hns3: fix duplicate node in VLAN list
> 
> [...]

Here is the summary with links:
  - [net,1/7] net: hns3: clear hardware resource when loading driver
    https://git.kernel.org/netdev/net/c/1a6d281946c3
  - [net,2/7] net: hns3: add waiting time before cmdq memory is released
    https://git.kernel.org/netdev/net/c/a96d9330b02a
  - [net,3/7] net: hns3: fix speed unknown issue in bond 4
    https://git.kernel.org/netdev/net/c/b15c072a9f4a
  - [net,4/7] net: hns3: fix duplicate node in VLAN list
    https://git.kernel.org/netdev/net/c/94391fae82f7
  - [net,5/7] net: hns3: change the method of getting cmd index in debugfs
    https://git.kernel.org/netdev/net/c/55649d56541b
  - [net,6/7] net: hns3: fix GRO configuration error after reset
    https://git.kernel.org/netdev/net/c/3462207d2d68
  - [net,7/7] net: hns3: fix get wrong pfc_en when query PFC configuration
    https://git.kernel.org/netdev/net/c/8c1671e0d13d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


