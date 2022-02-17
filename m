Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191FB4BA917
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 20:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244870AbiBQTA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 14:00:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244862AbiBQTA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 14:00:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3B16E7AB;
        Thu, 17 Feb 2022 11:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E76FB82407;
        Thu, 17 Feb 2022 19:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F9CAC340EB;
        Thu, 17 Feb 2022 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645124410;
        bh=IlZlLLRHulbKaNR3PYrnahpdg4uzKgHomUVngp85NW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B9jgrA8NKn28wPvnL26pH5tWN3UM4w++YaGomNgXlrdXLMA99Orcr6wEK6lqe2TKm
         DlzJ8Ving6bAT3lelUtOgA1RIWq6WrtJd+6K4fS4KtPCO4LptUnJayvPI1sy+FgV2B
         ANUPxilBXdQoMmUdsBH6z/8DnpxK7KWZq/sCFWApk3iVp4fiSUPChjW90KlfoYEMWK
         3Y99ZQFjhJP+ji9hpxOlQcrln2groTDa0KYIgNDVBGq5iT0wDJ/zrPNrruf5e53srm
         cUew5KWUMWY4eS6HZNFiLlJMys3yyGO0Z/J3HrO4nheVDEMbxRhFuxI0dRKaanplNh
         POeCBwKRl406Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 579BAE6D447;
        Thu, 17 Feb 2022 19:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf: add schedule points in batch ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164512441035.13752.14208532235999007957.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 19:00:10 +0000
References: <20220217181902.808742-1-eric.dumazet@gmail.com>
In-Reply-To: <20220217181902.808742-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, bpf@vger.kernel.org,
        brianvv@google.com, sdf@google.com, syzkaller@googlegroups.com
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

This patch was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 17 Feb 2022 10:19:02 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported various soft lockups caused by bpf batch operations.
> 
>  INFO: task kworker/1:1:27 blocked for more than 140 seconds.
>  INFO: task hung in rcu_barrier
> 
> [...]

Here is the summary with links:
  - [bpf] bpf: add schedule points in batch ops
    https://git.kernel.org/bpf/bpf/c/75134f16e7dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


