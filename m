Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405AC4D03BA
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244003AbiCGQLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:11:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235620AbiCGQLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:11:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8465438BF4
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 08:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2301260929
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89B8EC340EF;
        Mon,  7 Mar 2022 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646669410;
        bh=TipuxRGlANMCI4YbSnJ3YqYLCOi2dQzom/cau0SY/V4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ghjDKpO+VjrMiEiPf4nQ5xcfxnGmzLnIckC8kiR4FKlGvF2g7n4htSfKUHfMj8k9w
         v0gWxeyscpDB4ovpvUTD0OE6EpfRzgfY3NqlSiurJvEXuxrpjx5fMlzo4MY0IxrcJm
         GNW3Pexx7wsqAQ+fiWP+Sfzvq7Sz1sDaAil/plZMOdYxljYKFJhmPQO7bmXaQoiSYg
         Km/qU0ZuaRglDMUeF7v80LyrB8saCbqoxWw9WRU+gOh3t0U56OnhZ7K0wC4/QomaKO
         vXohkXNe7eZJCepTFsmQPQ9AyueK8AZg40GemSEmpGTBGisnzoRjlZBrIEGeUJMZz4
         6dlUZGUvlBaTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60A55EAC095;
        Mon,  7 Mar 2022 16:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 0/3] bpf: Work around libbpf deprecations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164666941039.4919.15259524787415977617.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Mar 2022 16:10:10 +0000
References: <20220228015840.1413-1-dsahern@kernel.org>
In-Reply-To: <20220228015840.1413-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun, 27 Feb 2022 18:58:37 -0700 you wrote:
> libbpf is deprecating APIs, so iproute2 needs to adapt. This will be
> an on-going effort, especially to handle legacy maps. This is a
> starter set for the low handing fruit.
> 
> David Ahern (3):
>   bpf_glue: Remove use of bpf_load_program from libbpf
>   bpf: Export bpf syscall wrapper
>   bpf: Remove use of bpf_create_map_xattr
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/3] bpf_glue: Remove use of bpf_load_program from libbpf
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=873bb9751f84
  - [iproute2-next,2/3] bpf: Export bpf syscall wrapper
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=ac4e0913beb1
  - [iproute2-next,3/3] bpf: Remove use of bpf_create_map_xattr
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=d9977eafa719

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


