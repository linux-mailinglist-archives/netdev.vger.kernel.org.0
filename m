Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6D45A265
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhKWMXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236330AbhKWMXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 250BD6102A;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670010;
        bh=zk11vT96epiJrJTPz0wjAtBZspT5XGV1ZsRstwHNCoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OLLQ1Dc8672i7XZAG/BlxJIk6QUFoyW4gwvxELn4THfz+xbsxtWCW1sZ5NZdKfNXt
         Yzp20/lOgTqzTuH2nAHmlx0qM06/+7On585G0P0rKEJrUHkGYRPA8ZOMQvIN8t5FXH
         cIQmjrNcB1r/dbz+LKaBF/T1f/16AUZ4b9cKGHmEQCjufimgjZvz4GgobS4CQlgnDB
         VklJ1z9XOpEZEG89KuSxEyizCRWyC7E6iENsHTq0Td/JGNxPnb5AwJduVR+CGjOVJl
         FvScfCHZ7+ZRDptzx8s5BhtPOJ3ubKXU4IpPPSkiqWYgQdw4BUU6g8o0HuFsgAAjjt
         0q4LM+z9/4QFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1907660A50;
        Tue, 23 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8169: fix incorrect mac address assignment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001009.10565.6139299625581122434.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:10 +0000
References: <1100ed0d-7618-f6d6-d762-4c0c6ae6ef40@gmail.com>
In-Reply-To: <1100ed0d-7618-f6d6-d762-4c0c6ae6ef40@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, rherbert@sympatico.ca
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 22:35:33 +0100 you wrote:
> The original changes brakes MAC address assignment on older chip
> versions (see bug report [0]), and it brakes random MAC assignment.
> 
> is_valid_ether_addr() requires that its argument is word-aligned.
> Add the missing alignment to array mac_addr.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=215087
> 
> [...]

Here is the summary with links:
  - [net] r8169: fix incorrect mac address assignment
    https://git.kernel.org/netdev/net/c/c75a9ad43691

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


