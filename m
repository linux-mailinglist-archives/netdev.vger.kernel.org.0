Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3A130E7AB
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhBCXky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:40:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232990AbhBCXkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B2EF264F55;
        Wed,  3 Feb 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612395606;
        bh=q/SjSLADoNWAplzXvrqgwGRy2kr6DvzzrzKxS1eFTPg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZDG4wi/9wSib03XsEWInZnlw0K/yBJUZZ0dMmTc6sL4SN6wBbjp6v6WoXljK+sk5y
         RF4BmzMDI0iXbccZoiC4jESLGeK10pvt61SoMmlJ6wMniPkAWvlDxrkWCr4mGgjcRi
         k73/76hOFr7exhrxTJ80MtGtKAc9j+ks17iOdAM0v6YniZxX1O9bl78Re83RJON3i9
         RL3eHhFVTS4w5qKfnCEBgf7JyG/+6rt5l1BrlM4YVFqRQE2D/XotUafQ9Y76bWNAwM
         TGjU6yZrNJIbcXIMgYS3wKKiG6dGVSjyoT/wMT7v53FGfNrTa6wotf5MjrwGLhA/es
         CfmfZ2z+qLSuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9DC5F609E5;
        Wed,  3 Feb 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NET: usb: qmi_wwan: Adding support for Cinterion MV31
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161239560664.28685.10189151259787509626.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 23:40:06 +0000
References: <20210202084523.4371-1-christoph.schemmel@gmail.com>
In-Reply-To: <20210202084523.4371-1-christoph.schemmel@gmail.com>
To:     Christoph Schemmel <christoph.schemmel@gmail.com>
Cc:     bjorn@mork.no, avem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        hans-christoph.schemmel@thalesgroup.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Feb 2021 09:45:23 +0100 you wrote:
> Adding support for Cinterion MV31 with PID 0x00B7.
> 
> T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 11 Spd=5000 MxCh= 0
> D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
> P:  Vendor=1e2d ProdID=00b7 Rev=04.14
> S:  Manufacturer=Cinterion
> S:  Product=Cinterion USB Mobile Broadband
> S:  SerialNumber=b3246eed
> C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=896mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
> 
> [...]

Here is the summary with links:
  - NET: usb: qmi_wwan: Adding support for Cinterion MV31
    https://git.kernel.org/netdev/net/c/a4dc7eee9106

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


