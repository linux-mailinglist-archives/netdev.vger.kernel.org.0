Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85D350E932
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbiDYTNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244861AbiDYTNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:13:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A532655F;
        Mon, 25 Apr 2022 12:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 986F0B81A03;
        Mon, 25 Apr 2022 19:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37B36C385A9;
        Mon, 25 Apr 2022 19:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650913811;
        bh=fNpeq6T3pkA5NkTQjgnnd8/ubclmUGEEr/oMQiksv0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uEjPQGJvA9oBbjAjslDqjTWF1ZO/7aE1muVcllH3K+0A62AqpifTFqKvVN3C0RZTK
         Rq0BJzHzrNmmmOkV6ZdRAdrGImHgnwe5OfgLZD7MOWRTgDxrT10SvIe1ikNvFGPmqk
         oJtF65mI7RDHzPbiGKZieOKVlF8UVna+aa1g0Yie94SbbAKXvtrg72TnMK3Do8JzZg
         uKArRWgX94sz0/fU6qRuIJDENMkSq1ZEzCni8/SLxyGIwbxq3040F2it6qc75zlv2p
         LzWnnSQ+XXpHxWI+9D9KA7+RUYDoyyUuxinzbFpHrL8odNFPGbUAan4jk/LR3STGZv
         MIipebvfXjuIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1943EEAC09C;
        Mon, 25 Apr 2022 19:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: Two fixes for smc fallback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165091381110.9058.15067070581057696641.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 19:10:11 +0000
References: <1650614179-11529-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1650614179-11529-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Apr 2022 15:56:17 +0800 you wrote:
> This patch set includes two fixes for smc fallback:
> 
> Patch 1/2 introduces some simple helpers to wrap the replacement
> and restore of clcsock's callback functions. Make sure that only
> the original callbacks will be saved and not overwritten.
> 
> Patch 2/2 fixes a syzbot reporting slab-out-of-bound issue where
> smc_fback_error_report() accesses the already freed smc sock (see
> https://lore.kernel.org/r/00000000000013ca8105d7ae3ada@google.com/).
> The patch fixes it by resetting sk_user_data and restoring clcsock
> callback functions timely in fallback situation.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: Only save the original clcsock callback functions
    https://git.kernel.org/netdev/net/c/97b9af7a7093
  - [net,2/2] net/smc: Fix slab-out-of-bounds issue in fallback
    https://git.kernel.org/netdev/net/c/0558226cebee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


