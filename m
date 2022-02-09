Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBADE4AE94E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbiBIF2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:28:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbiBIFUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3488BC03C1A9
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E308DB81EDB
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 918B2C340F3;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384033;
        bh=XB9i4XQ9Rv1FH0zzXog2UAqbPklp04o+ORLouhsBvYI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W+OaCcswm64Voyz4BPw+LuDcGY2YGeB2INE37ZH5HUK8BfTcHqCc2tPT9qbG7Pgwy
         qQJR2iiwXPxh8bkKyJezCmMqokdUstzi4N63SSOSvVDANhJrQMPy7LA8BJggoHfVEV
         qs0RhKIs6zK43WlVEwQh9OzrEkYHY68iLEjXKnfBo0A+u3JNnAvdH6BuzhouKvU1Bq
         wZo4oGD1lhTAMCpOIcs49aqqDf1LDfB24f/55BkMrnrlzES8/TeVbeQiBai0XXhpOi
         ZSb9b3Ixs3kkWmSI4775O9mxxCYIDrHn9ag62wmDjh3CjUn1zDiJCKgw4eNUWp/UF3
         cGfj6sEjdT/Rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8145CE5D09D;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add dev->dev_registered_tracker
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438403352.12376.10665312494473046165.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:33 +0000
References: <20220207184107.1401096-1-eric.dumazet@gmail.com>
In-Reply-To: <20220207184107.1401096-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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

On Mon,  7 Feb 2022 10:41:07 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Convert one dev_hold()/dev_put() pair in register_netdevice()
> and unregister_netdevice_many() to dev_hold_track()
> and dev_put_track().
> 
> This would allow to detect a rogue dev_put() a bit earlier.
> 
> [...]

Here is the summary with links:
  - [net-next] net: add dev->dev_registered_tracker
    https://git.kernel.org/netdev/net-next/c/b2309a71c1f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


