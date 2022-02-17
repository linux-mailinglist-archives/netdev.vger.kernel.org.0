Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD224B9817
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 06:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiBQFUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 00:20:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBQFUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 00:20:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8545A2A598F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 21:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8478CE2A7E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDDAAC340EB;
        Thu, 17 Feb 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645075210;
        bh=G1QZvwcruw6oCbc/jrtCbpvbJ+HUW6ilSH9PlZseKv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=goLfzTDrDk+qrZi2Hj2j3mphEtmEP4h9UnbXZQMGpPO9iXYE59ISbStNwoslQrhqU
         0iQ9a4S1RWfN3mUw+WkPCi+cZfYckRMGrqOV5I382QXIg8ag69cP9WkdiaAUAgG2DZ
         faxsMlG+SA4nw72P8LPPFz3yBREcDq1YwVWwFZrFf+tdcVLCb3pcow6Ea4ppLXoDJ4
         uOeF1OprMDvGmc7+qJv7BSO1sQyk2RDEs0LD05KcrCcRRGkrgdkPIg4OaZh9zTOiij
         RCafY7RZjidlCjBcV1NDWlusYweknGqLvKzLheanvoxNxJ7nVhL3krZw9QkcHbfLrT
         YpCoTS3abeG4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C03E0E6D447;
        Thu, 17 Feb 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v2,net] tipc: fix wrong notification node addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164507521078.4843.2149091000529160346.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 05:20:10 +0000
References: <20220216020009.3404578-1-jmaloy@redhat.com>
In-Reply-To: <20220216020009.3404578-1-jmaloy@redhat.com>
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
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

On Tue, 15 Feb 2022 21:00:09 -0500 you wrote:
> From: Jon Maloy <jmaloy@redhat.com>
> 
> The previous bug fix had an unfortunate side effect that broke
> distribution of binding table entries between nodes. The updated
> tipc_sock_addr struct is also used further down in the same
> function, and there the old value is still the correct one.
> 
> [...]

Here is the summary with links:
  - [v2,net] tipc: fix wrong notification node addresses
    https://git.kernel.org/netdev/net/c/c08e58438d4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


