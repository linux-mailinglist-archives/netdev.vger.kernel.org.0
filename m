Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDE761ED6D
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiKGIuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiKGIuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DD015A13;
        Mon,  7 Nov 2022 00:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31FC1B80E6B;
        Mon,  7 Nov 2022 08:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF3D5C43470;
        Mon,  7 Nov 2022 08:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667811015;
        bh=DwR4PbtQVE5wpoJY9KuWV7/XWsVC3U4ti2JdPzfpfvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hc+BoSJZUhCTOf+O/FMwJ++ugO7vY7WZ6ZKwHSW2zsFT645Sk3XSF0jb/7kievCgJ
         +5vI4sh9Y9uLAq2bjlMwn06HB5losjFOJf2F1LhtOu9ZoMJcAkWg57ZXyYoG2tYm+H
         3IO9xKPL3ImDzAglM7gNspUG+A+hAuZaIf6EXDCeTMZw8gBJtaaDASXAdc7gtvAYBj
         WP6YfPuQsnjt0P+ejrd39YegpD4Urb6zJ96dY7U9+3Lp7rg5/vkQ7HhXH1XQheR2v9
         LVldmToz7tGDQGdytepDG2eGFkZ2X563HA5pVbLLTUxz3MLdonarsK5ne7NgBXFBVN
         RoRvougJfVqow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6983C4166D;
        Mon,  7 Nov 2022 08:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6] net: mv643xx_eth: support MII/GMII/RGMII modes for
 Kirkwood
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166781101567.969.3739834944008609773.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 08:50:15 +0000
References: <20221028020104.347329-1-mmyangfl@gmail.com>
In-Reply-To: <20221028020104.347329-1-mmyangfl@gmail.com>
To:     David Yang <mmyangfl@gmail.com>
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 10:01:01 +0800 you wrote:
> Support mode switch properly, which is not available before.
> 
> If SoC has two Ethernet controllers, by setting both of them into MII
> mode, the first controller enters GMII mode, while the second
> controller is effectively disabled. This requires configuring (and
> maybe enabling) the second controller in the device tree, even though
> it cannot be used.
> 
> [...]

Here is the summary with links:
  - [v6] net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood
    https://git.kernel.org/netdev/net-next/c/d08cb2555677

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


