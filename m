Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C8472F90
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbhLMOkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:40:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50462 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbhLMOkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98C1E6111C;
        Mon, 13 Dec 2021 14:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09A0FC34608;
        Mon, 13 Dec 2021 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639406410;
        bh=pfBQJOuS4F2tyI20+tLp5jOIQ9lS1HV8XlsLqv9j7Tk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JOmHPUV+u5TwLNpAPU57CLWTq5MT2y9VCeaqR7tWACCRLkhpcjd3DRx4pxKTLoEmL
         Pp98cYY4yXdDUUxTt6YmNT8WkmJHxZdKow/7bA2bizn4j+dgNgq6SKshs3R5NtZ9Dm
         vaAOEacnmyQUIzxAD4LZGfZ5MvwxSuBuMZ9aS/WF4qq06Ol6kxrjZIlS97xTWKgwNW
         NQsx6iWhA8hBX59s0hC3KYWHqtywiJS6BEh2W27OprYrUdkUSyCmy24fVXcKR29sX9
         iPtoLMByUZG2CfB8DEgK6b+JCZExGI+UnatQmy+2bl9HTvUQtCfWm/GEJsLR4Sg5RI
         7AYOD2pz0Djwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E8062609CD;
        Mon, 13 Dec 2021 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net-next 0/3] add Vertexcom MSE102x support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940640994.17097.12175748318895527945.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:40:09 +0000
References: <1639320627-8827-1-git-send-email-stefan.wahren@i2se.com>
In-Reply-To: <1639320627-8827-1-git-send-email-stefan.wahren@i2se.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, michael.heimpold@in-tech.com,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 12 Dec 2021 15:50:24 +0100 you wrote:
> This patch series adds support for the Vertexcom MSE102x Homeplug GreenPHY
> chips [1]. They can be connected either via RGMII, RMII or SPI to a host CPU.
> These patches handles only the last one, with an Ethernet over SPI protocol
> driver.
> 
> The code has been tested only on Raspberry Pi boards, but should work
> on other platforms.
> 
> [...]

Here is the summary with links:
  - [V3,net-next,1/3] dt-bindings: add vendor Vertexcom
    https://git.kernel.org/netdev/net-next/c/e4d60d9f3625
  - [V3,net-next,2/3] dt-bindings: net: add Vertexcom MSE102x support
    https://git.kernel.org/netdev/net-next/c/2717566f6661
  - [V3,net-next,3/3] net: vertexcom: Add MSE102x SPI support
    https://git.kernel.org/netdev/net-next/c/2f207cbf0dd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


