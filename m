Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DD744D612
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhKKLxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:43840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232203AbhKKLw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 06:52:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E06416124C;
        Thu, 11 Nov 2021 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636631406;
        bh=iwvWkDttwj+rT/pMM/v72GU6PUXblg7nkNSX5ZvBZhg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R6ixwzBoH4Wi0o3bI2isg5cMkWeS8CHodOx7WZAgIM9L6GoNymm16Pl8ulDqlMMjz
         2cWdL3O6aphwKXlqZalxTLfM8/V1fQRVHz00RBm6BpSfXl2mgz+6UM/E6UkMQSTwCO
         6G9wWN6Opk9vPQ/ZLjtoi3Ay9+T9dxGzYXDsvMMP3JCFsqxYB3/QvoEBXNeOg24JFW
         NyEVA3bxAmkSdrs8Ev+ffaazyOpjy95GOJUQ/0An+W5u4sRJGToDZXHDqMLJKCjMmr
         6aOFHJ/dTZLcztyIGcLooyG/WG20v/MPbV+GWH9RgGQ3EX825t8Tp0IBeZOV0MV4J+
         OtSOFfoQ9KT8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D4A3C608FE;
        Thu, 11 Nov 2021 11:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: fix eeprom len when diagnostics not implemented
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163663140686.22701.6179511751968953563.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Nov 2021 11:50:06 +0000
References: <1636626316-27997-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1636626316-27997-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        manojmalviya@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 Nov 2021 15:55:16 +0530 you wrote:
> Ensure diagnostics monitoring support is implemented for the SFF 8472
> compliant port module and set the correct length for ethtool port
> module eeprom read.
> 
> Fixes: f56ec6766dcf ("cxgb4: Add support for ethtool i2c dump")
> Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: fix eeprom len when diagnostics not implemented
    https://git.kernel.org/netdev/net/c/4ca110bf8d9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


