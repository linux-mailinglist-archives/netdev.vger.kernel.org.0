Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9184B4EB7
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351852AbiBNLed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:34:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351747AbiBNLd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:33:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A403D69499;
        Mon, 14 Feb 2022 03:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C76D61129;
        Mon, 14 Feb 2022 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8297C340F1;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644837610;
        bh=WZu68uNR1ddgEpbLlwMlsKNMyejt3ShDF1xXG3VstDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AUtfO9TnfWXUu+OXNgDgbpBwlhn7lC6P7SUca+oEWT+UDvbWlCICexcDNScc+n6zz
         N1tM2lIE51e8bmMkzs9xnCAofM50xHpV6/0KLhWwepwExAolqYkszVH8k4hbGwix53
         QXi/ekYpFSBGLSD2hSaOvBC+oXNKfgDaeTjLXjZipwqU4jvi0fIYkvqfvli8LC0q4l
         4YDj2/pz3IA2usd6l1r8C7pAecqdTNbdB+Wzy4TXoo/w+6Y1qxYTDpqebc//TET1G+
         VAtKsGBPP2UhzC2PlE8+WgDKPdJdcy+9jpnBro+RZhYkEW19wk0b177N0nqOpiX7A3
         MOsOAOwYLs/6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9008BE74CC2;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Add comment for smc_tx_pending
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164483761058.10850.4349431978989195567.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 11:20:10 +0000
References: <20220211065220.88196-1-tonylu@linux.alibaba.com>
In-Reply-To: <20220211065220.88196-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     raspl@linux.ibm.com, kgraul@linux.ibm.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Feb 2022 14:52:21 +0800 you wrote:
> The previous patch introduces a lock-free version of smc_tx_work() to
> solve unnecessary lock contention, which is expected to be held lock.
> So this adds comment to remind people to keep an eye out for locks.
> 
> Suggested-by: Stefan Raspl <raspl@linux.ibm.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: Add comment for smc_tx_pending
    https://git.kernel.org/netdev/net-next/c/2e13bde13153

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


