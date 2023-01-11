Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C5A6651C9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbjAKCaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbjAKCaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDFA64FD
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 18:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B32061A01
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF14AC433F1;
        Wed, 11 Jan 2023 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673404216;
        bh=XTDuFRL8ra//4WkPEuvPU5zhDMctx48fcI11o6x0sX8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EWJI8AW3qQv9L8uSSotJl/tiTYX3a04+IPHkcSorwnkycrbPfaif49k2x0WbiOKkM
         JFRB8t+onuGF8Fx3h2d674N6Ymuwu7MMaoMHTEF++J6qmYTIE5M6o4ZZ2ZLf9BLRgt
         DQuHRfJSjb1sGlIF46qbwcG9pEg02VFwVj7c1Ib5O9L7uZFN/SFHoP+HyfA6KR4Stq
         XgthhEULDT6X9LQRcjbBsRSNo8lS4ulfvwfdEinoBpOmQx17NaHDPMcJlOA3+6YRa8
         r2+h0W3SuHA9J76l0xz/pV5RP8IBWY5s2jw1nJEgk42tkUO+GN/Bftfx4r4jmcP7ut
         bBgWRcAxShnCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0D25E524EE;
        Wed, 11 Jan 2023 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2023-01-09 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167340421671.10258.3370494239852030614.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 02:30:16 +0000
References: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon,  9 Jan 2023 14:53:56 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Jiasheng Jiang frees allocated cmd_buf if write_buf allocation failed to
> prevent memory leak.
> 
> Yuan Can adds check, and proper cleanup, of gnss_tty_port allocation call
> to avoid memory leaks.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: Fix potential memory leak in ice_gnss_tty_write()
    https://git.kernel.org/netdev/net/c/f58985620f55
  - [net,2/2] ice: Add check for kzalloc
    https://git.kernel.org/netdev/net/c/40543b3d9d2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


