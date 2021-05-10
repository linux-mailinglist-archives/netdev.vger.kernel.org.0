Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EA237995D
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhEJVl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhEJVlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B3E361621;
        Mon, 10 May 2021 21:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682810;
        bh=To2BxNRIqbdEhksK8f+TTTzf4j3Mov1uJOVRXztmRuk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JIgQ0Wr3s7j1CytDqomj0bgFGgwOJXthXBRu2jQHBFXDeYl2gPZHfzakEnqXBnYfO
         IkrWAb8azRHNh21v66wACi05ogUOn7/AG56uHRD63cZLlC/f67e9gEGg2+p+luc3+t
         ek13pi9MHGkCd+knE/20WqUKjHijst8zs8d6a9lJvxQl3EocYkhwdZ8QRODdG5hOXM
         +7JAIR97qfQMunQFHuddR/p0EVGS05PwHRUarjiZwSsSMeqm4Lan8oD5tShoYJHofl
         q88ta/kKlGnJqmAsEP4XIJ+JtyFs6E2CaOXuVLZBZxWedKaf+03EnJnLe4wM6jzIBa
         bchOjvMMSVFaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95ABA60A48;
        Mon, 10 May 2021 21:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3 net-next] net: qca_spi: Improve sync handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068281060.31911.13009428589213016326.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:40:10 +0000
References: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
In-Reply-To: <1620477395-12740-1-git-send-email-stefan.wahren@i2se.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat,  8 May 2021 14:36:32 +0200 you wrote:
> This small patch series contains some improvements of the sync
> handling. This was discovered while the QCA7000 was doing SLAC
> (Signal Level Attenuation Characterization).
> 
> Stefan Wahren (3):
>   net: qca_spi: Avoid reading signature three times in a row
>   net: qca_spi: Avoid re-sync for single signature error
>   net: qca_spi: Introduce stat about bad signature
> 
> [...]

Here is the summary with links:
  - [1/3,net-next] net: qca_spi: Avoid reading signature three times in a row
    https://git.kernel.org/netdev/net-next/c/b76078df1593
  - [2/3,net-next] net: qca_spi: Avoid re-sync for single signature error
    https://git.kernel.org/netdev/net-next/c/6e03f3ff29c1
  - [3/3,net-next] net: qca_spi: Introduce stat about bad signature
    https://git.kernel.org/netdev/net-next/c/a53935674563

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


