Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974D45753E9
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbiGNRUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbiGNRUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094984E629;
        Thu, 14 Jul 2022 10:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD550B8279C;
        Thu, 14 Jul 2022 17:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2771AC341CA;
        Thu, 14 Jul 2022 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657819214;
        bh=FaHAeYiuAa69ylxwqikdJzOExKyhgIBJ5ttnjxlYBBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fkgys9TDA3sQjGkuMPawEyNxq8aCeUJv9pzWe+dmHSrfEIoWj0NUDETupmMw3DP9X
         RpVN3cwEra5+Vbp3u0W5g7cTB59SuYvn1uTnD4fZMiDtDYepvAET6FdHBNGtRDAfur
         Njtdz/5S9pzcIbvYRPsPPRoMe6gNLtBWXaAST+M3Or5ZOLkjJLq7Bt3b0I7IOX9usw
         GOAZofFFFs5sX83CsvwQnDNuUuVL2W7EU49UdOvOJiVyHXLV1AR7KitB3/fHnFM3Ko
         khUax7Q8/FBSoOrynDZPs9JSz2BzGS+bsTpx5g3ZnwqZjCGW6cFqtvOgWRVSXPMJWE
         suLJEdOMW8rbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0ED45E4522E;
        Thu, 14 Jul 2022 17:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] MAINTAINERS: Add an additional maintainer to the
 AMD XGBE driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165781921405.9202.7756602413556094051.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 17:20:14 +0000
References: <db367f24089c2bbbcd1cec8e21af49922017a110.1657751501.git.thomas.lendacky@amd.com>
In-Reply-To: <db367f24089c2bbbcd1cec8e21af49922017a110.1657751501.git.thomas.lendacky@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Shyam-sundar.S-k@amd.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 13 Jul 2022 17:31:41 -0500 you wrote:
> Add Shyam Sundar S K as an additional maintainer to support the AMD XGBE
> network device driver.
> 
> Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> 
> [...]

Here is the summary with links:
  - [net-next,v2] MAINTAINERS: Add an additional maintainer to the AMD XGBE driver
    https://git.kernel.org/netdev/net/c/51f1c31f8ba7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


