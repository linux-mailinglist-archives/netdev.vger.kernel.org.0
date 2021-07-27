Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9415D3D73E6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 13:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhG0LA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 07:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236169AbhG0LA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 07:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 474EB619E4;
        Tue, 27 Jul 2021 11:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627383629;
        bh=dln1luhyqHYmIpF6yF2+3oMx7a9rPKtnaD0tcwQW8Ks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mwTYNPzUoYx3ZAUn2ES2yZVSTEHf5jtjNgbNCwFbNPLffrrna8Ya3Fyhmub4goicF
         lj2HNBfvP6OL8gYCg7ruY5oW098HtVj8sPcnCFD4MG1AYbeZtpzzURLMtJrZ7e6f/H
         /8rW7p5JQ9gcJt0+0JMP9RgBaqt8J7YffP1dOAunWBw0jTGWSGjHD6HLz+FCkl4yW4
         g9vdumU6VSweSphULejC+Dk8BOlGofCfeeE3LyO3/ond/5GkdSgGdh8mLJQHV9LDvw
         4FuEdZGT+vTpvC/oLpirOMixEkk7/pKIOmC0veSO8JYtJoUQoczoBEDVABPuqmiNDO
         Rq9SKbI1pMH5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F30F609F7;
        Tue, 27 Jul 2021 11:00:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] openvswitch: per-cpu upcall patchwork issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738362825.18831.11702364143818289111.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 11:00:28 +0000
References: <20210723142414.55267-1-mark.d.gray@redhat.com>
In-Reply-To: <20210723142414.55267-1-mark.d.gray@redhat.com>
To:     Mark Gray <mark.d.gray@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 23 Jul 2021 10:24:11 -0400 you wrote:
> Some issues were raised by patchwork at:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210630095350.817785-1-mark.d.gray@redhat.com/#24285159
> 
> Mark Gray (3):
>   openvswitch: update kdoc OVS_DP_ATTR_PER_CPU_PIDS
>   openvswitch: fix alignment issues
>   openvswitch: fix sparse warning incorrect type
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] openvswitch: update kdoc OVS_DP_ATTR_PER_CPU_PIDS
    https://git.kernel.org/netdev/net-next/c/e4252cb66637
  - [net-next,2/3] openvswitch: fix alignment issues
    https://git.kernel.org/netdev/net-next/c/784dcfa56e04
  - [net-next,3/3] openvswitch: fix sparse warning incorrect type
    https://git.kernel.org/netdev/net-next/c/076999e46027

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


