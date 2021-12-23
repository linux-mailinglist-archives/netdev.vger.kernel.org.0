Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C6847E778
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349709AbhLWSKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349687AbhLWSKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:10:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B152AC061401;
        Thu, 23 Dec 2021 10:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40C7961F37;
        Thu, 23 Dec 2021 18:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A8C3C36AEA;
        Thu, 23 Dec 2021 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640283010;
        bh=5N12wpUVVlUF+lgYrmW85trx2vz1plPgCZ17M9hBlF0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m8wbiZ2iB3C0TxqspSIROhr/uw60kJJSQk86jsOhiw9t1tpj26HsRKlWJ1bkz/m6a
         XZjW4oDBNROHPVprfec0dxIrMj+9Ofx1G2SfeD/N0NQ51e6xnCTYRyTw+GgZe8GQlW
         F32o3aEmdbX+4Z3Ma9H21piPjG8BmpSb13rI2eghuLgKc+sYenEv9EqNUSW7fs+St1
         F8CehYXEwwKDkxB5LHbKrZwxABeR+/6Yz1ZCds21Qpq2Nu/mZP5wdIHD/lzrAT9Dx6
         fyjkcr4HIKHDM74u0kYmktLmohlnSYdAoRk/DwHxnGZ/VDsAepmhvx7fFQDRy+Q+1R
         hy/YqBq+sFZBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 630DDEAC060;
        Thu, 23 Dec 2021 18:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] r8152: fix bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164028301040.27483.12308120575205386465.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 18:10:10 +0000
References: <20211223092702.23841-386-nic_swsd@realtek.com>
In-Reply-To: <20211223092702.23841-386-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Dec 2021 17:27:00 +0800 you wrote:
> Patch #1 fix the issue of force speed mode for RTL8156.
> Patch #2 fix the issue of unexpected ocp_base.
> 
> Hayes Wang (2):
>   r8152: fix the force speed doesn't work for RTL8156
>   r8152: sync ocp base
> 
> [...]

Here is the summary with links:
  - [net,1/2] r8152: fix the force speed doesn't work for RTL8156
    https://git.kernel.org/netdev/net/c/45bf944e6703
  - [net,2/2] r8152: sync ocp base
    https://git.kernel.org/netdev/net/c/b24edca30953

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


