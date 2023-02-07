Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C835668E338
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBGWAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBGWAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4542E384;
        Tue,  7 Feb 2023 14:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8232B61300;
        Tue,  7 Feb 2023 22:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4674C433EF;
        Tue,  7 Feb 2023 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675807218;
        bh=MRr49VUTHh/imivKIQsSXIdNqP5fWF5KMtq90y7gLC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ct8UDqA/segng8tzlgQvAnn3Cnegk24i878G6vcPvQq/0d7/zv1lxpEmT3E8sXM16
         9ZqFg89wgc5bEx4aVF/nUUsspqncy9AhcICFE3kq+6iJ2JiiS/dU7w+f0rQRqbCC/r
         Y++TBvAF10VkuFiUApMP4ED/ceRRZlQaIDPij+gnIzVLt/ddpdIpLUdStH77Fv5CD1
         MrQs9pSHN7fiBpYRyn+tUuWKIEzF3T+kdGl1aQ9i/45e/qqtVO2FCin7TZNYdmBFRY
         T/N6YC/MhaZO0pjblbYJVTbw7fWdkMjB9ZNg9SoB+ZTpM8uSSPCOZS524/+7NVXOU3
         NMCDjw7yTzIQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4EF8E21ECB;
        Tue,  7 Feb 2023 22:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: always use libbpf_err to return an error in
 bpf_xdp_query()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167580721780.15405.5992302071244638036.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 22:00:17 +0000
References: <827d40181f9f90fb37702f44328e1614df7c0503.1675768112.git.lorenzo@kernel.org>
In-Reply-To: <827d40181f9f90fb37702f44328e1614df7c0503.1675768112.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue,  7 Feb 2023 12:11:03 +0100 you wrote:
> In order to properly set errno, rely on libbpf_err utility routine in
> bpf_xdp_query() to return an error to the caller.
> 
> Fixes: 04d58f1b26a4 ("libbpf: add API to get XDP/XSK supported features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/lib/bpf/netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] libbpf: always use libbpf_err to return an error in bpf_xdp_query()
    https://git.kernel.org/bpf/bpf-next/c/02fc0e73e852

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


