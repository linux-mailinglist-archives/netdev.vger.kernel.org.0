Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672A964532F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLGEuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiLGEuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE3525E81;
        Tue,  6 Dec 2022 20:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB7E261A22;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27C09C4314C;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670388617;
        bh=SS19KTUuoXhli5zXM84MrpfOzkjrwtTLFWR/WgxGEEI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RjOhFO+JEBl4sQtCg32BMGLjapa5zDyYfBt1fDnyR3EqkWGlrdNgS1FsY3v+Tqx7A
         nwMwZIElXrVziB8ip8JCZki3HDaCYsVMLjgiRB6MwYSdPaiWIO/i8lR1o0c7BEjAX8
         781cXJ3E4PuHHl6GV/L/k2uf9D+3WlmbjZE5spYytuIvSX99jrCvDFyxhFN07u0WNk
         zS5eDrM9BagpiPPtfx1cHs6pndpiJGRm8LIFq8WH4oKkiqQchiRbN2SqeomZ/i3Z/O
         yqwaLgxGKLq/yUiK9YIajALg9zk33PKFURKLZXQDdtz2NIscqA7a7G059wevvRdnwk
         fFfI3z/J9CNkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B0AAE4D02C;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: =?utf-8?q?=5BPATCH_net-next_v2=5D_sfc=3A_use_sysfs=5Femit=28=29_to_?=
        =?utf-8?q?instead_of_scnprintf=28=29?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038861704.25696.4633988505306967141.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:50:17 +0000
References: <202212051021451139126@zte.com.cn>
In-Reply-To: <202212051021451139126@zte.com.cn>
To:     <ye.xingchen@zte.com.cn>
Cc:     leon@kernel.org, davem@davemloft.net, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, petrm@nvidia.com, khalasa@piap.pl,
        shayagr@amazon.com, wsa+renesas@sang-engineering.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 5 Dec 2022 10:21:45 +0800 (CST) you wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] sfc: use sysfs_emit() to instead of scnprintf()
    https://git.kernel.org/netdev/net-next/c/1ab586f5177b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


