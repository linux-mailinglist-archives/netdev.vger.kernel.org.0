Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDFC5BEA8C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiITPui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiITPuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146AC5142E
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB4F7B82AEE
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 15:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F255C4347C;
        Tue, 20 Sep 2022 15:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663689016;
        bh=NtppUyx74jjZFVs3sPz1pV7FltkCYdQULomg61H/OoQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gkVe2uOygte0RxtNvCXBlvwNmYSbKInE6AvcXXdbuQFYmKxKKtDLJt+XUqAHHYFt+
         ynz3RykSlrIo4jRTuPoWihAdqyR4F0xlHn2jXgFucFAMARUzNLJGPmSqXzftN5xCD0
         LSXxYYWOeszcJyl7BF+zVVFFGeOXnYV3XzyNvV9uJT6SBAIDUmylCYcWGhDrPLomlR
         +HnY+1DPAEnC4LD0866ep5dTFHSMMmhrFC86DFBdjRADE/7bg+/27s2OAkzqGKPWOz
         aap9I8HF8N0oQy93B1pAXcDZWmaou2JER8dbjkC4/Camn8p1vd5/TB9JI8e562w4gd
         L7u2SN2P7poAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 442E9E21EE1;
        Tue, 20 Sep 2022 15:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND net-next PATCH] net: rtnetlink: Enslave device before
 bringing it up
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368901627.16825.8941636217857352725.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:50:16 +0000
References: <20220914150623.24152-1-phil@nwl.cc>
In-Reply-To: <20220914150623.24152-1-phil@nwl.cc>
To:     Phil Sutter <phil@nwl.cc>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dsahern@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Sep 2022 17:06:23 +0200 you wrote:
> Unlike with bridges, one can't add an interface to a bond and set it up
> at the same time:
> 
> | # ip link set dummy0 down
> | # ip link set dummy0 master bond0 up
> | Error: Device can not be enslaved while up.
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net: rtnetlink: Enslave device before bringing it up
    https://git.kernel.org/netdev/net-next/c/a4abfa627c38

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


