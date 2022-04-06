Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624454F5F16
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbiDFN1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiDFN01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:26:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59BAFFFB7
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 18:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE6A5619B3
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 01:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AF61C385A6;
        Wed,  6 Apr 2022 01:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649208612;
        bh=wDl12Ww1/bYXRIKG7tF5ZrkFONy+KNN8ZZtKQHDnXUo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mid0n6JItUplAfXVdfgl0xXTjM4QuxsUgAC1fzzhyKQuQY6xCLdq0EfQNlshD9F6Y
         6w9WxZLDYU3BMzJOiW23odXmYZCGsZSongrMOLRPEOTm76aYqtl20vCRKBGzkvQbaH
         FoiblPAjIbYdK3MnqeshiZ8iRCzGR2IsWkBn13lMtq/XaoNHxUsVhm2/SnH15LdieK
         RYqPMr+9ppYmu1KLbJnuoFqNiBr0LhwOcQzUUXJ511/fhgoMxeaUok6uJ9eI6YEkzv
         oPGlerJcpNwhOTy+tWHelWPSmbbZdUthTRDwb3jqQJm2qKN2bpCXMua9obaLgjAQA8
         ZkLgQH/EKTdig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20764E6D402;
        Wed,  6 Apr 2022 01:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mv643xx: Fix over zealous checking
 of_get_mac_address()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164920861212.7873.16841600261652467506.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 01:30:12 +0000
References: <20220405000404.3374734-1-andrew@lunn.ch>
In-Reply-To: <20220405000404.3374734-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, maukka@ext.kapsi.fi,
        walther-it@gmx.de
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

On Tue,  5 Apr 2022 02:04:04 +0200 you wrote:
> There is often not a MAC address available in an EEPROM accessible by
> Linux with Marvell devices. Instead the bootload has the MAC address
> and directly programs it into the hardware. So don't consider an error
> from of_get_mac_address() has fatal. However, the check was added for
> the case where there is a MAC address in an the EEPROM, but the EEPROM
> has not probed yet, and -EPROBE_DEFER is returned. In that case the
> error should be returned. So make the check specific to this error
> code.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mv643xx: Fix over zealous checking of_get_mac_address()
    https://git.kernel.org/netdev/net/c/11f8e7c122ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


