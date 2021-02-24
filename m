Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE02324396
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 19:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhBXSKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233640AbhBXSKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 13:10:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A912464EDD;
        Wed, 24 Feb 2021 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614190206;
        bh=b+WIdwoBXt51nyx55PsJVStpyMc267xQ6NDo88idvqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a8RCZnBBuh9YCVpxetAsJcDIaV3wzsV1WqFBvFC304HmkxpxDz3ctVrBT/WNJOcaz
         YS585g2GsIfwfvykiMgql7vyWY0enypLVBaE7jUrBN7CI6wYsVrTPEwTK5HBdg8yQf
         2UVfdRhGAxnn2VuS3BJB4qlhYM+EmCA43Mo6FyqSTeNJunPyseZ1I+8WDKBeaSwH0X
         XJat3u2C28seDRfN1Y/XhRWHUqj6FYxFihHiH3H15KFawIaWMKp8fwHcr18pAPoINx
         hOMpsRdGZeKn17AFmduZGZl6U7kRPS7ocRix1Ywn+nEUV/1XxwGKgYmA/8RVrA5wKL
         kOplinPFG4+ug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9725160176;
        Wed, 24 Feb 2021 18:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: usb: qmi_wwan: support ZTE P685M modem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161419020661.3818.15606819052802011752.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Feb 2021 18:10:06 +0000
References: <20210223183456.6377-1-lech.perczak@gmail.com>
In-Reply-To: <20210223183456.6377-1-lech.perczak@gmail.com>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org, kuba@kernel.org,
        bjorn@mork.no
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 23 Feb 2021 19:34:56 +0100 you wrote:
> Now that interface 3 in "option" driver is no longer mapped, add device
> ID matching it to qmi_wwan.
> 
> The modem is used inside ZTE MF283+ router and carriers identify it as
> such.
> Interface mapping is:
> 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
> 
> [...]

Here is the summary with links:
  - [v3] net: usb: qmi_wwan: support ZTE P685M modem
    https://git.kernel.org/netdev/net/c/88eee9b7b42e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


