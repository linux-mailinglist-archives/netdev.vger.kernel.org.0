Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6802FCAF5
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbhATGOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:14:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727681AbhATGKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 01:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E051A23158;
        Wed, 20 Jan 2021 06:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611123008;
        bh=oG/jzzzUs/lJ9JubbJ0uBHuqCgWajZxCe2w3uNMkur4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JEetTJljQogx5rITdbdJ6tE/b5ici8w25Y6esXwhakIQBz4l9psB0XTDspHbCTSrp
         4GYD8mHqa25NvT0MLbTtUGKoY1ko9VmId8wShGYXnkAD615ZAWZwTyPlvE406i0xa5
         aXxnQugndRuiKd4Y/6UzLmRosQtJRRVpjDe17/y8Ijv/EFiJE/iYpFI74ro+Q+1ive
         ug94019ypwxG7G0mas0/BOFVZc/oqRwJlm5Z5Hy2gy4yFLhhhgb/CUPDHA4TMEmoUv
         FVy+eg1LgExxUcGLq24EWeXfNGqKaZ7hRSULOyf6mLrHwoudoLx7CgelubElLc9aOg
         UvPKc38msbGRw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D907260591;
        Wed, 20 Jan 2021 06:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] bonding: add a vlan+srcmac tx hashing option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161112300888.30718.6036824083040046684.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 06:10:08 +0000
References: <20210119010927.1191922-1-jarod@redhat.com>
In-Reply-To: <20210119010927.1191922-1-jarod@redhat.com>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, tadavis@lbl.gov, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 18 Jan 2021 20:09:27 -0500 you wrote:
> This comes from an end-user request, where they're running multiple VMs on
> hosts with bonded interfaces connected to some interest switch topologies,
> where 802.3ad isn't an option. They're currently running a proprietary
> solution that effectively achieves load-balancing of VMs and bandwidth
> utilization improvements with a similar form of transmission algorithm.
> 
> Basically, each VM has it's own vlan, so it always sends its traffic out
> the same interface, unless that interface fails. Traffic gets split
> between the interfaces, maintaining a consistent path, with failover still
> available if an interface goes down.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] bonding: add a vlan+srcmac tx hashing option
    https://git.kernel.org/netdev/net-next/c/7b8fc0103bb5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


