Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08741638520
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiKYIUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiKYIUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FEE22BE5;
        Fri, 25 Nov 2022 00:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAE7FB82991;
        Fri, 25 Nov 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7309BC433B5;
        Fri, 25 Nov 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669364416;
        bh=JY0z5s5qoo4VFsTBcFQnvGgI1go7QlR2K06NC1N3cC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LAXWjc4cgIHQhpEAkRHY1ZYAaGaQ1Z7FwkfYXHqyZohG3NtQFBTpE3dTzTUDKhoXd
         ui+blYpyBarfcoFJGRX5aRqZQhBfVNL9SaWXTbJ+IrOpsJIg8hPCI0zjeDieAM81hB
         DxoS9ny7elUBB9FXRK6QIRYH26/9iNjfUDHoMdRzJUmKsq0pB/qoDjPSjDh+4V0/BN
         VyQOyR9bHjsvtTIMUI088hFzZ6BD71JFgZE2sqrtXZ21yaPeE+iN3rrAb0TqdNwvyL
         2ZpX8rKmt599HHGxvd+AAuUYkixW3zFzc0Wl2XlCfzDDd7CZ0Ech7DL04U6ipEKKkm
         zmXMtTC1OAkOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5429EE4D012;
        Fri, 25 Nov 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: avoid defines prefixed with CONFIG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936441634.8812.12932619170728156837.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 08:20:16 +0000
References: <20221123103305.9083-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20221123103305.9083-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 11:33:05 +0100 you wrote:
> Defines prefixed with "CONFIG" should be limited to proper Kconfig options,
> that are introduced in a Kconfig file.
> 
> Here, constants for bitmap indices of some configs are defined and these
> defines begin with the config's name, and are suffixed with BITMAP_IDX.
> 
> To avoid defines prefixed with "CONFIG", name these constants
> BITMAP_IDX_FOR_CONFIG_XYZ instead of CONFIG_XYZ_BITMAP_IDX.
> 
> [...]

Here is the summary with links:
  - qed: avoid defines prefixed with CONFIG
    https://git.kernel.org/netdev/net/c/39701603519e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


