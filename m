Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACBD4AE949
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236066AbiBIF1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiBIFUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8483C03C1A1
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7146B81ED8
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CE77C36AE2;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384033;
        bh=amSZ4qB+hv3cVnwjAp1zxPOMoRzOiGJbCYG7Drlh630=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r0IleIwhas+vNJ0ndi0X64nbI6RDBw1Ez9cqOC4zTSvlUNoPtWZSMSprUoYPbDaKy
         9QLWcoAyqOGzXJI0z0SraaCFHrD43vI877DfHn/B7kQn6UnTGt/MHRlILBLPpl/yby
         QKkqYxbEfMLrwJc3P2wwqgxEEelyLIQtBDFgKOAUlccwY7JV4CGszjPwe1ybbsj3SZ
         fum+gOjSeMKExVFAKS7wcwaxFhhjENBP8+2lqJKWw4Q/3YQvz5N3OGYA93B0QK+xmF
         pcsOefVMoaxxCSDPO5qFx+sJyT5DCz9wcK1xf1QQR7j3m8mWl3AWnBT3+Ko/gRO/7M
         4PG9TpYTS4h9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C173E6D446;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438403343.12376.12247228296267172054.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:33 +0000
References: <20220208053210.14831-1-luizluca@gmail.com>
In-Reply-To: <20220208053210.14831-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, trivial@kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Feb 2022 02:32:10 -0300 you wrote:
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  include/net/dsa.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dsa: typo in comment
    https://git.kernel.org/netdev/net-next/c/c7d9a6751a5f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


