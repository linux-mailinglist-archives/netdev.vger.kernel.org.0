Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E59039E840
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhFGUV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231322AbhFGUVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C2D361139;
        Mon,  7 Jun 2021 20:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623097203;
        bh=xXsdPPBQodftMEVddCJaHBberMftp2/S4Db8S7dTfNE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SL7C46FDVBk03SuAQE/fJ5czzbVv1SRUeXYFG8cz4Gs0MV7+9e3x5aCHlwE4FRBTZ
         lpQZzp/wl91SodxVDI2F+MadqYbZQ2RXPi2V7N/fK95NfrRkO5OMMXiRW6wY4XDe7C
         YQTg2vG5jKm/9Sn1MZW4H68RvcUB/pjH43ufAxIXJXPMfkCfMFcIRFOC75Tl6LGZh3
         HQHG0UgfBB5KyrHCGa9eaZGpUXNXooXxHSrGuZwFvh1mId2cWjRL/3zuvfMf9WTSdQ
         fgcF7nv2hVVyhemY/0TEo8S8LLoquvp2KlIzbG8eE+AukR+lQ9nSZ5QQTchmnfWsJ+
         EzpZ9DLmkXDgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 67C7760283;
        Mon,  7 Jun 2021 20:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mlxsw: Thermal and qdisc fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309720342.9512.13889927245367796593.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:20:03 +0000
References: <20210606082432.1463577-1-idosch@idosch.org>
In-Reply-To: <20210606082432.1463577-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun,  6 Jun 2021 11:24:29 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patches #1-#2 fix wrong validation of burst size in qdisc code and a
> user triggerable WARN_ON().
> 
> Patch #3 fixes a regression in thermal monitoring of transceiver modules
> and gearboxes.
> 
> [...]

Here is the summary with links:
  - [net,1/3] mlxsw: reg: Spectrum-3: Enforce lowest max-shaper burst size of 11
    https://git.kernel.org/netdev/net/c/306b9228c097
  - [net,2/3] mlxsw: spectrum_qdisc: Pass handle, not band number to find_class()
    https://git.kernel.org/netdev/net/c/d566ed04e42b
  - [net,3/3] mlxsw: core: Set thermal zone polling delay argument to real value at init
    https://git.kernel.org/netdev/net/c/2fd8d84ce309

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


