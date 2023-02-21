Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CDB69D776
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjBUAUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjBUAUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FE62196A;
        Mon, 20 Feb 2023 16:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A042260F53;
        Tue, 21 Feb 2023 00:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02130C4339C;
        Tue, 21 Feb 2023 00:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676938817;
        bh=eoHQqHvYFQFCS0S+n7+j4PGFGtkiLOzxYGOfbYtGdHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U7G0iyDhsAeV07i2t073kFXAP3+/N8JCsdls5iITk24JzM6rMjxgbECvIHPg8/n/B
         unRCBa29e9gIqxSSuaauaVpoBhcQw9C9Dc6c6dSrfv3ou71fCudUVCv+ZgMwR03hv9
         MhPjLOZ6Q8UaDb+0qeKjdnhrGzMQD2x4v19txa1z7/c2er0cIB6mfksN76S12EFWq6
         Qt+vEox2Q3Y+CwP0Wj0zR+yRDdBR5CK/WVeYDG6A4djgTflRzJqm2DVQCMJbdw0KSO
         cjGDP3PJdIF/Vn1ZU5gPawKcvNNwyD1+nA0/2qLbcPL6pZTyXa09YADl337V/MYsEO
         uNRHtenySCeVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB990C59A4C;
        Tue, 21 Feb 2023 00:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] MAINTAINERS: Switch maintenance for cc2520 driver
 over
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167693881689.28142.16088356100266329670.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 00:20:16 +0000
References: <20230218211317.284889-1-stefan@datenfreihafen.org>
In-Reply-To: <20230218211317.284889-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, miquel.raynal@bootlin.com,
        linux-kernel@vger.kernel.org, alan@signal11.us,
        liuxuenetmail@gmail.com, varkabhadram@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 18 Feb 2023 22:13:14 +0100 you wrote:
> Varka Bhadram has not been actively working on the driver or reviewing
> patches for several years. I have been taking odd fixes in through the
> wpan/ieee802154 tree. Update the MAINTAINERS file to reflect this
> reality. I wanted to thank Varka for his work on the driver.
> 
> Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
> 
> [...]

Here is the summary with links:
  - [net,1/4] MAINTAINERS: Switch maintenance for cc2520 driver over
    https://git.kernel.org/netdev/net/c/c551c569e388
  - [net,2/4] MAINTAINERS: Switch maintenance for mcr20a driver over
    https://git.kernel.org/netdev/net/c/d1b4b4117f89
  - [net,3/4] MAINTAINERS: Switch maintenance for mrf24j40 driver over
    https://git.kernel.org/netdev/net/c/6b441772854f
  - [net,4/4] MAINTAINERS: Add Miquel Raynal as additional maintainer for ieee802154
    https://git.kernel.org/netdev/net/c/195d6cc9c3d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


