Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50DDD4C1FA4
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244709AbiBWXam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238389AbiBWXal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:30:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B352DA91
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 15:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A13DB82237
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 23:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25843C340EB;
        Wed, 23 Feb 2022 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659010;
        bh=L38C5h0aoSMDXnpRLTH+RHR5Nbn4TIPJUjZL7eAxNuI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A4x9JSgS0NxCtYUOXDfL1b6cO6+nCUU3ZKpa4PL6mvbehmltI/Sd+qQaGJXY2TPX4
         +Kl+MRLqdtW+ptktAa059w5K8CnCqLsBtxWgmk1FjJS1EKSgyT41nzgu/IXTuz5MU8
         GYMyMXoK1jqa4TrjUI4sXhKJ2s3knQRePZyuUBpmaR44+lK03Fq7kTYCifawKLdgMy
         8a+DaSaWd60QnqSHJ7NN246IJn/stKMpsyhDvUq3Dmg+SB8DZi2M/vlkr36WaMq4I2
         GJTCP7lOAEdSpCl2TPPyORgGVxiT2kSwYmEQl3/mFjHEqFmLtV9bAeIKzJNCf0iiBE
         0Q7F5QYpcVNeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04913E6D598;
        Wed, 23 Feb 2022 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "vlan: move dev_put into vlan_dev_uninit"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164565901001.5139.15998692467633966154.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 23:30:10 +0000
References: <563c0a6e48510ccbff9ef4715de37209695e9fc4.1645592097.git.lucien.xin@gmail.com>
In-Reply-To: <563c0a6e48510ccbff9ef4715de37209695e9fc4.1645592097.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, william.xuanziyang@huawei.com
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

On Tue, 22 Feb 2022 23:54:57 -0500 you wrote:
> This reverts commit d6ff94afd90b0ce8d1715f8ef77d4347d7a7f2c0.
> 
> Since commit faab39f63c1f ("net: allow out-of-order netdev unregistration")
> fixed the issue in a better way, this patch is to revert the previous fix,
> as it might bring back the old problem fixed by commit 563bcbae3ba2 ("net:
> vlan: fix a UAF in vlan_dev_real_dev()").
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "vlan: move dev_put into vlan_dev_uninit"
    https://git.kernel.org/netdev/net-next/c/6a47cdc38143

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


