Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D8D5E582C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiIVBkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbiIVBkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045EA33402;
        Wed, 21 Sep 2022 18:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96E02B830D0;
        Thu, 22 Sep 2022 01:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 174E6C433C1;
        Thu, 22 Sep 2022 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663810817;
        bh=Sdzf7aABbJ6+mlL3OdM68AzMzouW97MJVWebppPAGog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jA4evyQj/0UTvijQvwTlnBTcO8UQPrVKa69fCUO9OO+0grVz8iPyhugu09CiiyBW2
         dy9c/zghfySPWRbVVdKb/2g8UFqE3NPQMGed+GA0XoqSk2r9bGYN+CELHTkHHpIif5
         XyWzYYpaCZ/q2s3xTfv/LNnZdo7PoONnw/yO9FXMUVZGLB7i/4vhj7LmI4IdkCzc0+
         jcjwYebyihgTqTdTbn5oRexn8rKh07vNl39tFoJfBVRkpfu1avcLJ6xlVvokGlFVgu
         H0K8M0ezf1dhYnY3mW5sicF+K0Rgy2pyebbR7RjicbOnahyyKphDFT1zooPbt0BeED
         eeiOgmqwevbMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE406E4D03D;
        Thu, 22 Sep 2022 01:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: ll_temac: Cleanup for clearing static
 warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381081697.5452.7754102556865331552.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 01:40:16 +0000
References: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
In-Reply-To: <20220917103843.526877-1-xuhaoyue1@hisilicon.com>
To:     Haoyue Xu <xuhaoyue1@hisilicon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        huangdaode@huawei.com, liyangyang20@huawei.com,
        huangjunxian6@hisilicon.com, linuxarm@huawei.com,
        liangwenpeng@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 17 Sep 2022 18:38:36 +0800 you wrote:
> Most static warnings are detected by Checkpatch.pl, mainly about:
> (1) #1: About the comments.
> (2) #2: About function name in a string.
> (3) #3: About the open parenthesis.
> (4) #4: About the else branch.
> (6) #6: About trailing statements.
> (7) #5,#7: About blank lines and spaces.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: ll_temac: fix the format of block comments
    https://git.kernel.org/netdev/net-next/c/75124116520b
  - [net-next,2/7] net: ll_temac: Cleanup for function name in a string
    https://git.kernel.org/netdev/net-next/c/653de988eb58
  - [net-next,3/7] net: ll_temac: axienet: align with open parenthesis
    https://git.kernel.org/netdev/net-next/c/42f5d4d0e0d9
  - [net-next,4/7] net: ll_temac: delete unnecessary else branch
    https://git.kernel.org/netdev/net-next/c/7dfd0dcc5e72
  - [net-next,5/7] net: ll_temac: fix the missing spaces around '='
    https://git.kernel.org/netdev/net-next/c/a9f1ef7034b8
  - [net-next,6/7] net: ll_temac: move trailing statements to next line
    https://git.kernel.org/netdev/net-next/c/a0a850976801
  - [net-next,7/7] net: ll_temac: axienet: delete unnecessary blank lines and spaces
    https://git.kernel.org/netdev/net-next/c/7fe85bb3af4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


