Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C564453B126
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbiFBBUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiFBBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA12D13C1C3;
        Wed,  1 Jun 2022 18:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A68061618;
        Thu,  2 Jun 2022 01:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90729C385A5;
        Thu,  2 Jun 2022 01:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654132813;
        bh=FRtoPmqtpuxAOYkV1Jjz5r5gJ4V+Izk5bHDOjEi63VU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Axr3XH9b3BTn8b0AcnN1k7xEIYpsSvtW2Zfe1lervE9iLE7kW4MrskFNqWa1vE9FR
         fjCoMLo7qg6sr4nATcvsJauhiUxyaF/WI3S0Al9rMJKdq6oH6kbZIxPL0nbHXPgAPL
         ADsPPiH7QbCnsUD4DAyLTYAFCYxly5nx9spzyriFYo6HuSDol0sCmy3L2tmnZ/8lI5
         J+WKvt9ZXUKRzAmclFjfGdN8WtFtxabpI+WCvqxeAKrwSpVmiMQkTrLYGTsK13pF0m
         GP3RspFmeaUA/eLffwcwWLFUxL0pU+39u/Dj/nKIH96NOXo3YyJKPI1I6KwpuOz1VL
         f56WVd0AueXTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 701BFEAC081;
        Thu,  2 Jun 2022 01:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV31 with new
 baseline
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165413281345.8511.6891110071999430771.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 01:20:13 +0000
References: <20220601040531.6016-1-slark_xiao@163.com>
In-Reply-To: <20220601040531.6016-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     bjorn@mork.no, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Jun 2022 12:05:31 +0800 you wrote:
> Adding support for Cinterion device MV31 with Qualcomm
> new baseline. Use different PIDs to separate it from
> previous base line products.
> All interfaces settings keep same as previous.
> 
> T:  Bus=03 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
> D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
> P:  Vendor=1e2d ProdID=00b9 Rev=04.14
> S:  Manufacturer=Cinterion
> S:  Product=Cinterion PID 0x00B9 USB Mobile Broadband
> S:  SerialNumber=90418e79
> C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=60 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
> 
> [...]

Here is the summary with links:
  - net: usb: qmi_wwan: Add support for Cinterion MV31 with new baseline
    https://git.kernel.org/netdev/net/c/9f4fc18bf285

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


