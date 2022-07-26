Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EE7581176
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238791AbiGZKuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbiGZKue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:50:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905E226AC6;
        Tue, 26 Jul 2022 03:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48EDAB815BA;
        Tue, 26 Jul 2022 10:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6DB3C341CD;
        Tue, 26 Jul 2022 10:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658832631;
        bh=O9JFBzsVxC1Y8I7S6QbE/gHIKDcVYivp+KctWv0gM9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SMs/O01ReJV0CME6WqfVFjU5LnZsK5L+wK2JMLMpH+rQcU7US3SUMYb3ers9LHnqi
         YeO/7/09VCcv2WhrF1EyubyWAs9P9iqxMLC9Fk7oeFp6v6ngRgTQXDRJlhwicvMpNU
         TmSPoyEpU7eiwLYlv5mFxPockVlUr60V76DsnTAb2ipqfSk6gAvKihqffyW87hMIQB
         YL+ox3614BGmO5NeYQ5RJa3XL+puzWMqT4fCWOZWmj7a5IJYEPC1DtcSrDhB4pCX0q
         0o01gDMifGV0EZrr+yKySt9IzNSnymJCwWdTVyO8GSlhql9aRsmiJml1uZA+ty2mx5
         D+7l9Fes7Sr6g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBFBAE450B1;
        Tue, 26 Jul 2022 10:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v3 0/5] bpf: Allow any source IP in
 bpf_skb_set_tunnel_key
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165883263082.5700.11737632699729605210.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 10:50:30 +0000
References: <cover.1658759380.git.paul@isovalent.com>
In-Reply-To: <cover.1658759380.git.paul@isovalent.com>
To:     Paul Chaignon <paul@isovalent.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, martin.lau@linux.dev,
        john.fastabend@gmail.com, fankaixi.li@bytedance.com,
        razor@blackwall.org, yhs@fb.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon, 25 Jul 2022 16:31:07 +0200 you wrote:
> Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> added support for getting and setting the outer source IP of encapsulated
> packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> allows BPF programs to set any IP address as the source, including for
> example the IP address of a container running on the same host.
> 
> In that last case, however, the encapsulated packets are dropped when
> looking up the route because the source IP address isn't assigned to any
> interface on the host. To avoid this, we need to set the
> FLOWI_FLAG_ANYSRC flag.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v3,1/5] ip_tunnels: Add new flow flags field to ip_tunnel_key
    https://git.kernel.org/bpf/bpf-next/c/451ef36bd229
  - [bpf-next,v3,2/5] vxlan: Use ip_tunnel_key flow flags in route lookups
    https://git.kernel.org/bpf/bpf-next/c/7e2fb8bc7ef6
  - [bpf-next,v3,3/5] geneve: Use ip_tunnel_key flow flags in route lookups
    https://git.kernel.org/bpf/bpf-next/c/861396ac0b47
  - [bpf-next,v3,4/5] bpf: Set flow flag to allow any source IP in bpf_tunnel_key
    https://git.kernel.org/bpf/bpf-next/c/b8fff748521c
  - [bpf-next,v3,5/5] selftests/bpf: Don't assign outer source IP to host
    https://git.kernel.org/bpf/bpf-next/c/1115169f47ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


