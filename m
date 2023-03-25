Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3980C6C8D7A
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 12:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjCYLbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 07:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYLbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 07:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206809753
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 04:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEC9A60C1C
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 11:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 147A0C4339B;
        Sat, 25 Mar 2023 11:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679743903;
        bh=/oM+JlRDL014YbO9vwPS9h3LDJeCYJvJGa3lBr3iM7s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dLf6h9pos9dbiRo+p1uyXOrqvIptz1AygBWtxZ+/ZmRGM6MLRC5CzzjPwAJMGR5Av
         UWfirTS27aen4bjiCAO4CeJzbJWhUxCbiDHpe59ED/WjZ7WITW42AG3myoSfMcATSr
         gdrTmhKhsBWmg6qu+FhG/CdX2NXGN5XZLexwfIIAeO++5QTDc55/PnNwWsdDdS/nAo
         bt6OvHaroT6Ixr+1bfhDHzJ74szCNS7qmZA4zSPv4T/OqIZeHu0FfLyFxGObA/emcp
         4ch/V8lKEFArvZlSau+yeB/blK6BxtTXAIfD3+zIjTFuxDiH55Oklg+RJ1nj6PimUk
         uNvLdaJJZ7bqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E45A0E4D021;
        Sat, 25 Mar 2023 11:31:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] r8169: fix RTL8168H and RTL8107E rx crc error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167974390292.24850.37200303703287006.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 11:31:42 +0000
References: <20230323143309.9356-1-hau@realtek.com>
In-Reply-To: <20230323143309.9356-1-hau@realtek.com>
To:     ChunHao Lin <hau@realtek.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 22:33:09 +0800 you wrote:
> When link speed is 10 Mbps and temperature is under -20°C, RTL8168H and
> RTL8107E may have rx crc error. Disable phy 10 Mbps pll off to fix this
> issue.
> 
> Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
> Signed-off-by: ChunHao Lin <hau@realtek.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] r8169: fix RTL8168H and RTL8107E rx crc error
    https://git.kernel.org/netdev/net/c/33189f0a94b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


