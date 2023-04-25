Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACB66ED9BD
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbjDYBUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjDYBUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5015273;
        Mon, 24 Apr 2023 18:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D81E62AB0;
        Tue, 25 Apr 2023 01:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FC6FC4339B;
        Tue, 25 Apr 2023 01:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682385618;
        bh=yZwRz9+PyhKMxa9rQyOzzdknrwi/btHtPM6Ka6vP3Zk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VisHFfc6oODZq6D59uVIANgH+xv898tfYHwqzqAHI23MmMTv/shKg2cW7Fx8W4Ztt
         cmk/H8IfgdyrxK9hYeBksvwYNVyPjdM/KnbGSOq7mSLZRmeJRSG+5aFkMd+b5AdzHQ
         ah6cfyoOyC+Totf2skPjlxest+nIQys5i5rDEK7HvSFPirh1Qaao7d1S5Rwfbvbx69
         1pAdQk3nAZaouIgMCn2/sGexJ4ymuohNmECdjDSpTh53kgzmVg+kkYfGKGQ5AgK8gj
         4IVKb55RNE9b+eOHFhovpOKgUZwArwPP+yP24ohWg+LRSMLCiUXGzAOcr5Ds9XIm5E
         SKEoBoQLfoIxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DB74E5FFC7;
        Tue, 25 Apr 2023 01:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethtool: coalesce: try to make user settings
 stick twice
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238561818.11483.11632316588301382873.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:20:18 +0000
References: <20230420233302.944382-1-kuba@kernel.org>
In-Reply-To: <20230420233302.944382-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, mkubecek@suse.cz, corbet@lwn.net,
        dnlplm@gmail.com, linux-doc@vger.kernel.org, saeedm@nvidia.com,
        tariqt@nvidia.com, leonro@nvidia.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 16:33:02 -0700 you wrote:
> SET_COALESCE may change operation mode and parameters in one call.
> Changing operation mode may cause the driver to reset the parameter
> values to what is a reasonable default for new operation mode.
> 
> Since driver does not know which parameters come from user and which
> are echoed back from ->get, driver may ignore the parameters when
> switching operation modes.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethtool: coalesce: try to make user settings stick twice
    https://git.kernel.org/netdev/net-next/c/00d0f31a1ec8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


