Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3336DDC55
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDKNkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjDKNkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB99FA0;
        Tue, 11 Apr 2023 06:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88D4D620A8;
        Tue, 11 Apr 2023 13:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5C50C4339C;
        Tue, 11 Apr 2023 13:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681220417;
        bh=+mcosQD7xAKmkNfph3YWGYNTH9lqnjV6zMuAsjZy07A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WvXOaoN+b9sQj+B2xEc3KsO9v6eItlX9yIqX5GZBxn8VEs7mxSqwt8eWgc2aI5SLb
         9jUxertHwH2b+DP/3CYVocrkAL785cvDiLVhKo0Tqxd8SCCHClh5f8LJuUyFhMzJZX
         H/fUTVIeXAfp934qwAdLwp7939PTmbMN8ODOczgU5+jylaSbAPDihr3RyZaLTx439Y
         doSx6phNzE3UO6vtSXT3OiMOIVeKNX2sl9PvEj7DhrPBVjt1oGW+FKUeI9Exjqwpnb
         5C7ydPF8NXsA7mk1bRAbpE5fsS6auAONx7Dp5knkDeYVqCtKVoQ5ditf/CnBzroPdy
         vB4pcdAWm6U0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB9C4C395C3;
        Tue, 11 Apr 2023 13:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168122041776.18873.15440663190856247219.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Apr 2023 13:40:17 +0000
References: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Thu,  6 Apr 2023 12:59:04 +0300 you wrote:
> Unregister PTP clock when the driver is removed.
> Purge the RX and TX skb queues.
> 
> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> 
> [...]

Here is the summary with links:
  - [net] net: phy: nxp-c45-tja11xx: add remove callback
    https://git.kernel.org/netdev/net/c/a4506722dc39

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


