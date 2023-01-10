Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D51664EA2
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbjAJWUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbjAJWUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41AC5D6BE;
        Tue, 10 Jan 2023 14:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798D561919;
        Tue, 10 Jan 2023 22:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C84A3C433D2;
        Tue, 10 Jan 2023 22:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673389216;
        bh=lbp/oumyRbS397ILy+tofOg0sef9kMcgf/3vqKGwb2g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kp2C65VS/wHDstEUXcR0ATFxIUiDR7l05GPaldy8ZT1jUFo38e/3p/UTeVTMb3IUr
         vjfMzNJEcxh9eEp8FWI+PBX/M+mNC5JlSdtua/+8ZDgesKDJZHeeAncqz4Qi2rSuYh
         hOQ+jZ5oOT8D/qTU+psUChsg1HFV4hrsto7N4n519PzCkjU4VQ1AElNhKWPTgvc7Qk
         YNqPtsQc+rqIbPwvHbF0D01D2pY+Okp4lL3VFDETE5D4gm+TGOd1obfTuYVeq0GU10
         gFsFufX2ZiDYgUNq7a6JgFsZyxqhGfa7Ib6MgU+t4o3uKYQArHkC6P5qcd7/Dwg63N
         65VPkH9P0Hsrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABA9CE21EE8;
        Tue, 10 Jan 2023 22:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v1] bpf: Remove the unnecessary insn buffer
 comparison
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167338921669.701.5149917434879547711.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 22:20:16 +0000
References: <20230108151258.96570-1-haiyue.wang@intel.com>
In-Reply-To: <20230108151258.96570-1-haiyue.wang@intel.com>
To:     Wang@ci.codeaurora.org, Haiyue <haiyue.wang@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  8 Jan 2023 23:12:57 +0800 you wrote:
> The variable 'insn' is initialized to 'insn_buf' without being changed,
> only some helper macros are defined, so the insn buffer comparison is
> unnecessary, just remove it.
> 
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
> ---
>  net/core/filter.c | 6 ------
>  1 file changed, 6 deletions(-)

Here is the summary with links:
  - [bpf-next,v1] bpf: Remove the unnecessary insn buffer comparison
    https://git.kernel.org/bpf/bpf-next/c/66cf99b55e58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


