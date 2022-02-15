Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949F84B6EE0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 15:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbiBOOad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:30:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238635AbiBOOa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:30:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E610BEDF11;
        Tue, 15 Feb 2022 06:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A7D5CE1FE7;
        Tue, 15 Feb 2022 14:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92B45C340F8;
        Tue, 15 Feb 2022 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644935410;
        bh=BNpHF5ZbFhswEdFNrdVNUhGYlhfjthh+/3dIEwBWkyo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IJdVJe0eVaqY31JG/azMG2y4iIeb0UmtMnQR8xuAxQ8kPM1+KoUHYaybzfcbe52/J
         EWSRx5dKeCnEAdpMq+83ZU8h7tGzMcbAuTS4CPxQga0kaJo8vTblV31S7ZuG13U059
         HnSuQC3PbulYdrb9YRqSE3O0Rr20YIKv4FCgnZyZp50DK5omduCwwj7tMdP35UQVrY
         HLKDITZ/OHokeWU6AOb+r5ssGu3Cqnc2ABLR29I0bsDx/3IT+HD1sGci74Yek9nuoA
         0e0o7mF9GwW0PE/EcshtJnx4hUL5k0PWbp6v7BHQ5Ir9zfcVShfp8MaIbG+6bEYSVh
         ssT0pVGLrZqeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81DCDE6D447;
        Tue, 15 Feb 2022 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] virtio_net: Fix code indent error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164493541052.26708.11689283036672859693.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Feb 2022 14:30:10 +0000
References: <Ygi65QUzYL9oawO8@fedora>
In-Reply-To: <Ygi65QUzYL9oawO8@fedora>
To:     Michael Catanzaro <mcatanzaro.kernel@gmail.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 13 Feb 2022 02:01:41 -0600 you wrote:
> This patch fixes the checkpatch.pl warning:
> 
> ERROR: code indent should use tabs where possible #3453: FILE: drivers/net/virtio_net.c:3453: ret = register_virtio_driver(&virtio_net_driver);$
> 
> Uneccessary newline was also removed making line 3453 now 3452.
> 
> Signed-off-by: Michael Catanzaro <mcatanzaro.kernel@gmail.com>
> 
> [...]

Here is the summary with links:
  - virtio_net: Fix code indent error
    https://git.kernel.org/netdev/net-next/c/4f50ef152ec6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


