Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C16EA52AF4E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbiERAkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiERAkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4E53D1CA;
        Tue, 17 May 2022 17:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C5C0B81D99;
        Wed, 18 May 2022 00:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F31A1C34116;
        Wed, 18 May 2022 00:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652834412;
        bh=cXcmOxyB5b3qaFF0Us2S/2kRrZZ+zgv6w74wxsm8ZUk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O1/MxTzLciw7w1CMQH9q8dTY82xaMyBN5BClFv844HRUjNdtvi47k8hFUYDswIIIG
         prNN7DPQdJGU7V0Qbzdnmi/gIWTeXDxcdSeAzeplJNp+D0/azig7T7JoGb54H3PdkR
         hPKXxYtacQ3VLH8hLYYdg5EHmy996fKwL+QByKTm82Wm5ywgRw10Mvf7+AaMhY6Eun
         +GMPGeQeE/aBA/HHsUxZgYwvW0T95mM+AitKs5bAzjl1PVZo7/57Jv7g3bslP9sqdX
         udqk0PmgdlfnmVjvtHv0Cla/sceUnBTSl9cibGtWj11IPBSkIZpIiJHYSNu5D54kZ4
         Fk2KK4aR9zLEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D468CF0383D;
        Wed, 18 May 2022 00:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/qla3xxx: Fix a test in ql_reset_work()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165283441186.18628.4616423734096658366.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 00:40:11 +0000
References: <80e73e33f390001d9c0140ffa9baddf6466a41a2.1652637337.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <80e73e33f390001d9c0140ffa9baddf6466a41a2.1652637337.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        akpm@osdl.org, ron.mercer@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 15 May 2022 20:07:02 +0200 you wrote:
> test_bit() tests if one bit is set or not.
> Here the logic seems to check of bit QL_RESET_PER_SCSI (i.e. 4) OR bit
> QL_RESET_START (i.e. 3) is set.
> 
> In fact, it checks if bit 7 (4 | 3 = 7) is set, that is to say
> QL_ADAPTER_UP.
> 
> [...]

Here is the summary with links:
  - net/qla3xxx: Fix a test in ql_reset_work()
    https://git.kernel.org/netdev/net/c/5361448e45fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


