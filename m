Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71754AF12F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiBIMPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232818AbiBIMOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:14:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073AFC02B5C3
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8101E616D9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2A1DC340EB;
        Wed,  9 Feb 2022 12:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408009;
        bh=eBn4DkAF5EC3TsLh3I2un7Ot7jgYTo2ZSgQFemnuS4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d5US8zuZ7KxxdX02j3bgAG0NFYho0HJpnwyEZFDS+TCGLQmOEcqN5KHKY4W7UHha7
         JZJMYkdD0nEBPGI8p1spFxshVH9mQiUTVIbdIg7MueygfV+lXhEMSBItRUjCi7tEig
         /mL2yrlGmFrumFTnH96/uFtPbZSwIFewbuuegN5IlApv/R8J+RZWX9WSB3cmGs5hu4
         Ivpz12Z+O7nmsdMcYPQ+BcuGyhe1gB0zPVifpGf7KlPh7DiLQ5CsEpG45B/3OawZDS
         dT26j3SaCWpeAi8xBP6jCqybYN6H3uwv/2PLaeitAgLlYz2BgdqcQAfCRV3ReyEUCb
         lF3HfWaOWh1JQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB159E6D45A;
        Wed,  9 Feb 2022 12:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net: fix issues when uncloning an skb dst+metadata
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440800982.11178.11547441686052846325.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:00:09 +0000
References: <20220207171319.157775-1-atenart@kernel.org>
In-Reply-To: <20220207171319.157775-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vladbu@nvidia.com, pabeni@redhat.com, pshelar@ovn.org,
        daniel@iogearbox.net
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  7 Feb 2022 18:13:17 +0100 you wrote:
> Hi,
> 
> This fixes two issues when uncloning an skb dst+metadata in
> tun_dst_unclone; this was initially reported by Vlad Buslov[1]. Because
> of the memory leak fixed by patch 2, the issue in patch 1 never happened
> in practice.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: do not keep the dst cache when uncloning an skb dst and its metadata
    https://git.kernel.org/netdev/net/c/cfc56f85e72f
  - [net,v2,2/2] net: fix a memleak when uncloning an skb dst and its metadata
    https://git.kernel.org/netdev/net/c/9eeabdf17fa0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


