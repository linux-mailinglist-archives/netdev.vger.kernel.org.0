Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2625B437C14
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhJVRmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233890AbhJVRmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 693D16124D;
        Fri, 22 Oct 2021 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634924420;
        bh=xr13CsTU+hkw2yTPuJuqSK9WupxaQ5AwvfuboE7Urpg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YO5HoVNu2xW0irzZJUeSvt3wG9aEUceDE0CQ2Vo/+j2perqfgNpQ259cFzDXBssxv
         uuCNjCI1YcfzwaFkhUDmphqnTKGTZ7l72aREWek6gMTzEMmSqxAok3r3d6xAvVwewC
         g5oVB1wo6qKYMvGY0Nbo9kk90gwLBVlWUL9BLvHiOF0ATm3QTW97m8UKuA1tZC8b7l
         IaKqCiMPaQJ+FPf3//vhOYXJd23yqJ6r11tY6SUXdbdN3srqivf5K1gAbkR/Ko6dnA
         dzE8XKpEfOHNvtaH0G259wEAy6Npdt5V3/gyxsdciDkR3o1WxshEIDehUstlgDc/xV
         LLJJJ60gIrfiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 58EDF609E7;
        Fri, 22 Oct 2021 17:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-10-22
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163492442035.3618.7680388973441384759.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 17:40:20 +0000
References: <20211022075845.0E679C4360D@smtp.codeaurora.org>
In-Reply-To: <20211022075845.0E679C4360D@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Oct 2021 07:58:45 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-10-22
    https://git.kernel.org/netdev/net-next/c/d1a3f40951bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


