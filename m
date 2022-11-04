Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D42619BA5
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiKDPa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiKDPaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21DBBDE;
        Fri,  4 Nov 2022 08:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E30D62253;
        Fri,  4 Nov 2022 15:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92127C433C1;
        Fri,  4 Nov 2022 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667575817;
        bh=yVWLz9FMK0It7JNN/T7TbqoK4oQe43YfxM+SawRuh1o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RdmbuCUG1EDB3C+LdRxYCln8FjkZ6AHicTI3reOWYvOZgA9B7klKrCttC7+zdO/Rp
         SlQTAmGjrqHnGNNzkHVZgNEfNm6+Ityk5FFLBwGZuUuf4N4bIEUxcw4cxuW9qkqJbB
         CwFeI6ijI70oQ9p023rOoJZPRwiNuuBzcK7yYg9hLbwjSR+NkdkDsAbhr1TFS3XmE+
         wAjIq2P6gMIkkR5Ba2hHscp5zRDNWQOHWlEONarQogkdfMJ/Ei7zp3WTwmy/PMsm+p
         bvjB+xGkEdUfCuBZUFmKjEQJ4m5Y5uWaN2tlZ8DwCL2O5vJIcjftybglrpwodUCL0M
         2hX2uCxdYgqCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77105E270FB;
        Fri,  4 Nov 2022 15:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next,v2] bpf,
 test_run: fix alignment problem in bpf_prog_test_run_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166757581748.5056.10393237526996888663.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 15:30:17 +0000
References: <20221102081620.1465154-1-zhongbaisong@huawei.com>
In-Reply-To: <20221102081620.1465154-1-zhongbaisong@huawei.com>
To:     Baisong Zhong <zhongbaisong@huawei.com>
Cc:     edumazet@google.com, keescook@chromium.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, glider@google.com, elver@google.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Wed, 2 Nov 2022 16:16:20 +0800 you wrote:
> we got a syzkaller problem because of aarch64 alignment fault
> if KFENCE enabled.
> 
> When the size from user bpf program is an odd number, like
> 399, 407, etc, it will cause the struct skb_shared_info's
> unaligned access. As seen below:
> 
> [...]

Here is the summary with links:
  - [-next,v2] bpf, test_run: fix alignment problem in bpf_prog_test_run_skb()
    https://git.kernel.org/bpf/bpf/c/d3fd203f36d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


