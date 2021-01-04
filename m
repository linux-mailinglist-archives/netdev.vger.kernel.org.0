Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FA52E9F9D
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhADVku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADVkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:40:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3EAD02225E;
        Mon,  4 Jan 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609796408;
        bh=kYP0Py+yZOetX4hNK50uT3GFIO3VKQ6ShFYTlOPndcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BXY8YC7fyaOsbBYhkRiEB9io1mKnFktcuRs8Ke4tJnCTZfkGHfXmRcVHBrld0WAhd
         h6v2l+Gz1Vcia/JjBFLxynHWRdTNuln1lszroYsf/ASpSJ3l88nfK9tWJ5Ee8+L/JU
         cbdlnMLlbS3xd/c0JioBD3kfOzbLGTHNcazAAlGFhXx3OEhHCbgO3baxTDDv3zpeZL
         uVvfCbTdebBTz2td5n04vKxAKLEJDoXD3kXGEt2DbdsxyE7EfHejtLiNibZ4Ku9joz
         zrLCnRNpXqqQEO1PBg9SZJoeB1jR/nO3klyqh1+YNaJCEpzjN7kU18wfPRBjbylMpj
         G/oJN3mv8pIdQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 3217C603F8;
        Mon,  4 Jan 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,stable] net: usb: qmi_wwan: add Quectel EM160R-GL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160979640820.4432.6523410004370550725.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jan 2021 21:40:08 +0000
References: <20201230152451.245271-1-bjorn@mork.no>
In-Reply-To: <20201230152451.245271-1-bjorn@mork.no>
To:     =?utf-8?b?QmrDuHJuIE1vcmsgPGJqb3JuQG1vcmsubm8+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Dec 2020 16:24:51 +0100 you wrote:
> New modem using ff/ff/30 for QCDM, ff/00/00 for  AT and NMEA,
> and ff/ff/ff for RMNET/QMI.
> 
> T: Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 2 Spd=5000 MxCh= 0
> D: Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs= 1
> P: Vendor=2c7c ProdID=0620 Rev= 4.09
> S: Manufacturer=Quectel
> S: Product=EM160R-GL
> S: SerialNumber=e31cedc1
> C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=896mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=(none)
> E: Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E: Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> E: Ad=83(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
> E: Ad=82(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E: Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> E: Ad=85(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
> E: Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E: Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> E: Ad=87(I) Atr=03(Int.) MxPS= 10 Ivl=32ms
> E: Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E: Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
> E: Ad=88(I) Atr=03(Int.) MxPS= 8 Ivl=32ms
> E: Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E: Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> 
> [...]

Here is the summary with links:
  - [net,stable] net: usb: qmi_wwan: add Quectel EM160R-GL
    https://git.kernel.org/netdev/net/c/cfd82dfc9799

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


