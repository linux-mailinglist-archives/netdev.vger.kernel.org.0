Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2536458098E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbiGZCkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiGZCkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B61B492
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 19:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41843614AE
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 02:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 969D1C341CE;
        Tue, 26 Jul 2022 02:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658803213;
        bh=F0PHBgykYx1AWEo13bjHviydMaHKvPl4KlljfnaDMbg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qs3/YLOhaACWY6SwLMIjTsHRDzV4Uqt2IJHJ/uuqQmVozrcJbl94wKZyMmh+jYMDj
         MjBroeRBehCPfRVs6BCCmRGvrJ3Nrs6Cc3oMqnkmBMVDhcmlR07ZZ5vzpy9p8UXd9G
         EWTK422kuC92aBJiZJ2dXyw5ptVF0JyYaMbFAMcd/jD1P4Epocy6f6vNur9wUnGVBU
         ttBfVS2I/ZNf/kk43kWbwOXzeRAe97T25RpxLxdKs58w32XdbgtlhuwXNc44rtG38E
         zJfpD8TmVKTyKcp1FdCL3WnoVBIR1FkIN0gABM+kCPI+0yuon4aCmgiomWxonu/wrz
         FYoUayWRNe5SA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 80AE4E450B8;
        Tue, 26 Jul 2022 02:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fix reference counting for LAG FDBs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165880321352.6105.9951339486290692125.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 02:40:13 +0000
References: <20220723012411.1125066-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220723012411.1125066-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 23 Jul 2022 04:24:11 +0300 you wrote:
> Due to an invalid conflict resolution on my side while working on 2
> different series (LAG FDBs and FDB isolation), dsa_switch_do_lag_fdb_add()
> does not store the database associated with a dsa_mac_addr structure.
> 
> So after adding an FDB entry associated with a LAG, dsa_mac_addr_find()
> fails to find it while deleting it, because &a->db is zeroized memory
> for all stored FDB entries of lag->fdbs, and dsa_switch_do_lag_fdb_del()
> returns -ENOENT rather than deleting the entry.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: fix reference counting for LAG FDBs
    https://git.kernel.org/netdev/net/c/c7560d1203b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


