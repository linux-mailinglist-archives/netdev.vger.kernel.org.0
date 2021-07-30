Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8403DBDB3
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhG3RaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229919AbhG3RaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2FAD960F4B;
        Fri, 30 Jul 2021 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627666205;
        bh=ZtMSo3Ijtbc2AT6kdUoeP3qE86lHOaCFjm8f0qLTqoc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ct32Dwtstofzk1C7bdHlGMQVwHiDv1US3YvD0AyDZy4kacaDb8GuTPxi5DuurwtOL
         /TZ2zwmcTpJLOkNaIFbogqyoSBZY/ukZ3lFSjZadQkRrHOCkYne0GYL5B4ff4CRQ6f
         +smT/WVzJfQTkI9Xs6sM413orA3TgnUEGrpnOyT2a19UkZ5fDIu4CQdTBsGnVDmzd0
         5GilrAidKTR8iQrFeE0hFcJd3ucOSKqCHr0wLbkH7419RdxVnH2FaE1KCn4hqCORp3
         gFqIRN7AKhoWbRBspqjGOLNTxcGtNJmmnsmtR4jcBhek4GzzlbVEe4HtUFSncKgSO8
         IAzkkmILqASzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2349060A85;
        Fri, 30 Jul 2021 17:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: Update MAINTAINERS list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162766620514.25024.3646931771045371388.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Jul 2021 17:30:05 +0000
References: <20210729155258.442650-1-csully@google.com>
In-Reply-To: <20210729155258.442650-1-csully@google.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jonolson@google.com, awogbemila@google.com, jeroendb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 29 Jul 2021 08:52:58 -0700 you wrote:
> The team maintaining the gve driver has undergone some changes,
> this updates the MAINTAINERS file accordingly.
> 
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: Jon Olson <jonolson@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] gve: Update MAINTAINERS list
    https://git.kernel.org/netdev/net/c/028a71775f81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


