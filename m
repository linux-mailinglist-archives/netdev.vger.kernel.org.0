Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83AC24EFBD0
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 22:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352633AbiDAUwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 16:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiDAUwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 16:52:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F601C2DB8;
        Fri,  1 Apr 2022 13:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D79B8256E;
        Fri,  1 Apr 2022 20:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1283DC34111;
        Fri,  1 Apr 2022 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648846212;
        bh=nBewJA1omraV3t/qyTbglQVwRWbbs+x7FUrALbLD0rw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RL8z/G+xVTlRSYKAn67Bh7NhDK6lKrawD7HU48abnN4pCtcGEr1TUxSPPSUQPygGW
         yX1G/EL397wFTTSRx+8RqFgHzFzuQ1HqO1Jiqte83ySiRKI4FjInPvJP/GyfsGs4+K
         6oko/58YrzcHxLVpElwYWo5QOO2YHu3jN4LxhG47A0F8uHLaE3Dvi+tj2vislSOBBM
         i2Ld1XE573V++oOBZVWJ45nWG7he0JTDmnzdP3jDVBvMSYxK2PX/VaxzsSvsh7U0F+
         sYVcgHbDPgF5NEiiG3j9WLtMc2VupABLwVjiCMqGgMjNDvDgIUO7sJo4TfUd34f4ot
         vAOePbvoZvx9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8B34F03849;
        Fri,  1 Apr 2022 20:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] selftests/bpf: remove unused variable from bpf_sk_assign
 test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164884621194.13250.4816833185387587676.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 20:50:11 +0000
References: <20220329154914.3718658-1-eyal.birger@gmail.com>
In-Reply-To: <20220329154914.3718658-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
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
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 29 Mar 2022 18:49:14 +0300 you wrote:
> Was never used in bpf_sk_assign_test(), and was removed from
> handle_{tcp,udp} in commit 0b9ad56b1ea6
> ("selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test")
> 
> Fixes: 0b9ad56b1ea6 ("selftests/bpf: Use SOCKMAP for server sockets in bpf_sk_assign test")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> [...]

Here is the summary with links:
  - [bpf] selftests/bpf: remove unused variable from bpf_sk_assign test
    https://git.kernel.org/bpf/bpf-next/c/fe4625d8b053

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


