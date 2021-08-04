Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB23DFE2B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhHDJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:40:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237087AbhHDJkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:40:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D0D3460F38;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628070007;
        bh=IeUG2UY1IF66ADE2HsqXQTKu6a6UNX0XaOw+KKyTzQY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bZo2/T8TJDTFPAJsrtUubL2RVh/3xaNoyGhB0cwNjjaf0GpKkoPOrAauU5lJIzqYH
         /o2fG4YqS78vb4iWGVwjJIJ7tgDSqz9LxxqqgOO7YBmk0md8v4g9cW1TWbKd1mBy2C
         9yEvkJA/QVucIy5EcJ1WP6sWB90A4hcAmfGMchQK4T1ybpOA4O2LvP17ysFLdSQYVm
         LTNuyEJ4ArRCR0/Iqzyv0MIZJWoe24nshixty2BDkPO2kQMNW3jexVZX33j3+4Or85
         TQJeuplGkutM9hKiz+6Yi1tDu7lWmMW5r1JLOyQU6T+AF8u1JCzXvqN1cA4/KrsfoH
         GYSI8BWPFEBGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2D6D60A6A;
        Wed,  4 Aug 2021 09:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: add netif_set_real_num_queues() for device
 reconfig
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162807000779.29242.13821650580499677861.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:40:07 +0000
References: <20210803130527.2411250-1-kuba@kernel.org>
In-Reply-To: <20210803130527.2411250-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        simon.horman@corigine.com, alexanderduyck@fb.com,
        oss-drivers@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  3 Aug 2021 06:05:25 -0700 you wrote:
> This short set adds a helper to make the implementation of
> two-phase NIC reconfig easier.
> 
> Jakub Kicinski (2):
>   net: add netif_set_real_num_queues() for device reconfig
>   nfp: use netif_set_real_num_queues()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: add netif_set_real_num_queues() for device reconfig
    https://git.kernel.org/netdev/net-next/c/271e5b7d00ae
  - [net-next,2/2] nfp: use netif_set_real_num_queues()
    https://git.kernel.org/netdev/net-next/c/e874f4557b36

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


