Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023844DBD22
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358483AbiCQClc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347531AbiCQCl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:41:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C565E1FCFB;
        Wed, 16 Mar 2022 19:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DED2B81C82;
        Thu, 17 Mar 2022 02:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E51D6C340F6;
        Thu, 17 Mar 2022 02:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484811;
        bh=8pn2md7+yRt4KkNAYLCMUowOoceFRQMyZgx1w7OZISY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ECE1xOc9OQlskBw2YcJErZjar4cvtI8eQ7TcI/30VpXH/aYWU1sFiAeLezuUQs0oQ
         f1YBJEhdWi8XyMeE1N7hTdYUfHiacDr45w20LHR/hrQYKQ6sF4PeURmF2xU6sRAvSM
         LLnG3mqrODeGtQmNm0ettktI7GhQ5WD6P4CKOPCfwmlc+qIMtc38PKWj8QW+jWfpqC
         txcQqdJNPf5GrlYjC9Vf2v6MZpn9yxAWnvaeJxjuCoZsUIX8yoaFb9p+w+K3ANIBJi
         ntHiLTjHIJ/zjBUVqjJbJqcQFiZiJd6IwtpXeaVyng9ActESn1Q70TjyzX/UGjm1zf
         +4yFSF9Q8Pa5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7A52E6BBCA;
        Thu, 17 Mar 2022 02:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: Never offload FDB entries on standalone
 ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748481081.31245.8103171886335821025.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:40:10 +0000
References: <20220315233033.1468071-1-tobias@waldekranz.com>
In-Reply-To: <20220315233033.1468071-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 00:30:33 +0100 you wrote:
> If a port joins a bridge that it can't offload, it will fallback to
> standalone mode and software bridging. In this case, we never want to
> offload any FDB entries to hardware either.
> 
> Previously, for host addresses, we would eventually end up in
> dsa_port_bridge_host_fdb_add, which would unconditionally dereference
> dp->bridge and cause a segfault.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: Never offload FDB entries on standalone ports
    https://git.kernel.org/netdev/net-next/c/a860352e9dd0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


