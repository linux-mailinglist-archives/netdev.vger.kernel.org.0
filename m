Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D695867F1
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiHALKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiHALKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E6C31A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1311B81015
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B97AAC433C1;
        Mon,  1 Aug 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659352213;
        bh=hGUTYpGcTT0WjErdCOvufrcSnTIHyBFOB23jpf+Iv0M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d2JjyGxYIUksckdh6np8LKND2+RJqUbs45gnQH1tf1HoXICUZqhNShy2VKh4kLN0F
         mVfuDG2cgJTlDChUBlX1ShDtFhPvPO2fd3OhpqkYkDs9Vh+D2STaMVv/32F+GkfuKN
         OZqmDu++2y1zDfou8Q4eh6rvlUTWzzwZNfNInfnQ/aYPdP1N6aspGOeBhh0I94g3ep
         2GFGvzsPySnF7PnCt+9W7wqF22oKnuC84zSXOtNWoy2Uzo4DKEpi+BrDJtL7WwfLtl
         XWzZoyeA6Fmq2gWkr+wnVAzt7vf3v0srJiYY16/d7IMTD9U3aXprKz2NnF1JruobtT
         OzKCNj0ZCua0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A30BDC43140;
        Mon,  1 Aug 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates
 2022-07-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165935221366.4772.1456864817267069800.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 11:10:13 +0000
References: <20220729174316.398063-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220729174316.398063-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 29 Jul 2022 10:43:14 -0700 you wrote:
> This series contains updates to iavf driver only.
> 
> Przemyslaw prevents setting of TC max rate below minimum supported values
> and reports updated queue values when setting up TCs.
> ---
> v2: Dropped patch 3 (hw-tc-offload check)
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] iavf: Fix max_rate limiting
    https://git.kernel.org/netdev/net/c/ec60d54cb9a3
  - [net,v2,2/2] iavf: Fix 'tc qdisc show' listing too many queues
    https://git.kernel.org/netdev/net/c/93cb804edab1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


