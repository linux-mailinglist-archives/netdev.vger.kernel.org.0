Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAA3581585
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239245AbiGZOkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiGZOkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245AC5FB3;
        Tue, 26 Jul 2022 07:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D3A61685;
        Tue, 26 Jul 2022 14:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F126EC433D7;
        Tue, 26 Jul 2022 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658846414;
        bh=58nLY8A3acskXVMMHzm+L8+NW02xjgBW66So2sA/ZjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AbCZP7JiXhx1B/Ri/IQtepSr28EzEOWCKzNJMfrHrNtrfwCEzkkJLpb08WSbiUa8p
         GHPm0NKAt21o2q58bhaVQ4wm8HUVy42CpAR3l6MGUHopTBfJqOZEznn+L83xqU/QsX
         lhB+j5KJ17mbXSCyjLtjt5ySv18tiqiXa2IgAjKXjRpGlQ9wKnSqbB2RZUAa3XfBJo
         pwUEHY5FHB4MIfNYxy84rioif8+r8FlLYANlwn/qz4BSmUJ04TqSG0WAvnAFYbzH31
         Mx8NrtZyLPWF3j5UJPD8ntIB7XB0Q6QoByuhutc93335cG2iPUoJGAHWBpijujnuTR
         hELFKua2V7z0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D789BC43143;
        Tue, 26 Jul 2022 14:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: devmap: compute proper xdp_frame len
 redirecting frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165884641387.27442.17431202446790497710.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 14:40:13 +0000
References: <894d99c01139e921bdb6868158ff8e67f661c072.1658596075.git.lorenzo@kernel.org>
In-Reply-To: <894d99c01139e921bdb6868158ff8e67f661c072.1658596075.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Sat, 23 Jul 2022 19:17:10 +0200 you wrote:
> Even if it is currently forbidden to XDP_REDIRECT a multi-frag xdp_frame
> into a devmap, compute proper xdp_frame length in __xdp_enqueue and
> is_valid_dst routines running xdp_get_frame_len().
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  kernel/bpf/devmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf: devmap: compute proper xdp_frame len redirecting frames
    https://git.kernel.org/bpf/bpf-next/c/bd82ea52f0ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


