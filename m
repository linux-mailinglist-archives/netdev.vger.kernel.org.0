Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F3E62F424
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiKRMAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbiKRMA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:00:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E6794A5B;
        Fri, 18 Nov 2022 04:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36136B82326;
        Fri, 18 Nov 2022 12:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D408EC433D7;
        Fri, 18 Nov 2022 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668772825;
        bh=VSfoukfeWzEaAclEWk3wjoVGfU5aw8Tr/LQUdaROGOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GFbLSIG83cNhdHJNgUKpEAD9gSjZn/n9fGuE8l+/kN3cdW/QCkzopGyrH3Nz7Lr50
         LryLfekTdwvchvTEgaTfj6IBk15kriKQvq0vAQeVcbxZuWYKhs9oGW0jD5JeYGWJ8A
         pXqdWmpyaPUe/eO7e2IKvvT2wAsQa8qOOQryD0xPEq+9I/BHEmcwSOjSa2+Lq0eCGl
         DnuJ8L3VNNhL58aiD1tMOoVd9IhdaRmat/YZsHYB/bqg84NSqlxYIOdYPS8ERPK7dk
         L6/IoOGsbvgZ6bn/btFTYqhLT1agzWV/flwL8Y8rGNapGpXO/LKfog0o7FD1B4cJIF
         Tffx6G+Vr4Flg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC0A9E50D71;
        Fri, 18 Nov 2022 12:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: avoid a null pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877282570.14131.14093782729381689956.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:00:25 +0000
References: <20221116223718.137175-1-elder@linaro.org>
In-Reply-To: <20221116223718.137175-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, error27@gmail.com, caleb.connolly@linaro.com,
        elder@kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Nov 2022 16:37:18 -0600 you wrote:
> Dan Carpenter reported that Smatch found an instance where a pointer
> which had previously been assumed could be null (as indicated by a
> null check) was later dereferenced without a similar check.
> 
> In practice this doesn't lead to a problem because currently the
> pointers used are all non-null.  Nevertheless this patch addresses
> the reported problem.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: avoid a null pointer dereference
    https://git.kernel.org/netdev/net-next/c/15b4f993d12b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


