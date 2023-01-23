Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDCC678547
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjAWSuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjAWSuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2061116E;
        Mon, 23 Jan 2023 10:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2440CB80DA8;
        Mon, 23 Jan 2023 18:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE815C433D2;
        Mon, 23 Jan 2023 18:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674499818;
        bh=El03s2JclWZ3++W6dfgBJQpv9Ba8wnNzIApSy3pEB0k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k4etS7zdFiQcCqExioWkihSFTrjjSJWoRL/H6n+BFEHzq5Gs4T8ERnbNxfznSqbzw
         oPNIBajY+EbIdOaZvOUaLgf4b7yetZmmg0M8bvchcPe3G2rN/cvi+NA1UTDL7sT5Yl
         16vmUoyS5yFle68rbh23PbTs/6EEWyU+2/JERnuL6sneFt/7byOZsdsWBKD6ZZxzLf
         RskXWVurZMn1EvHiEW7bKneM2ujZv49g7M2mFoHGMGZaaDqE+dFSpEyIfSsYnjNP6X
         W3mWAwKc/NSc7+4DUWlM6bEHMRlHaQ9ynulsQLMxPfrQvM2s2MpGxu5aQV8yR0wTNU
         SA+KiFzJ3VHKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B8B5C5C7D4;
        Mon, 23 Jan 2023 18:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167449981862.32273.6138380319680894402.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 18:50:18 +0000
References: <20230119221536.3349901-1-sdf@google.com>
In-Reply-To: <20230119221536.3349901-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org, dsahern@gmail.com,
        kuba@kernel.org, willemb@google.com, brouer@redhat.com,
        anatoly.burakov@intel.com, alexandr.lobakin@intel.com,
        magnus.karlsson@gmail.com, mtahhan@redhat.com,
        xdp-hints@xdp-project.net, netdev@vger.kernel.org
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
by Martin KaFai Lau <martin.lau@kernel.org>:

On Thu, 19 Jan 2023 14:15:19 -0800 you wrote:
> Please see the first patch in the series for the overall
> design and use-cases.
> 
> See the following email from Toke for the per-packet metadata overhead:
> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
> 
> Recent changes:
> - Keep new functions in en/xdp.c, do 'extern mlx5_xdp_metadata_ops' (Tariq)
> 
> [...]

Here is the summary with links:
  - [bpf-next,v8,01/17] bpf: Document XDP RX metadata
    (no matching commit)
  - [bpf-next,v8,02/17] bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
    (no matching commit)
  - [bpf-next,v8,03/17] bpf: Move offload initialization into late_initcall
    (no matching commit)
  - [bpf-next,v8,04/17] bpf: Reshuffle some parts of bpf/offload.c
    (no matching commit)
  - [bpf-next,v8,05/17] bpf: Introduce device-bound XDP programs
    (no matching commit)
  - [bpf-next,v8,06/17] selftests/bpf: Update expected test_offload.py messages
    (no matching commit)
  - [bpf-next,v8,07/17] bpf: XDP metadata RX kfuncs
    (no matching commit)
  - [bpf-next,v8,08/17] bpf: Support consuming XDP HW metadata from fext programs
    (no matching commit)
  - [bpf-next,v8,09/17] veth: Introduce veth_xdp_buff wrapper for xdp_buff
    (no matching commit)
  - [bpf-next,v8,10/17] veth: Support RX XDP metadata
    (no matching commit)
  - [bpf-next,v8,11/17] selftests/bpf: Verify xdp_metadata xdp->af_xdp path
    (no matching commit)
  - [bpf-next,v8,12/17] net/mlx4_en: Introduce wrapper for xdp_buff
    (no matching commit)
  - [bpf-next,v8,13/17] net/mlx4_en: Support RX XDP metadata
    (no matching commit)
  - [bpf-next,v8,14/17] xsk: Add cb area to struct xdp_buff_xsk
    (no matching commit)
  - [bpf-next,v8,15/17] net/mlx5e: Introduce wrapper for xdp_buff
    https://git.kernel.org/bpf/bpf-next/c/384a13ca8a5d
  - [bpf-next,v8,16/17] net/mlx5e: Support RX XDP metadata
    https://git.kernel.org/bpf/bpf-next/c/bc8d405b1ba9
  - [bpf-next,v8,17/17] selftests/bpf: Simple program to dump XDP RX metadata
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


