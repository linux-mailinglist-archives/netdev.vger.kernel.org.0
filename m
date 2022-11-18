Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E490D62F440
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241315AbiKRMKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241651AbiKRMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B47194A79;
        Fri, 18 Nov 2022 04:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5A3B624B7;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01592C433D6;
        Fri, 18 Nov 2022 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668773416;
        bh=/qiIm2UoxfX4qAeSfNS/mC61sNM/rEaMnYB63kYSjlg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dmVPFn9EDNfDOKV6iTKsDl9kkNXu2lyB+sSmURq2fupf/aakucEIfk1QrgZpLRxq/
         g861YnzTzAjWFNB+PzfHck6KneMK9tZ1f9niApOFJx2Dko0kuFedzl+UlNew6vz4dR
         zlxDgW0/+nOLADsptOS9zF15lqq86UNR7MWCA/v7oEfCmFiMM1gAlX6DrPxU1JIHN5
         UrI8bC69NcQYxxKK29vO2z2BZEh90XlYwAg4ov2qf9EMoKQqNURAY18FekE6MKRPzd
         MxuJEdTIvmsSCy+qBw7jmWLTOp3q3qKxpAJ/gvuuePPXOmUlS2cCMozC13V7IKReOq
         zktKBD6qfOYow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DAD0CE50D71;
        Fri, 18 Nov 2022 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] selftests/net: fix missing xdp_dummy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877341589.19277.3482452287579643262.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:10:15 +0000
References: <1668653103-14212-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1668653103-14212-1-git-send-email-wangyufen@huawei.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kuba@kernel.org,
        shuah@kernel.org, pabeni@redhat.com, saeed@kernel.org,
        edumazet@google.com, davem@davemloft.net, deso@posteo.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 10:45:03 +0800 you wrote:
> After commit afef88e65554 ("selftests/bpf: Store BPF object files with
> .bpf.o extension"), we should use xdp_dummy.bpf.o instade of xdp_dummy.o.
> 
> In addition, use the BPF_FILE variable to save the BPF object file name,
> which can be better identified and modified.
> 
> Fixes: afef88e65554 ("selftests/bpf: Store BPF object files with .bpf.o extension")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> Cc: Daniel Müller <deso@posteo.net>
> 
> [...]

Here is the summary with links:
  - [net,v3] selftests/net: fix missing xdp_dummy
    https://git.kernel.org/netdev/net/c/302e57f809be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


