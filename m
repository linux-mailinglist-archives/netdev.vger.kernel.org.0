Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB333721B6
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhECUlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229926AbhECUlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 16:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 575DB61165;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620074410;
        bh=HwLZs5T5LNcMUjdR95M3POf2Bcy6PDSX/HKXLs7YWWc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gN808d+Cx9gbsghQF7Tk6JWD9uoNUKF2d83ba0NkncdvYM/+RiIWQpKEoBjj/XvXh
         01RTkDJVurFJKmHM2RyFxeE9NkchSY3uSQ/qxrQHlTD5GXcGAdEaDubRCC5tvxRXWE
         R4ywPw0slSAikq66kpVdq3lxaV1G4FPHEtdDZnvfyZ3rFcA0WsYD5uie4rulCY8T2U
         tF7RV/kvd3U5Rm8MjkZedEGZPELdPOdg/dnlgSHzENCo9UmbrIEO3o6fMo9P4WOqmb
         E+VempFlkv7Sm6Xu2O5zwPzqHUCfEQD9UyvZxgCkDoLokGONf4W32yZic5PRZQMJkl
         jbwBwd8wdvyNQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4133A60965;
        Mon,  3 May 2021 20:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] sctp: fix the race condition in sctp_destroy_sock in
 a proper way
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162007441026.32677.10980880945305090119.git-patchwork-notify@kernel.org>
Date:   Mon, 03 May 2021 20:40:10 +0000
References: <cover.1619989856.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619989856.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        orcohen@paloaltonetworks.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon,  3 May 2021 05:11:40 +0800 you wrote:
> The original fix introduced a dead lock, and has to be removed in
> Patch 1/2, and we will get a proper way to fix it in Patch 2/2.
> 
> Xin Long (2):
>   Revert "net/sctp: fix race condition in sctp_destroy_sock"
>   sctp: delay auto_asconf init until binding the first addr
> 
> [...]

Here is the summary with links:
  - [net,1/2] Revert "net/sctp: fix race condition in sctp_destroy_sock"
    https://git.kernel.org/netdev/net/c/01bfe5e8e428
  - [net,2/2] sctp: delay auto_asconf init until binding the first addr
    https://git.kernel.org/netdev/net/c/34e5b0118685

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


