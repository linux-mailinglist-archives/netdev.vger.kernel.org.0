Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345C5397C70
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbhFAWb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235035AbhFAWbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B9685613D5;
        Tue,  1 Jun 2021 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586604;
        bh=nspaTRIiWVKXf1O7EOFruq3z3D6wZdfgkCwHDr0hCfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mzZJ+UTz5nVlvVqOJ3UAksENeWWB600Jm3o2CTQjvuJRr9ljrK8phjpfTnvqp8uN1
         uCsLaPM3zWWU9BBuOF280pB3kmyE9AYtKNbuD8VrwmCK7n33WYp6cFJdldXSLWBFRu
         ajwWqaYuTdqAq6E6Kn5Sc/dJ9XTJRRHDuN8KUQ1qldREMOe/83XeOGAZySGnOTQnHo
         rFQdGy0U+Kx55uTlGhFO8qQSOFhSy9LHcXRMA6C6TwhXpWuIVG3MX3JW3GjVM+dnQY
         iaOdH9XxMag7nwmifg3nURycoaq2fg6sg4RmwEPn7dsQL/X0gZqgj8L6I2kblYYy2f
         46+Gn+2FqL24g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B151F60BFB;
        Tue,  1 Jun 2021 22:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: Remove the repeated declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258660472.12532.2091043036102699704.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:30:04 +0000
References: <1622530678-12911-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1622530678-12911-1-git-send-email-zhangshaokun@hisilicon.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     netdev@vger.kernel.org, shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 14:57:58 +0800 you wrote:
> Function 'qlcnic_82xx_hw_write_wx_2M' is declared twice, so remove the
> repeated declaration.
> 
> Cc: Shahed Shaikh <shshaikh@marvell.com>
> Cc: Manish Chopra <manishc@marvell.com>
> Cc: GR-Linux-NIC-Dev@marvell.com
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> [...]

Here is the summary with links:
  - qlcnic: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/68b8c55a701e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


