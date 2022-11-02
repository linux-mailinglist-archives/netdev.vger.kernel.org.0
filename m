Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA95616270
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiKBMKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKBMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA7023141
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 05:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF54BB82213
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 12:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F8F8C433C1;
        Wed,  2 Nov 2022 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667391015;
        bh=K2N2s9yVmyKu4TopyIynJDSsSB6xvVHb7HF4h/pIBXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hUnKq7zlgh+xan5vGaQg89qidSRMk5nzfHI2JXxCL0dbtP+dnQsH1kcSeTW7f4Lns
         xupm91qpoWSQA9Qxnh/mQAFJWGxYwLnKAAcRnaSXU3PUFMKYjzRUrsekovQh1jdSjy
         K08hPNAdwwIt8133kIBXF5+0qB9/iE26Lv4Z3iDLQDGJQrdLa0j9ziJ5mIVjd4p5yE
         rkqNARt06X/QFloln4TVmf99hRBfPPYYotvYug/ZsWXKD3kPFGhfmnUc/3OtT42T7o
         VnHXAq/CZHRS1ZWY+/jTPKrGBSdLxXAHVlAZHMgkfftH+1F1VBL7oqbpi1NnFNaRRp
         gKkyFbZOMpMgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 450BCE270D5;
        Wed,  2 Nov 2022 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: Add KCOV annotations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739101527.14028.15470836593361803971.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 12:10:15 +0000
References: <20221030150337.3379753-1-dvyukov@google.com>
In-Reply-To: <20221030150337.3379753-1-dvyukov@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 30 Oct 2022 16:03:37 +0100 you wrote:
> Add remote KCOV annotations for NFC processing that is done
> in background threads. This enables efficient coverage-guided
> fuzzing of the NFC subsystem.
> 
> The intention is to add annotations to background threads that
> process skb's that were allocated in syscall context
> (thus have a KCOV handle associated with the current fuzz test).
> This includes nci_recv_frame() that is called by the virtual nci
> driver in the syscall context.
> 
> [...]

Here is the summary with links:
  - nfc: Add KCOV annotations
    https://git.kernel.org/netdev/net-next/c/7e8cdc97148c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


