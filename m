Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7D2679576
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjAXKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjAXKkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:40:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E6A2D45;
        Tue, 24 Jan 2023 02:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DCEE60E86;
        Tue, 24 Jan 2023 10:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99C50C433EF;
        Tue, 24 Jan 2023 10:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674556818;
        bh=l4Tu+EbMZL36A9gZdOLyolqouv6pJfcDpasghfLPFEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j4OmV8gx5NyhGAIT8ZU2jRBXWr/X0w3ku6wGI9KzMGrKQgxTX8P+QAHR9yXxLyeLE
         QnGxcNGiYugA1wlOQl3RCBSiQD3liLSFxPfq9Nl+eG1CVyCwbmw8I0TvS1Ha3rdR5F
         +bicpxiry7eVSEwYVqYXFKJImqaVFkF/mdmj+A7zpFnUu1usanLCG9C/zBGCVIivQx
         nrHKrASvDQKTnPsLJefD8oOKnqi3AyQMWo9t5DlbwlDaduHv2bMw24q8UpOvtB0SZS
         mVv2B/4a7OfwXftqOabd8cZUR14mEp6zvI3bvIOTjEJlH033j0FdCS5jyfQepRPAyW
         s9Vvr1TL4OhLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82598E52508;
        Tue, 24 Jan 2023 10:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/8] Netlink protocol specs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167455681853.26386.14381375194899546381.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 10:40:18 +0000
References: <20230120175041.342573-1-kuba@kernel.org>
In-Reply-To: <20230120175041.342573-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 20 Jan 2023 09:50:33 -0800 you wrote:
> I think the Netlink proto specs are far along enough to merge.
> Filling in all attribute types and quirks will be an ongoing
> effort but we have enough to cover FOU so it's somewhat complete.
> 
> I fully intend to continue polishing the code but at the same
> time I'd like to start helping others base their work on the
> specs (e.g. DPLL) and need to start working on some new families
> myself.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/8] docs: add more netlink docs (incl. spec docs)
    https://git.kernel.org/netdev/net-next/c/9d6a65079c98
  - [net-next,v4,2/8] netlink: add schemas for YAML specs
    https://git.kernel.org/netdev/net-next/c/e616c07ca518
  - [net-next,v4,3/8] net: add basic C code generators for Netlink
    https://git.kernel.org/netdev/net-next/c/be5bea1cc0bf
  - [net-next,v4,4/8] netlink: add a proto specification for FOU
    https://git.kernel.org/netdev/net-next/c/4eb77b4ecd3c
  - [net-next,v4,5/8] net: fou: regenerate the uAPI from the spec
    https://git.kernel.org/netdev/net-next/c/3a330496baa8
  - [net-next,v4,6/8] net: fou: rename the source for linking
    https://git.kernel.org/netdev/net-next/c/08d323234d10
  - [net-next,v4,7/8] net: fou: use policy and operation tables generated from the spec
    https://git.kernel.org/netdev/net-next/c/1d562c32e439
  - [net-next,v4,8/8] tools: ynl: add a completely generic client
    https://git.kernel.org/netdev/net-next/c/e4b48ed460d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


