Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D279F52298F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbiEKCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241085AbiEKCUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45171F68F9
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 19:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E66B81FA5
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F5F7C385D9;
        Wed, 11 May 2022 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652235612;
        bh=JQ/qro19eqhR++59JqAZt2Bp3L2f+62bCXOSNez1vMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nX79dXnmv5ktf9wxwbpdHtQpG5PDI1zso2s28wf4fKeepVMsaIFninEU6ax74XVqP
         BfUJOZ9MqvI89W3t97MlyNnvDA728uXUBpOOrOaBtOrf4wz6a8Op4sdlrUADizXY6u
         hc1fIAmckQDEllqzpORysvdLpspH34Jpo8Y5oF/8n2YOnJhZucJZLAUAIhBQTW5evx
         iKu335EhoWlnSh0o23OBkkD50cSKk81hUsGGuNVMI5jrsjbbOX/H92GbGhooHcCtDc
         3VXEdJSYCQT5QzAfZK8d6ElUsAGutUq6d7Gg7F44g1RstQZ9/WSeNX3ZKmYPo2czpV
         Pb/uMYNa8qCdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F61EF03930;
        Wed, 11 May 2022 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: phy: add comments for LAN8742 phy support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165223561231.21834.11423435980727839066.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 02:20:12 +0000
References: <20220509185804.7147-1-yuiko.oshino@microchip.com>
In-Reply-To: <20220509185804.7147-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 9 May 2022 11:58:02 -0700 you wrote:
> Add comments for 0xfffffff2 phy ID mask for the LAN8742 and the LAN88xx, explaining that they can coexist and allow future hardware revisions.
> Also add one missing tab in smsc.c.
> 
> Yuiko Oshino (2):
>   net: phy: microchip: add comments for the modified LAN88xx phy ID
>     mask.
>   net: phy: smsc: add comments for the LAN8742 phy ID mask.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: phy: microchip: add comments for the modified LAN88xx phy ID mask.
    https://git.kernel.org/netdev/net-next/c/70a40ecfcb7d
  - [net-next,2/2] net: phy: smsc: add comments for the LAN8742 phy ID mask.
    https://git.kernel.org/netdev/net-next/c/b2be075139fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


