Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8439E783
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhFGTb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhFGTb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 15:31:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 45AA761001;
        Mon,  7 Jun 2021 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623094205;
        bh=3sagopUj06leVYoUH+D28TuuQSaYRDJfnHbpbQu5ku8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aJwuKTJ2d380qhLYeXIDxQtiV1zcEQmibYNVcWK1cG5MGBS3kQRJmQAzmxvxnxuff
         73HJVRai21v+quwBo8jPcLwVqhABSUJDwsCZrpxdx2sk25KMuRzkyEgz5eAW7ytfWS
         J2noqfGwiEfm4+0RzgwkDqrsNlXwztiXm0vAArczIp+cx2HbThU5zquTqTiUBY5XXE
         YLtwVBWHFHL7CK7X40OZ+clsM4SaF8wBiVpCKJFu8vNtWskqcOqhIL8eycfzJULXOV
         9a1MsTuSHdrXxrLJlg+E5BRnmEhEEn5fPC6eLT6sQS85ktV23itebHH36DbFXPyo+x
         chB8O8qyDX+DA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 32BE5609B6;
        Mon,  7 Jun 2021 19:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: hd64570: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309420520.18633.13931402276245581467.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 19:30:05 +0000
References: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1622876429-47278-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 5 Jun 2021 15:00:21 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (8):
>   net: hd64570: remove redundant blank lines
>   net: hd64570: add blank line after declarations
>   net: hd64570: fix the code style issue about "foo* bar"
>   net: hd64570: fix the code style issue about trailing statements
>   net: hd64570: add braces {} to all arms of the statement
>   net: hd64570: fix the comments style issue
>   net: hd64570: remove redundant parentheses
>   net: hd64570: add some required spaces
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: hd64570: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/725637a802c5
  - [net-next,2/8] net: hd64570: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/d364c0a93ac6
  - [net-next,3/8] net: hd64570: fix the code style issue about "foo* bar"
    https://git.kernel.org/netdev/net-next/c/1d1fa598ac19
  - [net-next,4/8] net: hd64570: fix the code style issue about trailing statements
    https://git.kernel.org/netdev/net-next/c/bc94e642e4bd
  - [net-next,5/8] net: hd64570: add braces {} to all arms of the statement
    https://git.kernel.org/netdev/net-next/c/3f8b8db695fe
  - [net-next,6/8] net: hd64570: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/53da5342c51a
  - [net-next,7/8] net: hd64570: remove redundant parentheses
    https://git.kernel.org/netdev/net-next/c/cb625e9c5d48
  - [net-next,8/8] net: hd64570: add some required spaces
    https://git.kernel.org/netdev/net-next/c/0f1e7a34c053

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


