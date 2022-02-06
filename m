Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA064AAEF2
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 12:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiBFLKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 06:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiBFLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 06:10:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F22C06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 03:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D81460F4D
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 11:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D200C340F5;
        Sun,  6 Feb 2022 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644145809;
        bh=HZOoohQEbHxdMSp10kzpQPZvGQXUPoYhXI3MnMTZLgQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DRaM106ohGCMCAH+MCvH/j1/NG1K3/DDxdQP3FDNCt3cI4bbZoxqEpO6NggNvyGL+
         EIr3K3/jyzYymODKt4m4fARlyrSYFN85aoLWMBguCGsRzq8sOSwKM0NHNYpfbRfFCB
         Miy5cHYmAOoCtDFpZU0r9JAHNkJiGm36UF8E4WeJg1Jn+mMntUbs7Gv/WSh7fwCRyr
         Ceg0oYjNfDZMNS91dsb0pbf0WnhK6KBTyQ2wGDiBCvXobagHrWS25HHCxB/il6TtTN
         o32nwkF0c+UQJFkA24C8hVpgOKR75eQKADtMumu8K5UM+/fGaGRKeYidqM6j+RfxKj
         y4lxMFHe9yBFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D51FE6BBD2;
        Sun,  6 Feb 2022 11:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: initialize init_net earlier
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164414580937.29882.9458302181097916569.git-patchwork-notify@kernel.org>
Date:   Sun, 06 Feb 2022 11:10:09 +0000
References: <20220205170125.3562935-1-eric.dumazet@gmail.com>
In-Reply-To: <20220205170125.3562935-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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
by David S. Miller <davem@davemloft.net>:

On Sat,  5 Feb 2022 09:01:25 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While testing a patch that will follow later
> ("net: add netns refcount tracker to struct nsproxy")
> I found that devtmpfs_init() was called before init_net
> was initialized.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: initialize init_net earlier
    https://git.kernel.org/netdev/net-next/c/9c1be1935fb6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


