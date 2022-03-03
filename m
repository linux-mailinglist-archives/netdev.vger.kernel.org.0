Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BA44CBFDC
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbiCCOVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiCCOVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:21:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E61D1405CA
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD919B825A3
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51383C340ED;
        Thu,  3 Mar 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646317210;
        bh=1bpsxtl2jNzZUuCSv1hajMisKRasSQj64HTrkcJKzcY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QrgK+qJKV+HjhZqpWH9m4AJJQHxijhTY3ym1Ege4nBzXvxpmQnka2usIQbGrj0x3Y
         97r1PcrxN1zWcZ0BObAy2V1yqIrvRcLtlm3b+/9RBuYFN9gneN2d5WrAoNAxxYfHBy
         iTctUwinLGdTRJkqt6E9QX8ugtnQgFhEOvdGRWVLDukqrEQx5iJ9316YiQ7z8rZQUK
         Y9PYBR0Blr6k1FkL34Y0aaxu5YG04weXhAm8jZ0wshJ7G7sW96SPjQHFZphjMJNgiO
         uhk9rgq2DaIyeQ3O5GguwZpuAiKasfi5aZF6dV2oiKZeRi6qhkSp1slF1nVyuiqAui
         9KIGDud4FqC/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 345EBE7BB08;
        Thu,  3 Mar 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sfc: extend the locking on mcdi->seqno
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164631721021.14029.1782319436538716470.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 14:20:10 +0000
References: <20220301222822.19241-1-dossche.niels@gmail.com>
In-Reply-To: <20220301222822.19241-1-dossche.niels@gmail.com>
To:     Niels Dossche <dossche.niels@gmail.com>
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue,  1 Mar 2022 23:28:22 +0100 you wrote:
> seqno could be read as a stale value outside of the lock. The lock is
> already acquired to protect the modification of seqno against a possible
> race condition. Place the reading of this value also inside this locking
> to protect it against a possible race condition.
> 
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> 
> [...]

Here is the summary with links:
  - sfc: extend the locking on mcdi->seqno
    https://git.kernel.org/netdev/net/c/f1fb205efb0c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


