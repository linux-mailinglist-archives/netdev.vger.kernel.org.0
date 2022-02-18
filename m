Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F344BC07F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 20:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbiBRTua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 14:50:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiBRTua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 14:50:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB68C28F97D;
        Fri, 18 Feb 2022 11:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60885CE330C;
        Fri, 18 Feb 2022 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFE50C340EB;
        Fri, 18 Feb 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645213809;
        bh=S4IdBf2XreFNqqHaj1lxm4+4ZtqP0gHL12eYgACfgAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RO+L+MuxAXEw6U+neGD5OCTQ9a+ZmNnw6oDhsfSgc6OMA79etIlj8gmXvUFkxriWL
         wFV1Uim+74Hwrec6Xjmhdqak9m4eBoM2MWX/Vs0LZQg6ItdmNCiYFAWqdcyn3B0NUi
         5OMlsMKxjhdUyOwD4crqhPwPa665vtYEnwq91KpFrdqCHU3BkTymYLNUzaoTL8s2Py
         XY2gVTFYrjvt2R2VEFv1vVqmoNo6smkYC8rUOaEs+rEQW57pFxorcquT+BlFp5lgN4
         h85wOxsedd5MrbYu/qnfHGG68DiIsEP/otomvjusPFsn01uISLUmU6Bkx8DeyLezpv
         69vZwp+EzQ+8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AAB8AE7BB0B;
        Fri, 18 Feb 2022 19:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Call maybe_wait_bpf_programs() only once from
 generic_map_delete_batch()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164521380969.19810.13719948944848986210.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 19:50:09 +0000
References: <20220218181801.2971275-1-eric.dumazet@gmail.com>
In-Reply-To: <20220218181801.2971275-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, bpf@vger.kernel.org,
        sdf@google.com, brianvv@google.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 18 Feb 2022 10:18:01 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> As stated in the comment found in maybe_wait_bpf_programs(),
> the synchronize_rcu() barrier is only needed before returning
> to userspace, not after each deletion in the batch.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Brian Vazquez <brianvv@google.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Call maybe_wait_bpf_programs() only once from generic_map_delete_batch()
    https://git.kernel.org/bpf/bpf-next/c/9087c6ff8dfe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


