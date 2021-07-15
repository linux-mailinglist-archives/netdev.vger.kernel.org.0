Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7A73CA3D8
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbhGORW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhGORW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:22:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AE4EB6100B;
        Thu, 15 Jul 2021 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626369604;
        bh=B9m4tKNRPxfm9CD/KwMlzv1Cr+1AxuXejr0WhYQj/CM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PU+XhiG3mq2ZqhI7cBpCfCCrZJ9GrQBw3HYjATOtOmiAXk8P+jTd66FiVIZWeuFLK
         Pn50idQoP6OsQy4bLT+LBsDgAXycQfCm/Zv5biYkkG3vJLeYgJw+gWN6aJ5t/DlyqJ
         mfQLIJ0RIWVdZM7SEMSGmOkSiDkqX8Ad2++pOoxxgmjT95qWu+H+BxpQxY2pGdZSia
         tviiYXDkHSDZVUywN5SuWpjQcbP0rlzZZ2NcW1GSa59y6jXYR3584WgL6ZNFn94L+z
         HmzURIfMD6Gvbi9BvJfm3jpTVi914qzthLXdwuiqXa9TfmH51mmfBra4jquA6DpB3W
         +3qZF+/ZAe/Ng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A2563609EF;
        Thu, 15 Jul 2021 17:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bus: mhi: pci-generic: configurable network interface MRU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162636960465.7245.15194740466050734588.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 17:20:04 +0000
References: <20210714211805.22350-1-richard.laing@alliedtelesis.co.nz>
In-Reply-To: <20210714211805.22350-1-richard.laing@alliedtelesis.co.nz>
To:     None <richard.laing@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, loic.poulain@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Jul 2021 09:18:05 +1200 you wrote:
> From: Richard Laing <richard.laing@alliedtelesis.co.nz>
> 
> The MRU value used by the MHI MBIM network interface affects
> the throughput performance of the interface. Different modem
> models use different default MRU sizes based on their bandwidth
> capabilities. Large values generally result in higher throughput
> for larger packet sizes.
> 
> [...]

Here is the summary with links:
  - bus: mhi: pci-generic: configurable network interface MRU
    https://git.kernel.org/netdev/net-next/c/5c2c85315948

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


