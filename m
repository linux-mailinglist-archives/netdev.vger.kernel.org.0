Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FD040DB7C
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240312AbhIPNlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240252AbhIPNl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CE9961212;
        Thu, 16 Sep 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631799608;
        bh=rJpWAvWJGrZjF5cqGJ1sN0iaI/MsXiR02m8bJut01qs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KjEMgY60dDwLYL6rl6sRJhyfuy9cEZi16FII/mZfCEQLVWImUb2shGYfzPoSuDXvs
         WcZ18chsli8ZNf7pyTnGXUthFFXzg7leERY4S3TGarf9cGmhbLrqwy5/I+Z9UYu8CS
         xYn2D2MffGqt8anwaWi8rtD2R86PlRbTvMB76jkqe3mfXyHCvtd/NHKsJoMGTsAbd0
         G9t2kwIJMWRZ0OaNGejqDJDjT8hbwdHbV8GmiKHgCCwRPmrDTkS9SusLMMtjiCAZ+t
         xXl0KlHRjqOxnYuc5NkbXM4UJB8rJpzMd1wmsSN3coF1krF7golhdMqlG9FeklCSg3
         thSiXA2HXx0CQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56F5960A22;
        Thu, 16 Sep 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: wwan: iosm: firmware flashing and
 coredump collection"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179960835.17264.14741744743525904152.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:40:08 +0000
References: <20210915215823.11584-1-kuba@kernel.org>
In-Reply-To: <20210915215823.11584-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        m.chetan.kumar@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 14:58:23 -0700 you wrote:
> The devlink parameters are not the right mechanism to pass
> extra parameters to device flashing. The params added are
> also undocumented.
> 
> This reverts commit 13bb8429ca98 ("net: wwan: iosm: firmware
> flashing and coredump collection").
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: wwan: iosm: firmware flashing and coredump collection"
    https://git.kernel.org/netdev/net-next/c/d1ab2647de32

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


