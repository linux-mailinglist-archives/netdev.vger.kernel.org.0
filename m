Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C045A21B
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhKWMDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:03:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhKWMDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 43D7260FED;
        Tue, 23 Nov 2021 12:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637668808;
        bh=nr4HECRjw02V4P1yfS6Dd9pdGAD0xPrGbNNy2J023ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L52yFzT6iZaiQI/k9uYpSc9rLxuo3SNkE0DETzdzWiKC1F/Irg1QN2qMb1VUVelCx
         7EHauz+vDuTGIpSA4QQinBv1UKDDy8EYJa+OOLFRPYjioWe1ghAGZ+S1GEdDjrJn5R
         cVefC+RgJpvhqs4vq3PBADq/r39FwZgC+/WlvQXRJJYPle10jppZ/JCDCDQ/PBzQf1
         eoLdmDT0CwZLUcirV/1baLAAwmwMclP7i5ZO1NxZBknY1LwLPWEwPe2I+FouuWd92p
         6LiA3O81EYqKIwWheF1elIrKq1BjxNtIvJiNsOamsaWqK/LlPnE8isjMN4bcNgjWmv
         QkC4suP53vI7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3788560A4E;
        Tue, 23 Nov 2021 12:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] mctp: Add MCTP-over-serial transport binding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163766880822.32539.14789843706311733254.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:00:08 +0000
References: <20211123075046.3007559-1-jk@codeconstruct.com.au>
In-Reply-To: <20211123075046.3007559-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, jirislaby@kernel.org,
        gregkh@linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 15:50:46 +0800 you wrote:
> This change adds a MCTP Serial transport binding, as defined by DMTF
> specificiation DSP0253 - "MCTP Serial Transport Binding". This is
> implemented as a new serial line discipline, and can be attached to
> arbitrary tty devices.
> 
> From the Kconfig description:
> 
> [...]

Here is the summary with links:
  - [net-next,v3] mctp: Add MCTP-over-serial transport binding
    https://git.kernel.org/netdev/net-next/c/a0c2ccd9b5ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


