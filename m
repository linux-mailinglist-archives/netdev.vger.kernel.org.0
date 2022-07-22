Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B836D57D950
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiGVEKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGVEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979C81582E;
        Thu, 21 Jul 2022 21:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2049162034;
        Fri, 22 Jul 2022 04:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66EB4C341CA;
        Fri, 22 Jul 2022 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658463018;
        bh=T3OTnT6JXnGMkPLRI43V4DmcD+75jV6haXIUuqrw9q4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l/0uGgWsL9e9xEu2UuDggNiSmCNJipVr5FIIrlBHpPEyuM+70dUDxW4ca4OyUbIwk
         Ev6cL0sAS4XidE9AsSEXYCN/edFMx38weSXV0P1YQuqzp+rv1SKKxPNvCqgXYrzR71
         rWz9jEpxRXjCBV7Yssrb50l1EUlJ1tpoLY+soLinCWwL9NN4Vt5teFUjpktrBL9zVG
         jjz8L8aTRCfae4Rj0Is25/XyFfdR4CWqbOppfEFiGZj55LE1LlYe3PBXRGrUxKvE0W
         6yXc4j2Bl9KKwlnNMf4ybxvS+uF8r0qK8ehQBorc/dAAms1xs3dBBrDErkmgCqXfSy
         rwcER8Fcdoc3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49BB5E451B8;
        Fri, 22 Jul 2022 04:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v7 00/13] New nf_conntrack kfuncs for insertion,
 changing timeout, status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165846301827.26375.18363403275263691735.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 04:10:18 +0000
References: <20220721134245.2450-1-memxor@gmail.com>
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        daniel@iogearbox.net, pablo@netfilter.org, fw@strlen.de,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 21 Jul 2022 15:42:32 +0200 you wrote:
> Introduce the following new kfuncs:
>  - bpf_{xdp,skb}_ct_alloc
>  - bpf_ct_insert_entry
>  - bpf_ct_{set,change}_timeout
>  - bpf_ct_{set,change}_status
> 
> The setting of timeout and status on allocated or inserted/looked up CT
> is same as the ctnetlink interface, hence code is refactored and shared
> with the kfuncs. It is ensured allocated CT cannot be passed to kfuncs
> that expected inserted CT, and vice versa. Please see individual patches
> for details.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v7,01/13] bpf: Introduce 8-byte BTF set
    https://git.kernel.org/bpf/bpf-next/c/ab21d6063c01
  - [bpf-next,v7,02/13] tools/resolve_btfids: Add support for 8-byte BTF sets
    https://git.kernel.org/bpf/bpf-next/c/ef2c6f370a63
  - [bpf-next,v7,03/13] bpf: Switch to new kfunc flags infrastructure
    https://git.kernel.org/bpf/bpf-next/c/a4703e318432
  - [bpf-next,v7,04/13] bpf: Add support for forcing kfunc args to be trusted
    https://git.kernel.org/bpf/bpf-next/c/56e948ffc098
  - [bpf-next,v7,05/13] bpf: Add documentation for kfuncs
    https://git.kernel.org/bpf/bpf-next/c/63e564ebd1fd
  - [bpf-next,v7,06/13] net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
    https://git.kernel.org/bpf/bpf-next/c/aed8ee7feb44
  - [bpf-next,v7,07/13] net: netfilter: Add kfuncs to allocate and insert CT
    https://git.kernel.org/bpf/bpf-next/c/d7e79c97c00c
  - [bpf-next,v7,08/13] net: netfilter: Add kfuncs to set and change CT timeout
    https://git.kernel.org/bpf/bpf-next/c/0b3892364431
  - [bpf-next,v7,09/13] net: netfilter: Add kfuncs to set and change CT status
    https://git.kernel.org/bpf/bpf-next/c/ef69aa3a986e
  - [bpf-next,v7,10/13] selftests/bpf: Add verifier tests for trusted kfunc args
    https://git.kernel.org/bpf/bpf-next/c/8dd5e75683f7
  - [bpf-next,v7,11/13] selftests/bpf: Add tests for new nf_conntrack kfuncs
    https://git.kernel.org/bpf/bpf-next/c/6eb7fba007a7
  - [bpf-next,v7,12/13] selftests/bpf: Add negative tests for new nf_conntrack kfuncs
    https://git.kernel.org/bpf/bpf-next/c/c6f420ac9d25
  - [bpf-next,v7,13/13] selftests/bpf: Fix test_verifier failed test in unprivileged mode
    https://git.kernel.org/bpf/bpf-next/c/e3fa4735f04d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


