Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E6C5AE4ED
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 12:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbiIFKAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 06:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238575AbiIFKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 06:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8388158501;
        Tue,  6 Sep 2022 03:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E80BB8169B;
        Tue,  6 Sep 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB2B0C433D7;
        Tue,  6 Sep 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662458414;
        bh=fA5e317kN7fWVB1ksAV1YIxJXcPgnZIlYKl18esuh8M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qVSDk9e/CN+1IxqHP9EAGKBoQU4oPrBA+iwNejC93kdU5tY04Gai2X8kz7NF7YVDA
         W/zmKYpV1Rz8GKkcXklTNn8wN1zkhH+eoVTtpDXxHfaQpehGYwjGQSQBGbSRL6lTox
         /ARWVwBf3F1pT4RZW+xlUbHU9JyjiXzGheePjrlb9H0t00nZ+IYIyZ3t9n/N+jSGz7
         t4uUGnDTcYtPaGYX4RGeT+4rBCkvGzCOdZEvVjOI8Pb+nCm4T9DgRIpncaQog6xweX
         NwYRKA4ZJiIJDqUWFJaKnbccCqQ0twBetIpj5uQuCahfaGLU2kM62dNA7sH7n6GYqF
         Jeo7NmGxt3q6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF4E7C4166F;
        Tue,  6 Sep 2022 10:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: qmi_wwan: add Quectel RM520N
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166245841471.7810.9854019972633221684.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Sep 2022 10:00:14 +0000
References: <tencent_E50CA8A206904897C2D20DDAE90731183C05@qq.com>
In-Reply-To: <tencent_E50CA8A206904897C2D20DDAE90731183C05@qq.com>
To:     jerry meng <jerry-meng@foxmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  5 Sep 2022 09:24:52 +0800 you wrote:
> add support for Quectel RM520N which is based on Qualcomm SDX62 chip.
> 
> 0x0801: DIAG + NMEA + AT + MODEM + RMNET
> 
> T:  Bus=03 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#= 10 Spd=480  MxCh= 0
> D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=2c7c ProdID=0801 Rev= 5.04
> S:  Manufacturer=Quectel
> S:  Product=RM520N-GL
> S:  SerialNumber=384af524
> C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
> E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=40 Driver=option
> E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> E:  Ad=88(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
> E:  Ad=8e(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=0f(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> [...]

Here is the summary with links:
  - net: usb: qmi_wwan: add Quectel RM520N
    https://git.kernel.org/netdev/net/c/e1091e226a2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


