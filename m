Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508813662E6
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhDUAKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234444AbhDUAKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8556961426;
        Wed, 21 Apr 2021 00:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963810;
        bh=M1UcTxjqdRTTyczqkoRTSpB0ZszeSqpnUTu5RDGj99k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YcTys5olEIkNOP2nI7mbo4ZTvK56wtb+VDpkevjKNpr2FKIMrvS0gmwjfZARNQrch
         et/1VkJ2+4eSf0Zz04RnyGUbA4ae8qJO3PINhr//+ZPT91mdHC/CNJC1LjKNfCv6Ga
         i6cN4tvP1fsK5okMp7wza+bQzn/dII+d5jP2yDUWlrEsUClt7JPq7ro/u42UJq+xXw
         bPJFWegIUZCMXcBRYyK54OkbyP3cX2ODTqOiLx+RNWGbL7Rt2uPHahz2oIymT+CroX
         YdY4Oo2b8YHr34ekI3cNAd1/EhbsVs6ojAnV56YNF/mdVLBAJTRSn5bWONCsVWiMVM
         icH0+zsTfNGAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7FEF360A39;
        Wed, 21 Apr 2021 00:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: at803x: fix probe error if copper page
 is selected
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896381051.7038.17479076161170031115.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:10:10 +0000
References: <20210420102929.13505-1-michael@walle.cc>
In-Reply-To: <20210420102929.13505-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 12:29:29 +0200 you wrote:
> The commit c329e5afb42f ("net: phy: at803x: select correct page on
> config init") selects the copper page during probe. This fails if the
> copper page was already selected. In this case, the value of the copper
> page (which is 1) is propagated through phy_restore_page() and is
> finally returned for at803x_probe(). Fix it, by just using the
> at803x_page_write() directly.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: at803x: fix probe error if copper page is selected
    https://git.kernel.org/netdev/net-next/c/8f7e876273e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


