Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E1A41314B
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 12:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhIUKLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 06:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231555AbhIUKLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 06:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 05B5F61186;
        Tue, 21 Sep 2021 10:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632219009;
        bh=glT+9fYvnD51sTF9l0vYV3V0vhWn6d0vVmKE0lhkaMQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=toihIreYgtnZkvfjZmBvw3G5oUWbEapfnotmr/LEjd6TCYE8UP8P2OjDxyhxTwyfp
         r2rI1SM1x5n78UBbRdpCH2Ui9Q7WwXDS5gTF8WEZmb4RRtQXNL0JClCYaoDqTOfa0j
         B6Ln69Tt161NNvg+BdiYrTunxKTES7Bw9538Y5WOcKHhLV0bdsZwv3tJv4eF/e7EGz
         wk1mvq6jjWLzjCSZe1YxL7eje2dQuzrX7ZRqPGEMaCmyVicoxzsEInLQTl2m49jvCj
         /KiAeMtXGv/IDWMI2YoieNb7BAkax81I69Ca5qhNQz7HXHwDsPajKfVH8eGVxj0G48
         HqjmU4dxS9abg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00F2060A2A;
        Tue, 21 Sep 2021 10:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: phy: broadcom: IDDQ-SR mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163221900900.14288.10503847729138254007.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Sep 2021 10:10:09 +0000
References: <20210920215418.3247054-1-f.fainelli@gmail.com>
In-Reply-To: <20210920215418.3247054-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 20 Sep 2021 14:54:13 -0700 you wrote:
> This patch series adds support for the IDDQ with soft recovery mode
> which allows power savings of roughly 150mW compared to a simple
> BMCR.PDOWN power off (called standby power down in Broadcom datasheets).
> 
> In order to leverage these modes we add a new PHY driver flags for
> drivers to opt-in for that behavior, the PHY driver is modified to do
> the appropriate programming and the PHYs on which this was tested get
> updated to have an appropriate suspend/resume set of functions.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: phy: broadcom: Add IDDQ-SR mode
    https://git.kernel.org/netdev/net-next/c/d6da08ed1425
  - [net-next,2/5] net: phy: broadcom: Wire suspend/resume for BCM50610 and BCM50610M
    https://git.kernel.org/netdev/net-next/c/38b6a9073007
  - [net-next,3/5] net: phy: broadcom: Utilize appropriate suspend for BCM54810/11
    https://git.kernel.org/netdev/net-next/c/72e78d22e152
  - [net-next,4/5] net: bcmgenet: Request APD, DLL disable and IDDQ-SR
    https://git.kernel.org/netdev/net-next/c/c3a4c69360ab
  - [net-next,5/5] net: dsa: bcm_sf2: Request APD, DLL disable and IDDQ-SR
    https://git.kernel.org/netdev/net-next/c/4972ce720101

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


