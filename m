Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4219D4B024F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiBJBaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:30:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiBJBaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:30:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C03A10A0;
        Wed,  9 Feb 2022 17:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A42DBB823FC;
        Thu, 10 Feb 2022 01:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7020BC340ED;
        Thu, 10 Feb 2022 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644456609;
        bh=qGQyGmjtozCv84Ye2BOs+8mk0SR0cVgFlFinrbcqULk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ASgJytk3CD6RUrcArDfPMltQOgX3F6DcY8tpPSBoLsNCyYwOEGSTG+3MF+jTZecoD
         oKE6caIpaOAcOOeGxF6KSdeBwGQLHmnQAZZFPxjaNESuvqPt0JLewCistNLwZihbWv
         5DXWiQX+v+HCsSDLG0n/3x9pj67XuGjEyuwXMxCB539HefN3zqpSS2+fA2zKDchpQo
         ZQ9MP6zT5pL48WnTxKgWHwsxgfvWlqJVlWGwwVPZMcAt8lVgyL5Lj5axLncrfnxQAO
         tPV49f6PMv98lFvo/hsNqSRwCaOjHYf6TireDHqZo1bkRP2/AaxZAdmO2UQeJ0qM6R
         xw5S3qdiN/4Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5904AE6D447;
        Thu, 10 Feb 2022 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: usb: qmi_wwan: Add support for Dell DW5829e
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164445660936.21209.3904165812207339582.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 01:30:09 +0000
References: <20220209024717.8564-1-slark_xiao@163.com>
In-Reply-To: <20220209024717.8564-1-slark_xiao@163.com>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     bjorn@mork.no, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Feb 2022 10:47:17 +0800 you wrote:
> Dell DW5829e same as DW5821e except the CAT level.
> DW5821e supports CAT16 but DW5829e supports CAT9.
> Also, DW5829e includes normal and eSIM type.
> Please see below test evidence:
> 
> T:  Bus=04 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  5 Spd=5000 MxCh= 0
> D:  Ver= 3.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
> P:  Vendor=413c ProdID=81e6 Rev=03.18
> S:  Manufacturer=Dell Inc.
> S:  Product=DW5829e Snapdragon X20 LTE
> S:  SerialNumber=0123456789ABCDEF
> C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=896mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> 
> [...]

Here is the summary with links:
  - [net] net: usb: qmi_wwan: Add support for Dell DW5829e
    https://git.kernel.org/netdev/net/c/8ecbb179286c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


