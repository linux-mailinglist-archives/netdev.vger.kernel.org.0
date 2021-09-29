Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6141C2D6
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245546AbhI2Klz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245539AbhI2Klu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ED62D61439;
        Wed, 29 Sep 2021 10:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632912009;
        bh=lOC/t/YPPEOL2AENZbQ7AaUa33yQXHoWQpntX5OdiIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NjawAYLfw0A5wMucYohdVpIZbgHHCLGeeLy/7RthJxJKUOi69+1rol/sIFvn9nVjx
         Rwy+WhF44Id2Es4Pd7+ItTmJjtMSRoCCocWTFnpO05R25ao/0/g1WvAk8FpYvp/UTr
         ZT27xhi82XO5Oqk4G5XOIALciMWpynriyr0czaGKkXvSFrAloiuewUGRhgvJO3QKwG
         KFrpgNrxoq3TPztXPdg85jAJiSgPCZt7o/TiUOHj3oSprvBblfZA6V4oSj4UyY+PHE
         u+aesJuZRBl5tyx7R3VsYsQoVM2NeiStvZ7UP5V12bU6YfL+khUM/fyP7IMl+NMexT
         NtpReXVn4mEbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E066460A9F;
        Wed, 29 Sep 2021 10:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/dsa/tag_8021q.c: remove superfluous headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163291200891.26498.832941316596286392.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 10:40:08 +0000
References: <20210929063611.3326-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210929063611.3326-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 14:36:11 +0800 you wrote:
> tag_8021q.c hasn't use any macro or function declared in linux/if_bridge.h.
> Thus, these files can be removed from tag_8021q.c safely without
> affecting the compilation of the ./net/dsa module
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> 
> [...]

Here is the summary with links:
  - [-next] net/dsa/tag_8021q.c: remove superfluous headers
    https://git.kernel.org/netdev/net-next/c/6f8b64f86e27

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


