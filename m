Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E90C3AA42B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhFPTWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232624AbhFPTWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3A78460FEA;
        Wed, 16 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623871204;
        bh=AMvrHDA9umeoyZrjscAOqXsQEvXt/E8Zj0MXDqUonIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RRulelyaDr4I+jZqrLFoEYlVP4SODTueYmcJyeg91Y3iM7mKde+8UH/fNtc2khAHF
         lb1fC0YOcGneDn+7x0uJ0owFOZfyMHXJGZyc6GbhNXrnpL8ltQrF3s/bEo7mRWSEI6
         iTiF6eh4MB5gR83DDQw+usq948sCCOvOryHhCleqS66NESciuCagHdqJstiPT+v/tE
         dcPQ+zPEW2n8y7ge/ZCWRYjRKsLOnHeo2uhMyx+VhA5QxI/GMBg92Fdud7EZqFquwp
         Mefmzq8w/wWf+usvBnwgec9o/sgL4lKU86QmTrP5theM7/PIcBkzK1v4InjOng5gb/
         PSAjHVKdElZEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E37E60A54;
        Wed, 16 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: qualcomm: rmnet: Allow partial updates of
 IFLA_FLAGS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387120418.29488.15765073920197282616.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:20:04 +0000
References: <20210615232707.835258-1-bjorn.andersson@linaro.org>
In-Reply-To: <20210615232707.835258-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, elder@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 18:27:07 -0500 you wrote:
> The idiomatic way to handle the changelink flags/mask pair seems to be
> allow partial updates of the driver's link flags. In contrast the rmnet
> driver masks the incoming flags and then use that as the new flags.
> 
> Change the rmnet driver to follow the common scheme, before the
> introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS
    https://git.kernel.org/netdev/net-next/c/d917c35a451e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


