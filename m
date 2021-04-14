Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2843A35FD01
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhDNVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229875AbhDNVKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BB0DA61132;
        Wed, 14 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618434610;
        bh=Yrj2V4zBoEUyRFLsBwaS6YFmW130BRtJzYuK/5dmEoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N4hakCu54Z8efm+edc0rPy00kigF/TVBpVT2lR+Em5NQ+3Jr8d21A+75Q6WnCA8rh
         uq+Uyn8DEKNx3LW9jQxnYYyQtFV1IglZuM+bSKjELOEO4Iqtnqytn6cNRZU2FiXMHk
         noypjdQ59M3sD/3W5vKdwCGqnBML/NgLWotfz+ID4Hffr92g+hRtCqyB3aSF9qIX72
         iC/bo6n4YnWTa3GQ90dlim32Hjvw9x1Hw1jibX4f6tfO0gWlR98CyOZbu/j9JOp+73
         oX00vXi0Z35yj6lBchXTaVUBRIePUPqeClAEr0W5zVVsmsF3uK2UtCJLbqoptUncRi
         dC2HrsDkfhGIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AFE3F60CCF;
        Wed, 14 Apr 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: fetch MAC address from device tree
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843461071.4219.13979494791696671300.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:10:10 +0000
References: <20210414144814.25382-1-michael@walle.cc>
In-Reply-To: <20210414144814.25382-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 16:48:14 +0200 you wrote:
> Normally, the bootloader will already initialize the MAC address
> registers of the ENETC and the driver will just use them or generate a
> random one, if it is not initialized.
> 
> Add a new way to provide the MAC address: via device tree. Besides the
> usual 'mac-address' property, there is also the possibility to fetch it
> via a NVMEM provider. The sl28 board stores the MAC address in the SPI
> NOR flash OTP region. Having this will allow linux to fetch the MAC
> address from there without being dependent on the bootloader.
> 
> [...]

Here is the summary with links:
  - [net-next] net: enetc: fetch MAC address from device tree
    https://git.kernel.org/netdev/net-next/c/652d3be21dc8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


