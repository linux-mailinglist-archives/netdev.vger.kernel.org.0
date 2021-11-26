Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA4E45E711
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 06:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343688AbhKZFPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 00:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344345AbhKZFNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 00:13:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BD19A61108;
        Fri, 26 Nov 2021 05:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637903409;
        bh=E8I0BPIDEcn4uiGqzxgU6s+MbkGHUnSJW+y3XuqBmO0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ICuUTZax5BoF+2YqxeZKta6Bed0uiBzQlnjBS/hiXjgtIagdpZgiVrBbfyjzsUS+g
         4tRdLzRxOdrZ3yHIyuJsXS+2RKMllWAESg1lHm+nlcIabA3rQ9S6d5MzW7ojKS6B4k
         rQ0GyomUEVtox9wZYCXqGx/gHfJkew2fO8fYKpV7V79MlcnkFdxm3gwlupkhEjKfMx
         hIO3mMe8FZVB+XGUqOju+ZnRwO0i/kPkJBho+wHFB8mjZKkNqwh1aTXWSouXabJ5ls
         XKdPafjQHEAdafh0li3dR89U1ysFOHPZjEyirqed42IgX765DNJthCO9tb/gjJXqyt
         F9BEOhyVvpqTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A8E4260A94;
        Fri, 26 Nov 2021 05:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sctp: make the raise timer more simple and accurate
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163790340968.15462.14345290049579895433.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Nov 2021 05:10:09 +0000
References: <edb0e48988ea85997488478b705b11ddc1ba724a.1637781974.git.lucien.xin@gmail.com>
In-Reply-To: <edb0e48988ea85997488478b705b11ddc1ba724a.1637781974.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 14:26:14 -0500 you wrote:
> Currently, the probe timer is reused as the raise timer when PLPMTUD is in
> the Search Complete state. raise_count was introduced to count how many
> times the probe timer has timed out. When raise_count reaches to 30, the
> raise timer handler will be triggered.
> 
> During the whole processing above, the timer keeps timing out every probe_
> interval. It is a waste for the Search Complete state, as the raise timer
> only needs to time out after 30 * probe_interval.
> 
> [...]

Here is the summary with links:
  - [net-next] sctp: make the raise timer more simple and accurate
    https://git.kernel.org/netdev/net-next/c/703319094c9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


