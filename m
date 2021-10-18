Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ED4431853
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhJRMCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhJRMCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 08:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E187161260;
        Mon, 18 Oct 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634558406;
        bh=gtGtOrvrLSJKUmHl3YuUlIXzUghrjnKyvXs2fn+o7HA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ndZeUT8EOqUS0YeJAgul/hD1fu0qI++QfZTFp7BCXRu8g7cbR6k/oA6xh3Y4zBjxJ
         wmPoS92WkEoYqVSgIm+MGZwdVBu2XsbDAzpA6cmCdUiI+kzI7TsO89Hx7kqf3C8SL4
         0VvOlVZWhpiD39AVIb2gPD43fdbIT/lU0NTcmGz7CPFc71n5sL4w9LUfLStAGR/tJb
         OPIJ5pfahjKvaPRc40gQt9JaFtBorJHBGI0KwF3WWE0dX+ISGFGZ5vlVd4ByKMRC5U
         CXvdaBymBVMFQteRpl6KnIzBHNwlsr85MF7rGHT4wgx6AS1qZ5fvGOROV0+iGjhmZ6
         DJ5zUUEoV1VSA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D1ADD609F7;
        Mon, 18 Oct 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] hamradio: baycom_epp: fix build for UML
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163455840685.2577.7817040614905305666.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 12:00:06 +0000
References: <20211015021804.17005-1-rdunlap@infradead.org>
In-Reply-To: <20211015021804.17005-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, linux-um@lists.infradead.org,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        davem@davemloft.net, kuba@kernel.org, t.sailer@alumni.ethz.ch,
        linux-hams@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 19:18:04 -0700 you wrote:
> On i386, the baycom_epp driver wants to inspect X86 CPU features (TSC)
> and then act on that data, but that info is not available when running
> on UML, so prevent that test and do the default action.
> 
> Prevents this build error on UML + i386:
> 
> ../drivers/net/hamradio/baycom_epp.c: In function ‘epp_bh’:
> ../drivers/net/hamradio/baycom_epp.c:630:6: error: implicit declaration of function ‘boot_cpu_has’; did you mean ‘get_cpu_mask’? [-Werror=implicit-function-declaration]
>   if (boot_cpu_has(X86_FEATURE_TSC))   \
>       ^
> ../drivers/net/hamradio/baycom_epp.c:658:2: note: in expansion of macro ‘GETTICK’
>   GETTICK(time1);
> 
> [...]

Here is the summary with links:
  - [net] hamradio: baycom_epp: fix build for UML
    https://git.kernel.org/netdev/net/c/0a9bb11a5e29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


