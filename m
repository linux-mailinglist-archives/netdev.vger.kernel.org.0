Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D784B31DF
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 01:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354376AbiBLAUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 19:20:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242447AbiBLAUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 19:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF49D77;
        Fri, 11 Feb 2022 16:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB11461C65;
        Sat, 12 Feb 2022 00:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E48FC340EB;
        Sat, 12 Feb 2022 00:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644625210;
        bh=0zIZnmg6cx0oOGvsLFwIZcbJ3GzQws/5gbITP1ynZxE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tqAQVvhvpFhnlB/uIOph5mZq3c5vOEOHwkETa7oGTI6aouf7MhFfm95BvE3TwEcYK
         rsl2FGF7Sayyn0kfvfFT5fbb4L4UxUkI+f6Fn8Xd64nH3ld/qz8ucxOTbCYvBEdjie
         HkPK3VTza3Im7akOiPU74OZkW6PiX4MXdsfPUq8F0FRilCFmOlHYV8hQ7elzHzRcaN
         IdnXI9pPm8thVlM5st8fzcCe3l1OjE2Tt/XG64mHhjYWfKcWkEOLUuH6MdPDnfCuud
         tm13iz21ysklrmpqFeHXWwc2C7n1Ws1gnQSjrNjjAFRzAp2wN8/jGxH04rx8iggaAG
         kxUXGY6LwrVMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13B25E5D09D;
        Sat, 12 Feb 2022 00:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/9] use GFP_KERNEL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164462521007.28025.17507178732984421339.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Feb 2022 00:20:10 +0000
References: <20220210204223.104181-1-Julia.Lawall@inria.fr>
In-Reply-To: <20220210204223.104181-1-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        MPT-FusionLinux.pdl@broadcom.com, linux-crypto@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        s.shtylyov@omp.ru, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Feb 2022 21:42:14 +0100 you wrote:
> Platform_driver and pci_driver probe functions aren't called with
> locks held and thus don't need GFP_ATOMIC. Use GFP_KERNEL instead.
> 
> All changes have been compile-tested.
> 
> ---
> 
> [...]

Here is the summary with links:
  - [1/9] net: moxa: use GFP_KERNEL
    https://git.kernel.org/netdev/net-next/c/c9ac080b25d9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


