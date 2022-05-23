Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDD5531767
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbiEWSqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244530AbiEWSqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795D513CA2F;
        Mon, 23 May 2022 11:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD22360EFA;
        Mon, 23 May 2022 18:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38C7AC34115;
        Mon, 23 May 2022 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653330612;
        bh=ldOlWU/sFDboKzmSs2d15K53+qfF7cRhmm/mXvh/rH4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ey7e5Yb2SkWigE4SiYIlvfA9d4Q/dUbfry7ImvbBATUbnZivHqkD/GOKxLFqH2wmG
         2XbvzGk4o4eAIYikpcyzZDZMH/VY+H6Bk0U5uroOp7Vn80vKRNA0aCTx9mYhu2iLac
         of6IP3Mgf9HADdaeTFNFLG5zf5GK+arTr1joGsGTaSRX0UT5U2WPigwnoOyXlZ6bUP
         a49hPu0PgapzMjNEJRik0aSdSGAVmkYtnfJMmQfWcCgSjY4MvNO9kcx3HoGwJzEj7e
         c26vqOosvSu+VCrChn8V/08rdVUjbhcye/r1l0oTW0XGvaTd11SNqWR4djFOazLdxY
         mU0guJE1SSiSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 188C7F03935;
        Mon, 23 May 2022 18:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] s390/bpf: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165333061209.5065.9063882337989202641.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 18:30:12 +0000
References: <20220521111145.81697-84-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-84-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     iii@linux.ibm.com, kernel-janitors@vger.kernel.org,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Sat, 21 May 2022 13:11:34 +0200 you wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  arch/s390/net/bpf_jit_comp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - s390/bpf: fix typo in comment
    https://git.kernel.org/bpf/bpf-next/c/ff2095976ca8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


