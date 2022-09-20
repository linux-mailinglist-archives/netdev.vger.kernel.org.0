Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29415BECC7
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 20:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiITSaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 14:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiITSaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 14:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EEB1ADB0
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 11:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12D6962C46
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 18:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 670F1C433D7;
        Tue, 20 Sep 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663698617;
        bh=we308shpWzkIfkESJSf5KeNfvtcWqDmuBtFoN+Lo8FQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tvc1AhYq17YbN4i7FLyPeaRlxI9hkxoJjfk5imwcWfmHZfkukda/Z1wth8CiLtk9j
         lkpUkt5DeYUXH9M/dC/NrC89hQDQGCQ5G5HaCKMSOFO43Ltj0GZ4oylJiqeMCoESTx
         X5rGhpn/MV6Us6eLQ4gkzm8+zPwhvwAsNi9cr3kiP8Wov27lzd+sd+q8AFR/fDM3kA
         CqsrTMmUVXPZHRyhDy8qm08t/orTzsWtGa1B6/NozZlpyRakMeYwfBaJDagHYu+5N1
         fzu9ZadFVKKwGt2gbUa1DYDiyuZJPT/drSOXtwlXBeSOYxt8DYZhcuSoHC9EuuGxvo
         3Op2P0HQt2L9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4CAACE21EDF;
        Tue, 20 Sep 2022 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc/siena: fix TX channel offset when using legacy
 interrupts
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166369861730.5026.8541769320178809281.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 18:30:17 +0000
References: <20220915141653.15504-1-ihuguet@redhat.com>
In-Reply-To: <20220915141653.15504-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, tizhao@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Sep 2022 16:16:53 +0200 you wrote:
> As in previous commit for sfc, fix TX channels offset when
> efx_siena_separate_tx_channels is false (the default)
> 
> Fixes: 25bde571b4a8 ("sfc/siena: fix wrong tx channel offset with efx_separate_tx_channels")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] sfc/siena: fix TX channel offset when using legacy interrupts
    https://git.kernel.org/netdev/net/c/974bb793aded

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


