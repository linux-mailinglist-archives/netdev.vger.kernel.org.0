Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DA04BB101
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiBRFAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:00:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiBRFA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:00:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BBFD4CA0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3FBC61E66
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41045C340F6;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645160412;
        bh=mOUGjWYJ0nTZx+pCFoqlVWxOKy/UM6M7bAbH06XjoLU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o6waixkZ2umlbBI5elfhsoVSTej+XZiRItDLqP1YCUiv0x0NCPqee0aU78GV2dJfk
         ewgiNVN10Bs12ZwzuWkR633+IjW9uNZmdSwc/lDDpxfRCPfRXGlqRZaq0JS/9xlf/0
         8dcO5x2ZzNyE9nHC9CdwfAtZ/VE00bmPFf2x5hEEz2mN858BZx02J0L04FtcDde5+4
         S5Pd3fpQe7zJXr/02WhS63PR+TuPVlWTxRjMUYYIEVl5Ho6vNiU7p4fGkSMlyHkzhr
         f3arn0T+cD610sIaEs8Gwvl+w0XRp+zl8c9Vxv6Xrn3OSm5cURDpfDYyeEhS0/TRQj
         Y+s8IfIDwv9PQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27BB7E7BB0B;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add sanity check in proto_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164516041215.28752.12053704974859117600.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 05:00:12 +0000
References: <20220216171801.3604366-1-eric.dumazet@gmail.com>
In-Reply-To: <20220216171801.3604366-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Feb 2022 09:18:01 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> prot->memory_allocated should only be set if prot->sysctl_mem
> is also set.
> 
> This is a followup of commit 25206111512d ("crypto: af_alg - get
> rid of alg_memory_allocated").
> 
> [...]

Here is the summary with links:
  - [net-next] net: add sanity check in proto_register()
    https://git.kernel.org/netdev/net-next/c/f20cfd662a62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


