Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C228C3F4977
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhHWLLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236322AbhHWLK6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 07:10:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C269613A8;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629717015;
        bh=wWJ93gQaLSEhT/UQhrXBCpBAbGOFf6rz+8BYoB2f5bc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EXv6NOZd1JeknyLfoKXZsJXfT4SyeLng26gVQqLYB92fCDzCxlzVoqVBPQl5RySX6
         2HhYFF7YacEr1iCr+hEEpe3aG3eZvch4HuT21aWATBdGXwJFlrV6Bj5BjvlLwp7wpi
         tLvUPYJJzzEwb9OhYp3uOnjbb+neg/ibkKWwOw0hxfrOrYhkEhM1LXz/hSz6Fis3Ni
         0FQWn8xRx35Em0OOxd4ly0T45Yu62Sw5k8DIdy+mAKWrcURwr9xXmXRs6r0C0Yy/PY
         t2EvSx8rdw2XYfhHEv8syFcuvDnwi02rEUo+DU9L7+prX0T0iOsAsuAFYS/XfZ6XFX
         3LMlvOlJDKyHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7402360A14;
        Mon, 23 Aug 2021 11:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sunhme: Remove unused macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162971701547.8269.3612332439322831949.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Aug 2021 11:10:15 +0000
References: <2afbd92d52cc58c5b91d95782d144194ce1a5669.1629621681.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <2afbd92d52cc58c5b91d95782d144194ce1a5669.1629621681.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     tanghui20@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 10:42:21 +0200 you wrote:
> The usage of these macros has been removed in commit db1a8611c873
> ("sunhme: Convert to pure OF driver."). So they can be removed.
> 
> This simplifies code and helps for removing the wrappers in
> include/linux/pci-dma-compat.h.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: sunhme: Remove unused macros
    https://git.kernel.org/netdev/net-next/c/056b29ae071b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


