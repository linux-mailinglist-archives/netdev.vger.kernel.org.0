Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE9A45D27C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347468AbhKYBpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346042AbhKYBnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:43:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BE27760C51;
        Thu, 25 Nov 2021 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637804408;
        bh=0fOleD3+YwP5Y6nCZxuAXHaRTkzFUqQnbM8Hfvm957w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QFR6shp79HlGjIBqiP6eLWRpkFAjP6XrVQ1F9/Gs392NFxKMo1JtTc4mLuvTq7qkU
         sUFa3j2g7gf9iyrF17RZ9MJ7QsS9ZwALuH31s7c9KgcYqFDhT/93FgNjgQPcRiszMq
         ZLaHnOJ8azmoCBCA/2wlBLx3cH3NbEgNJxSsu/5vGjb20nS171dTiHCiGLO7BMco1n
         LR5js5Z9+ET8BRSbMhhTkPdC84HqXWKN7Qq3dbt3RLHvZgmEFIQoaVz5Bti2U1dEig
         twS2flXGuaYbAVPkeEyE56RN06dGtjn18iYottvd+t1kraQ6kA3W/Hew2ZNx8ftXHP
         IHucOJYGE/zRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AF05260A4E;
        Thu, 25 Nov 2021 01:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] cxgb4: allow reading unrecognized port module eeprom
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780440871.8890.12388234909454693211.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:40:08 +0000
References: <1637682437-31407-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1637682437-31407-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        manojmalviya@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 21:17:17 +0530 you wrote:
> Even if firmware fails to recognize the plugged-in port module type,
> allow reading port module EEPROM anyway. This helps in obtaining
> necessary diagnostics information for debugging and analysis.
> 
> Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net-next] cxgb4: allow reading unrecognized port module eeprom
    https://git.kernel.org/netdev/net-next/c/e670e1e86beb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


