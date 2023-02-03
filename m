Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B10688ED4
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 06:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjBCFK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 00:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjBCFKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 00:10:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918C43C3A;
        Thu,  2 Feb 2023 21:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E685BB8296B;
        Fri,  3 Feb 2023 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EEB3C4339C;
        Fri,  3 Feb 2023 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675401020;
        bh=8J/r8IZQdoK6kMHtccVyxYsr/VMnGN/M43P+7f3wljo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hcg8HWy/6h8/ZF5MdMqY+pykurfS+3ixb13VsQ0N3OXBp9ODXsiftV9BnGvdIGEC7
         iS63ZfCx65AX8c4RPIJVVZugM1lVHIeHdNC6J70FehKeZToPUrPCZHilfuBYdF74Xs
         TL+0kq3Ej0grLceKsZ5xDGLX3Ruu8a0ct3+gHBakB97XJrWPjY7UpunXwVrzTubY0K
         +6y9wH9f34bJjSrY3yVBbQ6rlFT0h6X8hddUjuBFHuw/vFG2oYbAL/+FanZhlT4QLv
         RiQW6cLw9kX6ryXLX2m/IVQNwYomC/RSTeV1TGoH1GHzQ570huX01m+KECTvEVU9IU
         DntWcHRgLIHKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DDD1E270C5;
        Fri,  3 Feb 2023 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 bpf-next 0/8] xdp: introduce xdp-feature support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167540102037.25226.11437925694181253004.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 05:10:20 +0000
References: <cover.1675245257.git.lorenzo@kernel.org>
In-Reply-To: <cover.1675245257.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        hawk@kernel.org, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        martin.lau@linux.dev, sdf@google.com, gerhard@engleder-embedded.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed,  1 Feb 2023 11:24:16 +0100 you wrote:
> Introduce the capability to export the XDP features supported by the NIC.
> Introduce a XDP compliance test tool (xdp_features) to check the features
> exported by the NIC match the real features supported by the driver.
> Allow XDP_REDIRECT of non-linear XDP frames into a devmap.
> Export XDP features for each XDP capable driver.
> Extend libbpf netlink implementation in order to support netlink_generic
> protocol.
> Introduce a simple generic netlink family for netdev data.
> 
> [...]

Here is the summary with links:
  - [v5,bpf-next,1/8] netdev-genl: create a simple family for netdev stuff
    https://git.kernel.org/bpf/bpf-next/c/d3d854fd6a1d
  - [v5,bpf-next,2/8] drivers: net: turn on XDP features
    https://git.kernel.org/bpf/bpf-next/c/66c0e13ad236
  - [v5,bpf-next,3/8] xsk: add usage of XDP features flags
    https://git.kernel.org/bpf/bpf-next/c/0ae0cb2bb22e
  - [v5,bpf-next,4/8] libbpf: add the capability to specify netlink proto in libbpf_netlink_send_recv
    https://git.kernel.org/bpf/bpf-next/c/8f1669319c31
  - [v5,bpf-next,5/8] libbpf: add API to get XDP/XSK supported features
    https://git.kernel.org/bpf/bpf-next/c/04d58f1b26a4
  - [v5,bpf-next,6/8] bpf: devmap: check XDP features in __xdp_enqueue routine
    https://git.kernel.org/bpf/bpf-next/c/b9d460c92455
  - [v5,bpf-next,7/8] selftests/bpf: add test for bpf_xdp_query xdp-features support
    https://git.kernel.org/bpf/bpf-next/c/84050074e51b
  - [v5,bpf-next,8/8] selftests/bpf: introduce XDP compliance test tool
    https://git.kernel.org/bpf/bpf-next/c/4dba3e7852b7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


