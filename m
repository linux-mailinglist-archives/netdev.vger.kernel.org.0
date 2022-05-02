Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566BD517968
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 23:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387723AbiEBVxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 17:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245442AbiEBVxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 17:53:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA16EB06
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 14:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 400CD6120A
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C6CCC385A4;
        Mon,  2 May 2022 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651528212;
        bh=1Rga05jdN68g1bl8JD4+g/FNGOIx5bJ8OMf2ApWYOkk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BVk8WyKxZpLFIgDlIRHfBeFTbwi7oHquhoAzY9jnUOwnbNJklx3xm1P1OyHsqKhwE
         XWDkwuoxFu+lLOY93+l2sU/5Foy5w9qqaTpyEwE9I1Z/QFQFWnXZ17q2sMHO4TypEo
         /xQv/7OwKU/Y5BsCJ2AKejdblGIxP70wLzDc/TMFXH3oIUpqE+4OTNiDilZmJG7K92
         srEYg5sY/6JeNO+l2w3uD/2bIOoRKHAwEyqHGgPvHIGxACaAdZb5793PbfaaSlPE57
         D5ugzfKuy8wjAa/P2GSGRcf7PAm02vdx/kRaQPmNRN4LWs+H6Jn17YgDuN4T97JD7Z
         AIVJfeDTOAtSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83C96F03841;
        Mon,  2 May 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/3] Address more libbpf deprecations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165152821253.23338.14495514806997162473.git-patchwork-notify@kernel.org>
Date:   Mon, 02 May 2022 21:50:12 +0000
References: <20220423152300.16201-1-dsahern@kernel.org>
In-Reply-To: <20220423152300.16201-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        toke@redhat.com, haliu@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sat, 23 Apr 2022 09:22:57 -0600 you wrote:
> Another round of changes to handle libbpf deprecations. Compiles are
> clean as of libbpf commit 533c7666eb72 ("Fix downloads formats").
> 
> David Ahern (3):
>   libbpf: Use bpf_object__load instead of bpf_object__load_xattr
>   libbpf: Remove use of bpf_program__set_priv and bpf_program__priv
>   libbpf: Remove use of bpf_map_is_offload_neutral
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/3] libbpf: Use bpf_object__load instead of bpf_object__load_xattr
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ba6519cbcb28
  - [iproute2-next,2/3] libbpf: Remove use of bpf_program__set_priv and bpf_program__priv
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=64e5ed779f5d
  - [iproute2-next,3/3] libbpf: Remove use of bpf_map_is_offload_neutral
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=837294e45252

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


