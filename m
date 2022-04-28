Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2F4513E1E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbiD1VyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352732AbiD1Vx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C644A5FF2;
        Thu, 28 Apr 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B7C61F84;
        Thu, 28 Apr 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6E11C385BE;
        Thu, 28 Apr 2022 21:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651182612;
        bh=x5OnaX+XkqyXoOld6XiV9RU/QQ1gGo8AZycsnccJS60=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PTCb8t5oJbECW+/PCbB1nNmObh9rEhyKTTMwsjLi7ml6XE/bEM4cLzOCi7579ai9d
         n+4qqp4N1iIWmPi6o8/axbsBrpuxdnRIsgJV4tsMfQQHz9Lby40txxwcoQkedBPP6v
         qb/DuoPvIdiikGPiDjBXWiymHtOdpiLhhyUrfc1Zqx0XzkTEFePGdJT728vUT/lntQ
         NOQmy8NaVHN1P2Q83zFWKxs54V6ANeqyDWY+DEeBgKPop+adNXjFAWgXkOvFNQjo6g
         OGSPV1tM0eFyjNx1zqS/CSMiWWeaKFUXw1ylVInxmS5oHyCE3VqUN6fSkN28ZyU3/X
         Wc9Bxca/pjm9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C750F03875;
        Thu, 28 Apr 2022 21:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 sockmap: Call skb_linearize only when required in
 sk_psock_skb_ingress_enqueue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165118261257.31667.7823567869619454038.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Apr 2022 21:50:12 +0000
References: <20220427115150.210213-1-liujian56@huawei.com>
In-Reply-To: <20220427115150.210213-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

On Wed, 27 Apr 2022 19:51:50 +0800 you wrote:
> The skb_to_sgvec fails only when the number of frag_list and frags exceeds
> MAX_MSG_FRAGS. Therefore, we can call skb_linearize only when the
> conversion fails.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
>  net/core/skmsg.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf, sockmap: Call skb_linearize only when required in sk_psock_skb_ingress_enqueue
    https://git.kernel.org/bpf/bpf-next/c/3527bfe6a92d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


