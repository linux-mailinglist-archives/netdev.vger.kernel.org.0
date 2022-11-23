Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807F6634F31
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 05:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235696AbiKWEwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 23:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbiKWEwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 23:52:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFD8D5A3D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 20:52:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BE54CE2081
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11DCAC433D6;
        Wed, 23 Nov 2022 04:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179129;
        bh=k+iTX4a28n6HackCx+mZuL0A01QPigfmrAR9JJ+fwcg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YIH1xwz2zLD9PlTwzlmDgJef3pqjqKtor6uVCONxeYNasGTmNUmDJqE3pxcLUQqjB
         XEva3vVMJiI69La+w0INNF5iDZKORR8B7B7Lm+SHj/dBCI+IMR5Ma8yXe2n79nvycO
         fZVdnfzqgfhd4DXvMuFPbjSKVc7832/Dnyd5yygjSLK9n2HK3tG81GVKCDEHfdd3aU
         93IwxFJM0unBCGGUlDQo55MuiTw+d3hmjoNSnV1MwZAu0qfyjeg0WJ3kbi+HITLaRA
         nyXEliZtN9oNjbA9AbN2Iys7hOEeEzOGisNzCwaqvJNCpvhydhYAXZf8vgA8C6zOij
         eV9NqF5nUHpAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EAB5AE29F42;
        Wed, 23 Nov 2022 04:52:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/17] Remove dsa_priv.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917912895.11566.4765304704525405153.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 04:52:08 +0000
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Nov 2022 15:55:38 +0200 you wrote:
> After working on the "Autoload DSA tagging driver when dynamically
> changing protocol" series:
> https://patchwork.kernel.org/project/netdevbpf/cover/20221115011847.2843127-1-vladimir.oltean@nxp.com/
> 
> it became clear to me that the situation with DSA headers is a bit
> messy, and I put the tagging protocol driver macros in a pretty random
> temporary spot in dsa_priv.h.
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] net: dsa: unexport dsa_dev_to_net_device()
    https://git.kernel.org/netdev/net-next/c/c5fb8ead3283
  - [net-next,02/17] net: dsa: modularize DSA_TAG_PROTO_NONE
    https://git.kernel.org/netdev/net-next/c/d2be320495b9
  - [net-next,03/17] net: dsa: move bulk of devlink code to devlink.{c,h}
    https://git.kernel.org/netdev/net-next/c/5cf2c75b5b91
  - [net-next,04/17] net: dsa: if ds->setup is true, ds->devlink is always non-NULL
    https://git.kernel.org/netdev/net-next/c/d95fa75061fb
  - [net-next,05/17] net: dsa: move rest of devlink setup/teardown to devlink.c
    https://git.kernel.org/netdev/net-next/c/7aea535d40ea
  - [net-next,06/17] net: dsa: move headers exported by port.c to port.h
    https://git.kernel.org/netdev/net-next/c/022bba63c3ca
  - [net-next,07/17] net: dsa: move headers exported by master.c to master.h
    https://git.kernel.org/netdev/net-next/c/94ef6fad3bf3
  - [net-next,08/17] net: dsa: move headers exported by slave.c to slave.h
    https://git.kernel.org/netdev/net-next/c/09f92341681a
  - [net-next,09/17] net: dsa: move tagging protocol code to tag.{c,h}
    https://git.kernel.org/netdev/net-next/c/bd954b826032
  - [net-next,10/17] net: dsa: move headers exported by switch.c to switch.h
    https://git.kernel.org/netdev/net-next/c/0c603136e1e0
  - [net-next,11/17] net: dsa: move dsa_tree_notify() and dsa_broadcast() to switch.c
    https://git.kernel.org/netdev/net-next/c/6dbdfce77357
  - [net-next,12/17] net: dsa: move notifier definitions to switch.h
    https://git.kernel.org/netdev/net-next/c/495550a4844b
  - [net-next,13/17] net: dsa: merge dsa.c into dsa2.c
    https://git.kernel.org/netdev/net-next/c/165c2fb93bed
  - [net-next,14/17] net: dsa: rename dsa2.c back into dsa.c and create its header
    https://git.kernel.org/netdev/net-next/c/47d2ce03dcfb
  - [net-next,15/17] net: dsa: move definitions from dsa_priv.h to slave.c
    https://git.kernel.org/netdev/net-next/c/8e396fec2146
  - [net-next,16/17] net: dsa: move tag_8021q headers to their proper place
    https://git.kernel.org/netdev/net-next/c/19d05ea712ec
  - [net-next,17/17] net: dsa: kill off dsa_priv.h
    https://git.kernel.org/netdev/net-next/c/5917bfe68867

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


