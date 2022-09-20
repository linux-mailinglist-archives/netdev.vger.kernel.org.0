Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B105BE97D
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiITPAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiITPAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB75111C0F
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8880C6247A
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4008C433D7;
        Tue, 20 Sep 2022 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663686016;
        bh=BlmBUOvfEJNBOtyc3+j+krBAVbWmu003IZyr+PKpjeE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XjeXzxonWxRg/6e3gxt+JzrWRkhOAbxJj/wY8F2F1MB7hewQfK2jPRmeN5mzTyI0s
         p7uJgn6i0qGgm0fIxGbbdWjjAwgQMWI+2XrSxUX0VPEszPg2RJuLQr+v+CF13Ngodm
         JuoT9dW61q4L6SSo0sniiHadXbbuAZiHFXZOwxnXyjqWPUSUMqTa9jLxUD0UTgl0D+
         PmqEVyXlgQUVf+ALYoECvpTRuqYMHlC3DkpdFQa9NMuqRCbLF+nxn71KLVsr6MClS5
         ZMsrEUc+nNtK7YMy5tK9wJ+C409Z6IyfzoCjF/Q//PgtELCBdHVm5a5ibIdgvISxWd
         drYf4XRHHj+Jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC231E21EDF;
        Tue, 20 Sep 2022 15:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] sfp: add support for HALNy GPON module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368601669.19647.4504489418801743287.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:00:16 +0000
References: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
In-Reply-To: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pepe.schlehofer@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Sep 2022 20:06:06 +0100 you wrote:
> Hi,
> 
> This series adds support for the HALNy GPON SFP module. In order to do
> this sensibly, we need a more flexible quirk system, since we need to
> change the behaviour of the SFP cage driver to ignore the LOS and
> TX_FAULT signals after module detection.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: sfp: re-implement soft state polling setup
    https://git.kernel.org/netdev/net-next/c/8475c4b70b04
  - [net-next,2/5] net: sfp: move quirk handling into sfp.c
    https://git.kernel.org/netdev/net-next/c/23571c7b9643
  - [net-next,3/5] net: sfp: move Alcatel Lucent 3FE46541AA fixup
    https://git.kernel.org/netdev/net-next/c/275416754e9a
  - [net-next,4/5] net: sfp: move Huawei MA5671A fixup
    https://git.kernel.org/netdev/net-next/c/5029be761161
  - [net-next,5/5] net: sfp: add support for HALNy GPON SFP
    https://git.kernel.org/netdev/net-next/c/73472c830eae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


