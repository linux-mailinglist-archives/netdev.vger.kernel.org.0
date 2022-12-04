Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF461641E26
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 18:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiLDRKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 12:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiLDRKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 12:10:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC48D1277A
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 09:10:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6579A60DEC
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 17:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2194C433D7;
        Sun,  4 Dec 2022 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670173828;
        bh=U2QP4wjkKmkYyM57GZxpb/YndiADR9hqOY6rbXfWCio=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ThoUHSGOgHl4PCyOLIxZHOk3qnzbthkbKGuYcp7AB9LwkLLFqQiZV9xBy3mk8Xxo9
         4kYN9cdTcpeFChTOx4g2Tdx+jLo0QE8M5yV3q9xYTenyubYsNGEoSa1fHvfa+NNNAF
         sov4gf5hNFuLRoRNeRvS97aerWz3CwgiQ6f4+YyZIDJP4pgclIdEhPRNqkDq7PxKwP
         E8YNwhPp68d5Ir9f20Tk2QgtpbR6dBRecd8Lo0lzVv3Rv1w9hEBAoUp5OnLSHh3QPQ
         +H3//xvj+yLlskFZJy2Z9kSEW7Vgr02EuZ7myETEulevx0iCM/lTpbCfkbi8dZZw6T
         NR+ZvIh2JxZpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A522CC41622;
        Sun,  4 Dec 2022 17:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next] ethtool: rings: report TCP header-data split
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167017382867.10380.11212671259728375374.git-patchwork-notify@kernel.org>
Date:   Sun, 04 Dec 2022 17:10:28 +0000
References: <20221130013557.90739-1-kuba@kernel.org>
In-Reply-To: <20221130013557.90739-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Tue, 29 Nov 2022 17:35:57 -0800 you wrote:
> Report if device is in HDS compatible mode or not.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  netlink/rings.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Here is the summary with links:
  - [ethtool-next] ethtool: rings: report TCP header-data split
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=3acf7eee7ade

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


