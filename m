Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7BC4E3280
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 22:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiCUV6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 17:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiCUV6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 17:58:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D02F5E76E
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 14:55:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A336B81A32
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A63FC340F5;
        Mon, 21 Mar 2022 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899411;
        bh=HLiDyX1DpvVJYny1sd14hXbYbtJ2lIxrQQftjVTtQg4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cN0zrkY8aff7sOD4Ve+nRkCv3wJPJgyZElXbKuUwL9Uqm/4pHST8aUFdpGNaVIOqW
         PobHJoaynirSluiC7gvQdci6MMbDZl4VtxCpG0hains7e+8yzQ3IKoK54mahfZ5mOD
         hQAYiWpY3w00NMkIi8vG0liIeE1r5ROZ9dBIK/BZul5CGNBws6+OaEMNg8EGbUPIFV
         UtjUmy6Vk/yluPkJXSEoTSWTQSzlVemlyNwxI2CRZFIQEEvNayYMyKF0W/X3OLVw6A
         xFJuMG5OoP8AlEWz89E9ySqL9gvrswlWjORO7TkioFl/4yRiBItUqF8/xRY5KXG7eE
         Jj3Flgu1c4Jjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3535DEAC096;
        Mon, 21 Mar 2022 21:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: ensure PMTU updates are processed during fastopen
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164789941121.5210.14121283533931105356.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 21:50:11 +0000
References: <20220321165957.1769954-1-kuba@kernel.org>
In-Reply-To: <20220321165957.1769954-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, ycheng@google.com,
        weiwan@google.com, netdev@vger.kernel.org, ntspring@fb.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Mar 2022 09:59:57 -0700 you wrote:
> tp->rx_opt.mss_clamp is not populated, yet, during TFO send so we
> rise it to the local MSS. tp->mss_cache is not updated, however:
> 
> tcp_v6_connect():
>   tp->rx_opt.mss_clamp = IPV6_MIN_MTU - headers;
>   tcp_connect():
>      tcp_connect_init():
>        tp->mss_cache = min(mtu, tp->rx_opt.mss_clamp)
>      tcp_send_syn_data():
>        tp->rx_opt.mss_clamp = tp->advmss
> 
> [...]

Here is the summary with links:
  - [net] tcp: ensure PMTU updates are processed during fastopen
    https://git.kernel.org/netdev/net/c/ed0c99dc0f49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


