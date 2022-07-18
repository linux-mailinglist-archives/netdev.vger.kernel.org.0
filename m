Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E103577FEA
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiGRKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbiGRKkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D701EC50;
        Mon, 18 Jul 2022 03:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24888B8085F;
        Mon, 18 Jul 2022 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD74BC341CF;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658140816;
        bh=zSNVKbAIePIDlyMisHxJV3+CIetqRlnNDMDXHGUp1lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KWrmJSXCJI0ajRaIu+iAt1bcjU2TnHCaSijcQNvVnzh7eJaAiwKnV9fZ9Bf5b1JLG
         /nK6FMaSglF68lbJ0GK8XHJHImFNFOAp79LEKIvWvbUWzp/8I2X1p/yekf0nc8DGin
         lEXVDuEIjn0qN6Yww0e6lBUCkHLIOZHGMTXtqvq45lSs8/urap71VcamqL3dDh39St
         LXqtGqD9lkTISPxvIPZEewVqqsJY+KgaHah4037g+AwHz0erl1Zasje+u5Nd7qGPEv
         oxFPwC8q74zDKaURTz6lItL34qFJWPGZXAS2ScaK2OBPosSvuiIJRe5ymMgCpaDD3v
         ZqR35i5BjrIPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1543E451B4;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next] net: dsa: microchip: fix Clang
 -Wunused-const-variable warning on 'ksz_dt_ids'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814081665.19605.4023604204974593417.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 10:40:16 +0000
References: <20220715053334.5986-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220715053334.5986-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, arnd@kernel.org, linux@armlinux.org.uk
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Jul 2022 11:03:34 +0530 you wrote:
> This patch removes the of_match_ptr() pointer when dereferencing the
> ksz_dt_ids which produce the unused variable warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Suggested-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: microchip: fix Clang -Wunused-const-variable warning on 'ksz_dt_ids'
    https://git.kernel.org/netdev/net-next/c/da53af8cb932

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


