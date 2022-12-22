Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2400653A7C
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 03:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbiLVCKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 21:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLVCKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 21:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29D623BC5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 18:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88A44619A2
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 02:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD00EC433F0;
        Thu, 22 Dec 2022 02:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671675016;
        bh=rSpmwkRTaLQOmGEviUU2r3MWorMHDB25C39dpj8s8bo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nscTCBA6X1qxcaJhO9tYxvBHls8DEljTbki084mKnpRo05IJCXHRNUkstKwQIjsEw
         StggsUVjW3cLFXhGJLtOcbVvX//ULSJaA7BaRHO2H5Rhhn47ynQOiRsGhWc+gej5jx
         fSTqDgUb0vNB2Iu/oOMf20cQJISqONFU/bpnLby8rdNK+THwt22ibq8X7KhEBQr9QV
         OYFh0bzUAtpn5mX4LyQZ1EqCzpgCCZPz/NOMBNXZOo1Zc0bulZ0V6VifCS8MNiDn2U
         8qJC4qg00cGjK4HebDE/0Eqh7a35ZPtzKZIIzMUFsplnR10l8G2wAvFu3YgZxEDipH
         +PM5+L1RYyz3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0631C43141;
        Thu, 22 Dec 2022 02:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: fix schedule in atomic context when sync mc address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167167501678.18442.13537636877757391877.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 02:10:16 +0000
References: <20221220152100.1042774-1-simon.horman@corigine.com>
In-Reply-To: <20221220152100.1042774-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yinjun.zhang@corigine.com, louis.peens@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Dec 2022 16:21:00 +0100 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> The callback `.ndo_set_rx_mode` is called in atomic context, sleep
> is not allowed in the implementation. Now use workqueue mechanism
> to avoid this issue.
> 
> Fixes: de6248644966 ("nfp: add support for multicast filter")
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Reviewed-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net] nfp: fix schedule in atomic context when sync mc address
    https://git.kernel.org/netdev/net/c/e20aa071cd95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


