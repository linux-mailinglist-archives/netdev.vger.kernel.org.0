Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4EC567986
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiGEVuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiGEVuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010A55F53;
        Tue,  5 Jul 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2928761D00;
        Tue,  5 Jul 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78772C341CD;
        Tue,  5 Jul 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657057813;
        bh=7hjEB6Ab1GRyapi02anLetgFeCWsZ4Zo/UQFBZZVo6A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jdjKPLBDoyYUzNAR1CL/oZU25yePf9JJfTF0TjNrpxOsgQfShMwpoactiGu8PNEA8
         d5WgxHPzw7HiEvx2JVKgfAumfOGNY80Ob75Jr+P7WI+3NN9BlGtemKwtRo+AcuzG7z
         GejJtbdIZxlqiMmyXTN4ouayO1TmszHZaTbGSs06iACpRCA1BizdM5QdiMC1QgxAIR
         B3s8WAGc21qAQ3ZKqhXRgb9gD/bRqF9CP177+iIvgYSPibda0kfBHfoIepdVt5pBcg
         0hY/BjX9489eFeKUH1FjNoeCCv/gr3bCgBfvPrmbz26NQsdOfjFrnawJ33wCaonY29
         L64PGawP0im/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AB1BE45BDF;
        Tue,  5 Jul 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-07-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165705781329.1977.16373504363810617995.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 21:50:13 +0000
References: <20220705202700.1689796-1-luiz.dentz@gmail.com>
In-Reply-To: <20220705202700.1689796-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  5 Jul 2022 13:27:00 -0700 you wrote:
> The following changes since commit 029cc0963412c4f989d2731759ce4578f7e1a667:
> 
>   Merge branch 'fix-bridge_vlan_aware-sh-and-bridge_vlan_unaware-sh-with-iff_unicast_flt' (2022-07-05 11:52:35 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-07-05
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-07-05
    https://git.kernel.org/netdev/net/c/26c12725b462

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


