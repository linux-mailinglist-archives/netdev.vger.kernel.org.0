Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6215E650623
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 02:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiLSBuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 20:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLSBuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 20:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745A8B7D2
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 17:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28BE5B80B41
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 01:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF4C1C433EF;
        Mon, 19 Dec 2022 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671414616;
        bh=YKJaAfFLNgYc/2jAOX9GhtiU7j761ar7CK2jyGvTSdQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tbJ4NgGKU7AJOuNN8p2+8SM42ENisgdQWp1PgJBz2ny0lLLzaNhWXPPkpdOvgWmbW
         AmlXJ4hf1Jx59M7aUIbS0tEf09Tuqz2nDJDfjpmwpGaTlZ46VJuRUmAzmm2eSzJkJS
         bm1ihYVfIV0eSP75syjzXkL5KKAg8whMP9JqGLBXaBNVz46mJJSwYfn+Pcka15BF2J
         gZjiZW46RwLVhl1o7DNY84GHYfW8X3+LGG3bx2Se31zZAr7NeRNO2DfgAdVLIGvGfh
         cuUXGgl6F03Uon7X3M/NyfpowpIPsAb9v0drP3qDs+qh7rOnKJT67JXPSkB9n8l0kt
         tvS+5qHDjN+7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8AF6E21EEE;
        Mon, 19 Dec 2022 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/6] bridge: mdb: Add support for new attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167141461675.5035.9588492334033754295.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 01:50:16 +0000
References: <20221215175230.1907938-1-idosch@nvidia.com>
In-Reply-To: <20221215175230.1907938-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, razor@blackwall.org, mlxsw@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 15 Dec 2022 19:52:24 +0200 you wrote:
> Add support for new MDB attributes and replace command.
> 
> See kernel merge commit 8150f0cfb24f ("Merge branch
> 'bridge-mcast-extensions-for-evpn'") for background and motivation.
> 
> Patches #1-#2 are preparations.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/6] bridge: mdb: Use a boolean to indicate nest is required
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=935d942e6939
  - [iproute2-next,2/6] bridge: mdb: Split source parsing to a separate function
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c305c76a01e1
  - [iproute2-next,3/6] bridge: mdb: Add filter mode support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=7fe47f5160d3
  - [iproute2-next,4/6] bridge: mdb: Add source list support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=aa9a0b0fa9c2
  - [iproute2-next,5/6] bridge: mdb: Add routing protocol support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=7921c336dba4
  - [iproute2-next,6/6] bridge: mdb: Add replace support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9edecafda31e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


