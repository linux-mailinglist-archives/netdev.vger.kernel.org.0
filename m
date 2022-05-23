Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46122531BAE
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbiEWSrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244613AbiEWSqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:46:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A050813FD47;
        Mon, 23 May 2022 11:30:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87F9EB81221;
        Mon, 23 May 2022 18:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3E21CC34117;
        Mon, 23 May 2022 18:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653330612;
        bh=zWVDv4dbGwoq4snZdUxm70TnPh1v/67voIzRwGurLvo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fSkBk3ZMYZUd+ampc3vwe7YX/RUaWjctKGslJC8EqpHg0kd2NMSQ8eYgcibGBH7u1
         ih2R+wNAS8yhPGQnZhUeNkOAj/wsyMWP3URkMQTmiGil1DKsObSviYFWyi59zj1iwy
         d6tCqXrx2jXFto/4oNyldOmwG96hX6TbrGZ6bRTWSVIpxUhLyAaS70yNwc012eGjyD
         D6CpLPWykUOU5BBGLkNdIH3sRLkU/F5pxtVYgsxMbV2bbnf86DbaswC5Kdl/+VXF5G
         uEFTzxKRSpcZk5UFR9/drUeKzTs62DVY3STsU+oqi1onmvN3qdYISq/J89ZvjcNEZU
         rk1HRSZcHgQ7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 22FD8F03948;
        Mon, 23 May 2022 18:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] libbpf: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165333061214.5065.10109451382087512586.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 18:30:12 +0000
References: <20220521111145.81697-71-Julia.Lawall@inria.fr>
In-Reply-To: <20220521111145.81697-71-Julia.Lawall@inria.fr>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     ast@kernel.org, kernel-janitors@vger.kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sat, 21 May 2022 13:11:21 +0200 you wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> 
> ---
>  tools/lib/bpf/libbpf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - libbpf: fix typo in comment
    https://git.kernel.org/bpf/bpf-next/c/bb412cf1d712

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


