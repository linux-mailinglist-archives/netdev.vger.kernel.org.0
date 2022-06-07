Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E333540008
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 15:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244705AbiFGNaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 09:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbiFGNaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 09:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7F3D19E6;
        Tue,  7 Jun 2022 06:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07AE561484;
        Tue,  7 Jun 2022 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5159BC34119;
        Tue,  7 Jun 2022 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654608612;
        bh=zyhrWRXdVXO+HYqEJk8OrrgU5Np0Uk7LNBouSz/WdWk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ScN+2e1u3+nDzZk/Al7r1+6WF1/wNS0eV+otewgvoNfOjHPb2KfMd1X/bldLpTCnb
         AAbYk3HnKiIUFUlMwrPUF2rpCiJ+dd2+0MN8sFOWVoxJ+wlUZpc4JoqEs1bcvuB9a2
         h2ZiF1bKQsR8b6YchGandWN+7DtI5GRgYVNhKiaTL6aLSxes4cN4BLcdyTW3axXO7H
         Xko5T/ioQy3I7z40H1xCTLC80OtIyWMg/YNyKyLZelyTEkYa6Z6kYzw+nbKIxEn7qZ
         EPEKyNQBM7QQkm3L4hhfic9xpioxdOLfYPMvpLbhrSbYRTByyTsq2yvXK/sbbL1HaH
         gUd/mRMYm4+Zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33CDEE737E2;
        Tue,  7 Jun 2022 13:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] selftests net: fix bpf build error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165460861220.26982.2362920387757777214.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Jun 2022 13:30:12 +0000
References: <20220606064517.8175-1-lina.wang@mediatek.com>
In-Reply-To: <20220606064517.8175-1-lina.wang@mediatek.com>
To:     Lina Wang <lina.wang@mediatek.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, matthias.bgg@gmail.com, maze@google.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 6 Jun 2022 14:45:17 +0800 you wrote:
> bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add more
> including path.
> 
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Lina Wang <lina.wang@mediatek.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> [...]

Here is the summary with links:
  - [v3] selftests net: fix bpf build error
    https://git.kernel.org/netdev/net/c/cf67838c4422

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


