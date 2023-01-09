Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4180C661F72
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbjAIHuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjAIHuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A434E13D22;
        Sun,  8 Jan 2023 23:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B30D60EEE;
        Mon,  9 Jan 2023 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 958C5C433F1;
        Mon,  9 Jan 2023 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673250616;
        bh=KMU3USBLJiUqc0o+ccLoYu/1Idu2u/gFbF5Orb4wo00=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pn8j01jMOOy0xM++9msby+0i2T4M9h9uBZtzWRPLnfHtR04DT0h+/1+VIPJHBGzzD
         vOapuRksHN+/yQB+AJRFkAonrjim8orUNCEiKk9dqjClJBo1QC5WCiby3HmB9Ly+1G
         KKxLyR/dhuV4Xtu2kRUTcDMM4UhUP3c9aWiLYo5+fgoVL8mXvycr1WBIbD6VKSDLRg
         hTyEJvjPE/GYY7nGQf0keyGhw8noe0JUZSdlshwdNvlNdREk71lN8/cSpqq0MMK1Z2
         5crlCh4QySATVPLLvpCUs5+qdpZZuUSiDDitNv9je5gYR7GhVadVVhpWUnUuXcXYpm
         1kz2CyW0Qbzzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64CE7E4D005;
        Mon,  9 Jan 2023 07:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] r8152: allow firmwares with NCM support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167325061640.1839.15796258098196650486.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:50:16 +0000
References: <20230106160739.100708-1-bjorn@mork.no>
In-Reply-To: <20230106160739.100708-1-bjorn@mork.no>
To:     =?utf-8?b?QmrDuHJuIE1vcmsgPGJqb3JuQG1vcmsubm8+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, hayeswang@realtek.com,
        linux-usb@vger.kernel.org, oliver@neukum.org
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
by David S. Miller <davem@davemloft.net>:

On Fri,  6 Jan 2023 17:07:37 +0100 you wrote:
> Some device and firmware combinations with NCM support will
> end up using the cdc_ncm driver by default.  This is sub-
> optimal for the same reasons we've previously accepted the
> blacklist hack in cdc_ether.
> 
> The recent support for subclassing the generic USB device
> driver allows us to create a very slim driver with the same
> functionality.  This patch set uses that to implement a
> device specific configuration default which is independent
> of any USB interface drivers.  This means that it works
> equally whether the device initially ends up in NCM or ECM
> mode, without depending on any code in the respective class
> drivers.
> 
> [...]

Here is the summary with links:
  - [1/2] r8152: add USB device driver for config selection
    https://git.kernel.org/netdev/net-next/c/ec51fbd1b8a2
  - [2/2] cdc_ether: no need to blacklist any r8152 devices
    https://git.kernel.org/netdev/net-next/c/69649ef84053

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


