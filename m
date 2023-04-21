Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD36EA542
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjDUHut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjDUHum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:50:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9785D9025;
        Fri, 21 Apr 2023 00:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B5AB64E98;
        Fri, 21 Apr 2023 07:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B94BC433A4;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682063430;
        bh=LfpNnW1PKWScQQRDi0FPp7M6CFkoG+CMOF1Scnj1nXo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PIbhWUY4yYGyrSSlIaHGL5XwjoIKBrg6QK0F3fsP9RBmUFSQi5zJYgdlMEZkB03cB
         6ADk9uG2MjCSDr8+aOdQJwzn5p8//oDOHrw4aWDdW2aS3WDbpns1gCJWC6T95yjJ33
         oNEkDjZhw7fg4EhIOlKkpfiCCYoHanEBiTcim+2trFIUZyOT7MWoGwPh1oXeVcVoDU
         NFM5+NTa4NS2RY+hkfdhDy4+rijYSxZXYAMGEqrjPZ5FKc2Tr/Ku4WaXzxvECs9++H
         FAr4WYEox6P+4mLj7WGPVwFfgrT2hkiQuhKuDYYDOhAW32E4KZsaWVsuGDutbo0s8K
         WKAyah1dgkZHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FBA4E501E7;
        Fri, 21 Apr 2023 07:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] sctp: fix a plenty of flexible-array-nested
 warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168206343045.30967.17832699819530024509.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 07:50:30 +0000
References: <cover.1681917361.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1681917361.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Apr 2023 11:16:27 -0400 you wrote:
> Paolo noticed a compile warning in SCTP,
> 
> ../net/sctp/stream_sched_fc.c: note: in included file (through ../include/net/sctp/sctp.h):
> ../include/net/sctp/structs.h:335:41: warning: array of flexible structures
> 
> But not only this, there are actually quite a lot of such warnings in
> some SCTP structs. This patchset fixes most of warnings by deleting
> these nested flexible array members.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] sctp: delete the nested flexible array params
    https://git.kernel.org/netdev/net-next/c/add7370a3989
  - [net-next,2/6] sctp: delete the nested flexible array skip
    https://git.kernel.org/netdev/net-next/c/73175a042955
  - [net-next,3/6] sctp: delete the nested flexible array variable
    https://git.kernel.org/netdev/net-next/c/9789c1c6619e
  - [net-next,4/6] sctp: delete the nested flexible array peer_init
    https://git.kernel.org/netdev/net-next/c/f97278ff346a
  - [net-next,5/6] sctp: delete the nested flexible array hmac
    https://git.kernel.org/netdev/net-next/c/2ab399a931dd
  - [net-next,6/6] sctp: delete the nested flexible array payload
    https://git.kernel.org/netdev/net-next/c/dbda0fba7a14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


