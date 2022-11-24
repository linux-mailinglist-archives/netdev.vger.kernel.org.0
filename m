Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED59563716B
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKXEUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKXEUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:20:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27127C5B5B;
        Wed, 23 Nov 2022 20:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7448B8265D;
        Thu, 24 Nov 2022 04:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83C72C433D7;
        Thu, 24 Nov 2022 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669263615;
        bh=B4aDp96jzcP9MEzqsTRc9rEoMiglQgQP5184eJ3fTp0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L4Zj8fOGstH3T5ZOqGWonXdBvgdUfwnJiG9uVmjf3rLSMDntZLgEbcW76P2Qm3yh1
         vIl1ihczhBtw9hwalwJzkMYOH9yiddcmo3yY1JQiCkPKI2jpI43fWlCbTtNa7sJvEt
         OWiDdvpDtx2NpBEYfhUD259woQZ1vYP34qwnlwaACKjVkTR3aEVptYpkbgtR2zxBXT
         odV7lT+72NgemSK4tpNYC61Gy5ImwIW7ZSiyYeg2nPdA1BT0c27zXWZ+TuEF/KHdsM
         9fuCM7jzkGD6XbKqF6kWeKQG5nfQfMN4q55qT3O+kJQrZBDOcHei3kXHEoJn31yEpM
         Rvpw+xjYm/CXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6AE7CE21EFD;
        Thu, 24 Nov 2022 04:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: add missing unregister_netdev()
 in prestera_port_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166926361542.22792.6218819556598960292.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 04:20:15 +0000
References: <1669115432-36841-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1669115432-36841-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, oleksandr.mazur@plvision.eu,
        yevhen.orlov@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, 22 Nov 2022 19:10:31 +0800 you wrote:
> If prestera_port_sfp_bind() fails, unregister_netdev() should be called
> in error handling path.
> 
> Compile tested only.
> 
> Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: add missing unregister_netdev() in prestera_port_create()
    https://git.kernel.org/netdev/net/c/9a234a2a085a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


