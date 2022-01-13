Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFD048D81D
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiAMMkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:40:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33072 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiAMMkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 07:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 803D761C18;
        Thu, 13 Jan 2022 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF2A1C36AEC;
        Thu, 13 Jan 2022 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642077609;
        bh=188HWT1CkxrwlSeVx4VHEbaaD4KJ+ccLjOYC5mXrvY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AISn/NZ6B27ZlACncbGXBr4gRX6qLlhoSQODl95aWH80M3n97WupOPafhF/YUsLuB
         nt3S1EVYA/C/TMvtoCgr1ZxHNP1mtOlytCJ8z+WE2gaaPHqz6OTP1NsCceQ5DTFoc3
         V6x7dtcG2KNoUeK4eoRwtmIQv2cNJSmx2wW2LPjAZWtKebiyK0gB3saJ3vJZ7uacuV
         CyQWB6K5ClMFTIoZARkg29EvB/yBwiMYvhSM1nRzWf5Ghb8N5lnTq+uIW3CYtg2z4S
         FP80fkqe8ZfcpSNCXHyR88YuGWYBTz8zTupWIyV9XxSxKjOmNGkXkoo4+5GDwbD4GW
         4ltfDIeuv4Mng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7A0CF6078E;
        Thu, 13 Jan 2022 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qmi_wwan: add ZTE MF286D modem 19d2:1485
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164207760981.15302.4251167681503025563.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Jan 2022 12:40:09 +0000
References: <20220111221132.14586-1-paweldembicki@gmail.com>
In-Reply-To: <20220111221132.14586-1-paweldembicki@gmail.com>
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linux-usb@vger.kernel.org, bjorn@mork.no, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 11 Jan 2022 23:11:32 +0100 you wrote:
> Modem from ZTE MF286D is an Qualcomm MDM9250 based 3G/4G modem.
> 
> T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=5000 MxCh= 0
> D:  Ver= 3.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 9 #Cfgs=  1
> P:  Vendor=19d2 ProdID=1485 Rev=52.87
> S:  Manufacturer=ZTE,Incorporated
> S:  Product=ZTE Technologies MSM
> S:  SerialNumber=MF286DZTED000000
> C:* #Ifs= 7 Cfg#= 1 Atr=80 MxPwr=896mA
> A:  FirstIf#= 0 IfCount= 2 Cls=02(comm.) Sub=06 Prot=00
> I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=ff Driver=rndis_host
> E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
> I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
> E:  Ad=81(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=01(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> E:  Ad=83(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=84(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=03(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=86(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 5 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
> E:  Ad=8e(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=0f(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> I:* If#= 6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=usbfs
> E:  Ad=05(O) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> E:  Ad=89(I) Atr=02(Bulk) MxPS=1024 Ivl=0ms
> 
> [...]

Here is the summary with links:
  - net: qmi_wwan: add ZTE MF286D modem 19d2:1485
    https://git.kernel.org/netdev/net/c/078c6a1cbd4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


