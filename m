Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726E65499EF
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241592AbiFMR0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiFMRZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:25:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D5F286C2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 05:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A3EB80EF4
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 12:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75402C341C5;
        Mon, 13 Jun 2022 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655124013;
        bh=lKthuzB9IFbiNxf72+PFPssqUoMI9dLFIgiB1xLQ9IA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MMgCa7fvqTcEQHlBraxa5z97xQf4KyeBcYVM3b/BSfVhMOpIT+3njdLGVTJT+ULV+
         lU6pDE28z3sowuoc2j4KA8R5woCceVXwBrXL5I3RSXrE37rbw2UHhOk5VHfOPfz+cf
         zUdfIEbhegJRbWDa5lgPH6oLi6skxSD5khMVmvntAuxCY6DqCRcA/CGr3V/sGUaVjJ
         qkqzf2HEZqfHBtodt6+HNS0y75VeuoIFpN4H7sn0wKBk3KXvzpJI1rSmjVbPkkohJJ
         yJSM1Kc/SJPX/zbnvpa6HlE/T91nzbOVRm8IRa6Tb3oSga3BhlLImL03Jcfv5ycZpF
         XPI6Vdxe+AACQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B710E737EE;
        Mon, 13 Jun 2022 12:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/1] Add driver support for Microchip EVB-LAN8670-USB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165512401337.9046.10579143153569279026.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 12:40:13 +0000
References: <20220613091207.17374-1-Parthiban.Veerasooran@microchip.com>
In-Reply-To: <20220613091207.17374-1-Parthiban.Veerasooran@microchip.com>
To:     Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Jan.Huber@microchip.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Jun 2022 14:42:06 +0530 you wrote:
> This patch adds driver support for Microchip's EVB-LAN8670-USB 10BASE-T1S
> Ethernet device.
> 
> Changes in v1:
> - Added driver support for Microchip's EVB-LAN8670-USB 10BASE-T1S Ethernet
>   device.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: smsc95xx: add support for Microchip EVB-LAN8670-USB
    https://git.kernel.org/netdev/net-next/c/4066bf4ce3ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


