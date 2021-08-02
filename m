Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAAE3DDAB9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhHBOUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236749AbhHBOUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C4EE60F50;
        Mon,  2 Aug 2021 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627914006;
        bh=kCmE/M+fp6BP36qm+BH90dYnPgLZcintTlkVgWpDlWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cduMBu5rNhOupOmv3prNWGA97meQjMszXtV8ff5H6LoccoAQLv22xzkOTL87twOpl
         CtSrRvZ/ua59kvppnMJbHIxl8B9eAIO0S8iMFILzrUOUUOI27+R3ib9sE7hL4/ICEB
         dmCZ7/eouye3avO9W7d35VtNQTRyvaLPZBwl7B05W97xKDEFCX5pgH7TISChhlXwfI
         oNx/DoaeuoPXuHWuXXm0NGEUuPKZcYA50NUmbA6LIWbwH6NQw8MAGUpb2w8A4eBGvM
         fjdOJAU6pGUTQEoGl5t5FmzSAsXgH6rwFPRIXJBtPUzv6ESBz8UHmJ0/WvxKUbiXy/
         dQpx98/zowa/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 741D76098C;
        Mon,  2 Aug 2021 14:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: fix compiletime_assert for GCC 4.9
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791400647.18419.959153551731875710.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:20:06 +0000
References: <20210731143917.994166-1-kuba@kernel.org>
In-Reply-To: <20210731143917.994166-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 31 Jul 2021 07:39:17 -0700 you wrote:
> Stephen reports sparx5 broke GCC 4.9 build.
> Move the compiletime_assert() out of the static function.
> Compile-tested only, no object code changes.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: fix compiletime_assert for GCC 4.9
    https://git.kernel.org/netdev/net/c/6387f65e2acb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


