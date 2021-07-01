Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8246A3B963E
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhGASwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhGASwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8ABBB613E3;
        Thu,  1 Jul 2021 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625165403;
        bh=At1X6mpgL3PhaY6hnkM51uv1XUInLuobJVxyYFNNI4M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qcmnWrg7G26Y6DPuLyUOC84chVLQrdQHhZyOjx2rjmj7DIEK5gflaFTRa5OyD54Mg
         wlujLaRBIIPUrQBNMPseX7qcwX5p93edQQ4JFyME950zg87x42T4yj7/JvLkUB6A57
         sMX/op0QmkMWprriQVZoPmnXtbGwttedViIwVxLgdC6Jl/7sxl1v1Qx+fBU9XVmGYD
         I7nRNz0Fbtua1inDfHQdHWo9ADJP1KlKw+/GmEoVGMHTo9/68x021UB/t68VSlL2Yl
         D+sR7NyqOz5SE32sYYXpTuElyMRynInu49gdNosPC7ca3B3JNpeIho271MYWp6YQ76
         /YooHcwpWNztA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7F63B60A37;
        Thu,  1 Jul 2021 18:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sctp: move 198 addresses from unusable to private
 scope
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516540351.27350.7035524549259593559.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:50:03 +0000
References: <c3f8dfcf952ebfd1ebe0108fc13aacedbad38e99.1625024048.git.lucien.xin@gmail.com>
In-Reply-To: <c3f8dfcf952ebfd1ebe0108fc13aacedbad38e99.1625024048.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 23:34:08 -0400 you wrote:
> The doc draft-stewart-tsvwg-sctp-ipv4-00 that restricts 198 addresses
> was never published. These addresses as private addresses should be
> allowed to use in SCTP.
> 
> As Michael Tuexen suggested, this patch is to move 198 addresses from
> unusable to private scope.
> 
> [...]

Here is the summary with links:
  - [net-next] sctp: move 198 addresses from unusable to private scope
    https://git.kernel.org/netdev/net/c/1d11fa231cab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


