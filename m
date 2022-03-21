Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B814E3419
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiCUXOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiCUXNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:13:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B794152E4;
        Mon, 21 Mar 2022 16:01:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 586BEB81AB7;
        Mon, 21 Mar 2022 23:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC6FAC36AE5;
        Mon, 21 Mar 2022 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647903612;
        bh=w1CtTPCxfIvq7QQwhD9WawNhvXWJlgd38o8mrvIUSp0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rdwxO+WUIn17cEs0dYTJbJvduoofvupzK6ixnlIqIcevlzytNJ1l2OBNohOErzZQf
         B77dxZ4pu4M8Zd5on89WhWX2bgZwhEqTUSKyv48X25tn/O8YeSg4LhL3sPO+JgwfVI
         GicGmVjQiXFLOHNfJhx500Cx/tnzM5rlXMvWqHDFwQNv2IwbD+jFwVp3K/PqenRkaW
         G+JJayQAadmw+03640gejzblW+g0IIzrVzbQ6r6dEwwX3v/y+9469Ho6VU0dz7+osR
         yLPFwwwJsJF8o8Dojxr71OP97TJ9VFj9BEb41fr8ArMrEUmKS2seBuEAzPDS+BmVpI
         gfHlPheZpN0rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C23F3EAC096;
        Mon, 21 Mar 2022 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: dsa: mv88e6xxx: MST Fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164790361179.11439.10221727606089268354.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 23:00:11 +0000
References: <20220318201321.4010543-1-tobias@waldekranz.com>
In-Reply-To: <20220318201321.4010543-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kabel@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Mar 2022 21:13:19 +0100 you wrote:
> 1/2 fixes the issue reported by Marek here:
> 
> https://lore.kernel.org/netdev/20220318182817.5ade8ecd@dellmb/
> 
> 2/2 adds a missing capability check to the new .vlan_msti_set
> callback.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: mv88e6xxx: Require ops be implemented to claim STU support
    https://git.kernel.org/netdev/net-next/c/afaed2b142a1
  - [net-next,2/2] net: dsa: mv88e6xxx: Ensure STU support in VLAN MSTI callback
    https://git.kernel.org/netdev/net-next/c/bd48b911c88f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


