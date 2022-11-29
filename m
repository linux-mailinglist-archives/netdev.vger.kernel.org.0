Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E6F63B6E3
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbiK2BKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234933AbiK2BKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:10:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA1D23EBD;
        Mon, 28 Nov 2022 17:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B3B6B810DD;
        Tue, 29 Nov 2022 01:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDB66C433C1;
        Tue, 29 Nov 2022 01:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669684215;
        bh=Y12FbjIcVXNUFLF6LsXxDjdmRUnthUuYyEbj6fRq+7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oMYuLLRqEdQHn95TPqW3kC+TEVGB1CCoyzevuLosk6Oc7Vd+2o/J7nBWvFPRuI4O7
         PPUoZTuVj29rSVUP7wJptaDeLCfYpa18JnByGL71kZ/B+z0gVNxEO7mukaNvAyjlAF
         6o43YNim7MPjP3zRpz1gvF2HhIhEOlrw2B29D0/AMAAGJrU7FMG+IxmfG9rFSQWBVF
         czW5QYn9ExR4Y2NQ3KCp93VGtpT3bOlo1Uyp8W0aoqnhsvjS6jWTwu70OFuvCgj2eC
         8QOxsRTcGK0yJfxUMhx6X5I1lm38Ylo7Qah2Qs4ReP/E7hFG/hFFjJuV5RletCYrB9
         +RnSLONNE0waQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D75C8E21EF6;
        Tue, 29 Nov 2022 01:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: usb: cdc_ether: add u-blox 0x1343 composition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968421487.15821.3855507738761227222.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 01:10:14 +0000
References: <20221124112811.3548-1-davide.tronchin.94@gmail.com>
In-Reply-To: <20221124112811.3548-1-davide.tronchin.94@gmail.com>
To:     Davide Tronchin <davide.tronchin.94@gmail.com>
Cc:     pabeni@redhat.com, bjorn@mork.no, kuba@kernel.org,
        linux-usb@vger.kernel.org, marco.demarco@posteo.net,
        netdev@vger.kernel.org, oliver@neukum.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Nov 2022 12:28:11 +0100 you wrote:
> Add CDC-ECM support for LARA-L6.
> 
> LARA-L6 module can be configured (by AT interface) in three different
> USB modes:
> * Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
> interfaces
> * RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
> interfaces and 1 RmNet virtual network interface
> * CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
> interface and 1 CDC-ECM virtual network interface
> 
> [...]

Here is the summary with links:
  - [v2] net: usb: cdc_ether: add u-blox 0x1343 composition
    https://git.kernel.org/netdev/net-next/c/2816c98606a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


