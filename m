Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD83D3ED1A2
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhHPKKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhHPKKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:10:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 209A161B43;
        Mon, 16 Aug 2021 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629108605;
        bh=KJPNTC//0nL+YtlEMo8Zl6dCsMjS6QiZE7FS5Us2VI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QZdmMHyJgfy5gHsSCNGHM+stTZWeVm2PeREK2vu7LrqnML99fSK8AMfLgbBANBmGb
         5dYc2bCDd2/kVRBF7KXLYKcCNWxAlCio8UkeER5BT+6OfzU21xwxVZ92uBgoKwoLQv
         XkNylvBvSaboyJWfnoW2D9PQYR+CiEq00dXUmNxJfer4LVjFORMEhOVk5ZZdZDeTUB
         PTLWMXF1dnKUVGSGr5LPhPWWJmd61MuImkyNgodRxn875w3LVjFXQ0fqgCV/+IpMx9
         pU6ijXRWahV1Dsu0JODMelXv8OR2/KPA9zrL0O3zKy7suOvQx2QncybrwWGxqG2Zns
         w3Xg5ulbcymsA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1398960976;
        Mon, 16 Aug 2021 10:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: 6pack: fix slab-out-of-bounds in decode_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910860507.22499.6005898561031397786.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:10:05 +0000
References: <20210813151433.22493-1-paskripkin@gmail.com>
In-Reply-To: <20210813151433.22493-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ajk@comnets.uni-bremen.de, davem@davemloft.net, kuba@kernel.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 13 Aug 2021 18:14:33 +0300 you wrote:
> Syzbot reported slab-out-of bounds write in decode_data().
> The problem was in missing validation checks.
> 
> Syzbot's reproducer generated malicious input, which caused
> decode_data() to be called a lot in sixpack_decode(). Since
> rx_count_cooked is only 400 bytes and noone reported before,
> that 400 bytes is not enough, let's just check if input is malicious
> and complain about buffer overrun.
> 
> [...]

Here is the summary with links:
  - [v2] net: 6pack: fix slab-out-of-bounds in decode_data
    https://git.kernel.org/netdev/net/c/19d1532a1876

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


