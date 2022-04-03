Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A684F0D0E
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 01:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376726AbiDCXwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 19:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355215AbiDCXwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 19:52:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0046127CD5;
        Sun,  3 Apr 2022 16:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DF7860FCE;
        Sun,  3 Apr 2022 23:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E34FAC340F3;
        Sun,  3 Apr 2022 23:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649029812;
        bh=qfZV7Dhd5nr5eNuhCIcYPdfMBnCJLTwYyEedtJhWN2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L4HBaEIQFfvLJXN/ZxkXK2Rf8zxDebS9RNWIhuN4+HFiag1tO+zWkJKBMPvnhhDCq
         fCwInqkEyPE9zYkffONY/sQ7GuknNb+VDMHif+DlWn5jbAMZGMoD+fQ4AQpO97k44R
         voesww62SbeYKArTKvEGf7LfPo1swnvROPsQ4y3c7OfGr3rVA+Z3oyHHGjpUIRL5Uq
         N2QrtBq5XO6jG4v+JXwGaS8mdgXx7tcotuvwcObPiz/hDVwOs2PaNWHyta9f+BO0oq
         PEbXDQPUnkWUCxGuoxCsj6HMTz6Prdh0npBP4LWrplrPgUUN+ihfxIQL28eN33dbBq
         6bL07M+WLKwuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3DD6E85BCB;
        Sun,  3 Apr 2022 23:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/bpf: Return true/false (not 1/0) from bool
 functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164902981179.6975.18361732639754204431.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Apr 2022 23:50:11 +0000
References: <1648779354-14700-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1648779354-14700-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 1 Apr 2022 10:15:54 +0800 you wrote:
> Return boolean values ("true" or "false") instead of 1 or 0 from bool
> functions.  This fixes the following warnings from coccicheck:
> 
> ./tools/testing/selftests/bpf/progs/test_xdp_noinline.c:567:9-10: WARNING:
> return of 0/1 in function 'get_packet_dst' with return type bool
> ./tools/testing/selftests/bpf/progs/test_l4lb_noinline.c:221:9-10: WARNING:
> return of 0/1 in function 'get_packet_dst' with return type bool
> 
> [...]

Here is the summary with links:
  - selftests/bpf: Return true/false (not 1/0) from bool functions
    https://git.kernel.org/bpf/bpf-next/c/f6d60facd9b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


