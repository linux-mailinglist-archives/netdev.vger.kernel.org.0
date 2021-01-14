Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C822F595F
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbhANDau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:56282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbhANDat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D052723741;
        Thu, 14 Jan 2021 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610595008;
        bh=zh5dVqe/pAOxRO0oFNiD9bQ/TTzi1B7PY5Bd6CIwEl0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MBMQvGuXbRVMaFJQ3gNUkiGzPaxHEHsQhQ7A8gvG8BQGfWWZ1uR9ZKA+Rn+yRgsm8
         qr0Hv/Rol2RQ1X41aIfPAEwLaVSGKh/u6PM912u55Rs0TS03vgWWV7keDFaoWETIxN
         wmbCgN9Ivxmw62eyGiDtukcMtyPXQfnrjd15M4ABeBIIqTfJqsIzD1JO9PhPdrkitx
         HKSkscwCgaayAbLFqkNJMVb3E8VFqed5vAQ0ySnZ+LxR4WsFlwWpZ0LO5RH7HQ29+9
         fgRuU1EhrfvDx3CBJzDxH7jQbWPQEHDePSgmFNxSNhZND3FqOSW89bI0s1qj4sc/+e
         ZlYIaDUVzaIQg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id C2A8B60105;
        Thu, 14 Jan 2021 03:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dpaa2-eth: add support for Rx VLAN filtering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059500879.5331.8712741581261179841.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:30:08 +0000
References: <20210111170725.1818218-1-ciorneiioana@gmail.com>
In-Reply-To: <20210111170725.1818218-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ionut-robert.aron@nxp.com, ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 19:07:25 +0200 you wrote:
> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> 
> Declare Rx VLAN filtering as supported and user-changeable only when
> there are VLAN filtering entries available on the DPNI object. Even
> then, rx-vlan-filtering is by default disabled.
> Also, populate the .ndo_vlan_rx_add_vid() and .ndo_vlan_rx_kill_vid()
> callbacks for adding and removing a specific VLAN from the VLAN table.
> 
> [...]

Here is the summary with links:
  - [net-next] dpaa2-eth: add support for Rx VLAN filtering
    https://git.kernel.org/netdev/net-next/c/70b32d8276fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


