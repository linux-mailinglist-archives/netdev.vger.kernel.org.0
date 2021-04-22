Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA433688CC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 00:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237048AbhDVWAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 18:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236660AbhDVWAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 18:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46CC661006;
        Thu, 22 Apr 2021 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619128809;
        bh=ZB7bZaDaBdSL/Si7gw6SR71kORNUNUGJiaUl4BwZ/mk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t08zI0samlzlf+W8VCfP1iuKAKHwQwMikaQrGva3Ybhy2vLRFEMMrffojQQPPtYk4
         x5qPAv+0tnIybdMNN198OUeJeXIW7lhigL/BtTdNUARiihOSkqlTOZ91rw77VEilJ2
         KT/5xkiBznIRKw1HclVj2ixv0k43tKOFJCPjcfH+LFjkmRjJ2xJSlfvvueaNcDZ8fc
         7nbX0J9ADe20oK74m4YQAUPAHaBK7IaFieiZIPqv1IyLlWJr08ASAmpJ9EEYk8+B/x
         wpi93VxLUHTvPpZfeD2knISICrfppy7XdsJsAUsNDMBj6le9wZjvfrARApSITP/oRM
         llCwe+V5vtxjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3ABB560A52;
        Thu, 22 Apr 2021 22:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bnxt_en: fix ternary sign extension bug in
 bnxt_show_temp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912880923.31492.17385488154517518202.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 22:00:09 +0000
References: <YIE9hEhXpdfffKg1@mwanda>
In-Reply-To: <YIE9hEhXpdfffKg1@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     michael.chan@broadcom.com, edwin.peer@broadcom.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Apr 2021 12:10:28 +0300 you wrote:
> The problem is that bnxt_show_temp() returns long but "rc" is an int
> and "len" is a u32.  With ternary operations the type promotion is quite
> tricky.  The negative "rc" is first promoted to u32 and then to long so
> it ends up being a high positive value instead of a a negative as we
> intended.
> 
> Fix this by removing the ternary.
> 
> [...]

Here is the summary with links:
  - [net] bnxt_en: fix ternary sign extension bug in bnxt_show_temp()
    https://git.kernel.org/netdev/net/c/27537929f30d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


