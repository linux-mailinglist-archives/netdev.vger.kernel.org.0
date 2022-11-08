Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0D962057A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiKHBAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiKHBAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22921274B;
        Mon,  7 Nov 2022 17:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63CF861371;
        Tue,  8 Nov 2022 01:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8436C433C1;
        Tue,  8 Nov 2022 01:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667869214;
        bh=NzdoA8JKXpRi4Mo04FhYp2vHFN/SjWC7Jl63ukiOSFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eqwvlOorw0s5VhYAm3mIwUpt2ahClzt6c1GXVFoI42dMqUaNTQNuymVJVx6A8KA7I
         VN3zrVkGLioQHykbxUthBbslBfYNmuCQ3DUrJKRozGF+5q+XEX3p2tbdmdMumiGdd8
         xPoj/vnpvgHj/XTipbxCkxGsuv3odXsI6di+uDgG4wp2RWreOb+TgJLUnIgIppVnxS
         oyXTqmzGlvL2WvKncLnlfGduMLJ0LtI1H96gvQ3bzqH5+30Lf7HbB+Zhx9wEthMVV6
         JQbLM0BHyUzDak/Y9O9xiVH5cEu8qEDpDARlaTrwV/T+3Y8erkZjRAwzhXvzQduj9I
         5rLXhWUzBNPWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BBE8E270D0;
        Tue,  8 Nov 2022 01:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] selftests/bpf: Fix u32 variable compared with less than
 zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166786921463.3686.15198701863007119520.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 01:00:14 +0000
References: <20221105183656.86077-1-tegongkang@gmail.com>
In-Reply-To: <20221105183656.86077-1-tegongkang@gmail.com>
To:     Kang Minchul <tegongkang@gmail.com>
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        rdunlap@infradead.org, netdev@vger.kernel.org,
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
by Martin KaFai Lau <martin.lau@kernel.org>:

On Sun,  6 Nov 2022 03:36:56 +0900 you wrote:
> Variable ret is compared with less than zero even though it was set as u32.
> So u32 to int conversion is needed.
> 
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [v3] selftests/bpf: Fix u32 variable compared with less than zero
    https://git.kernel.org/bpf/bpf-next/c/e8f50c4f0c14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


