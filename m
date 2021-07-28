Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194FB3D89C8
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhG1IaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 04:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234892AbhG1IaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 04:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3304B60FA0;
        Wed, 28 Jul 2021 08:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627461007;
        bh=MleTnvKM2YCpU8wq/3k8LY31lmnxGS809yWS6ZGGQqQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j6kNI0oxWcATQ4EQRmdjQ/HAJj4qayC3bsVEA2ghyPMf4Jfx5RxhMowm8u8nc/a7L
         UvZeS/JzsS7nJmCstiO0LCYn7moJsFdmEaYsw8QTm+gCvtMPmD8X4IoLJVUZqq7yQg
         6ak92jheISC13KYM+dDH43ZlxnIdZTcftMuhc87ixb7CzoQqQhDUDs3ZVQtmcSDpyz
         +G4sNeW/rVj+8JBLQ5fdtTiUURudxZT6YMDWBf6MWs6gqbgmt8jO8C4hROL1ePmzXH
         JnuAqzNODjBZSmzvqU6sk8gq35fdh169k6wKZsTgXes2euWURIvRXGbSB3zx+Hppzq
         NjaEViINHdG7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2775060A7B;
        Wed, 28 Jul 2021 08:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: fix return value check in __sctp_rcv_asconf_lookup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162746100715.27952.16141673680549517209.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 08:30:07 +0000
References: <599e6c1fdcc50f16597380118c9b3b6790241d50.1627439903.git.marcelo.leitner@gmail.com>
In-Reply-To: <599e6c1fdcc50f16597380118c9b3b6790241d50.1627439903.git.marcelo.leitner@gmail.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ben@decadent.org.uk, ivansprundel@ioactive.com, carnil@debian.org,
        lucien.xin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 27 Jul 2021 23:40:54 -0300 you wrote:
> As Ben Hutchings noticed, this check should have been inverted: the call
> returns true in case of success.
> 
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Fixes: 0c5dc070ff3d ("sctp: validate from_addr_param return")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] sctp: fix return value check in __sctp_rcv_asconf_lookup
    https://git.kernel.org/netdev/net/c/557fb5862c92

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


