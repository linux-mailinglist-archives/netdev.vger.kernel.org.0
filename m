Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE4A6C89AF
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 01:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjCYAkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 20:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCYAka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 20:40:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A871D40E3
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 17:40:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A5F8B826A9
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 00:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC0EAC4339B;
        Sat, 25 Mar 2023 00:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679704827;
        bh=Sd7bkE74MJZq1XJ4Kc2mO3b/IPRbqxBIfxvo5BXkiqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qIyTIMSuCiZzb+HOrg+lyToVhErCsEe2djXMkIKko0WGA9pGmiINtZKp3/cJRcuY7
         YYkPMjE9cKZhNj0ADXC8mf67Rkex9pSiwaNP1tOGNzzmnPJS2UGp6o7Xy1720DUbo5
         aXlHNoO62SsJhhc7SsqSwH+taKfumefdU4DIhuXieCJgZoWi5OQTPtfK3GnPixroWC
         XX7x+7fSKuQhAcNdduq7p8lpTwgqKePSuHIRNFUVe6CRl4MMbxR8PWkv5TgI2j2UMY
         ASOf6YGhNkW6kEWSGcZGek0iFpsy8MXPkIQcf1f1Z+JIvVnt/J9XLdDuYmdSnuvqZX
         6aAOgiv0NCVkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CEFCCE43EFD;
        Sat, 25 Mar 2023 00:40:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/7] bridge: mdb: Add VXLAN attributes support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167970482684.14221.6893055339500648185.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 00:40:26 +0000
References: <20230321130127.264822-1-idosch@nvidia.com>
In-Reply-To: <20230321130127.264822-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, razor@blackwall.org, petrm@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 21 Mar 2023 15:01:20 +0200 you wrote:
> Add support for new VXLAN MDB attributes.
> 
> See kernel merge commit abf36703d704 ("Merge branch
> 'vxlan-MDB-support'") for background and motivation.
> 
> Patch #1 updates the kernel headers.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/7] Update kernel headers
    (no matching commit)
  - [iproute2-next,2/7] bridge: mdb: Add underlay destination IP support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d36899c2244c
  - [iproute2-next,3/7] bridge: mdb: Add UDP destination port support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=42a96e81c85f
  - [iproute2-next,4/7] bridge: mdb: Add destination VNI support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c5b327e5707b
  - [iproute2-next,5/7] bridge: mdb: Add source VNI support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=9e49c798540c
  - [iproute2-next,6/7] bridge: mdb: Add outgoing interface support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a3f4565e0a64
  - [iproute2-next,7/7] bridge: mdb: Document the catchall MDB entries
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=be24eab05d66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


