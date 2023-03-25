Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13276C8A38
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjCYCUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjCYCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3097272B1;
        Fri, 24 Mar 2023 19:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD07B826E0;
        Sat, 25 Mar 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FF65C4339C;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710818;
        bh=zPlJppdxeZ7aGPHr83MqRNkWMnJnftcskAyE/ssZENg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vRGOGM8q0XyLTlnOteRVwRjjMJwTB+bMzF6HZDgk9BOI0K9biLvBSF/R5Aw8FagZS
         XFAeLjLWU006pqn49l1TIIdHafjoOlPpTGC84uwqrMpdteoC+ooU4wp9EzJnPem3X0
         3tgFmyD6CVamFPysdU1N30OpEhewBe3ilyOYHo2dqaVhNu+o3gprGTiEs3B3cHxZV0
         QMR+HC7Am83iss8kfzsdh5NAn+g/psGqg5HUkVBy5bGrAp7qjncfy6p1CqEqPyMOwt
         ewoKUOVFasirOmh9GoH2pblR6kCME/nv/WdoWUF9MzS0voXlTNuaZ18tiIxDqCX7dy
         VYed7gaBSzt/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56823E43EFD;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] vmxnet3: use gro callback when UPT is enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167971081835.20950.6489165022839007946.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 02:20:18 +0000
References: <20230323200721.27622-1-doshir@vmware.com>
In-Reply-To: <20230323200721.27622-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        pv-drivers@vmware.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gyang@vmware.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 13:07:21 -0700 you wrote:
> Currently, vmxnet3 uses GRO callback only if LRO is disabled. However,
> on smartNic based setups where UPT is supported, LRO can be enabled
> from guest VM but UPT devicve does not support LRO as of now. In such
> cases, there can be performance degradation as GRO is not being done.
> 
> This patch fixes this issue by calling GRO API when UPT is enabled. We
> use updateRxProd to determine if UPT mode is active or not.
> 
> [...]

Here is the summary with links:
  - [net,v2] vmxnet3: use gro callback when UPT is enabled
    https://git.kernel.org/netdev/net/c/3bced313b9a5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


