Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0689F53B133
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiFBAuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 20:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbiFBAuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 20:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801A1138903;
        Wed,  1 Jun 2022 17:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2689AB81D8F;
        Thu,  2 Jun 2022 00:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A93F2C3411C;
        Thu,  2 Jun 2022 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654131012;
        bh=9vitLOVgalvdHnhyUe9CZ9AIdKgPfsn6rxv89R6q1mI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OGxw5JwlYDQIM8wfG+RZUBOv90iWiW2zP2ObpjkLeBdOCpG4LGIngMdsIUPgbStDf
         poO2NkUKkgg8x12InprBQ+JYPCwA7CT3hwHOpgyUx7dqpDENnpAJS0diN9XFNDEcxO
         sC7YxqFfm4CQxNmhIQiEpB/8/MGoWn1K1CGCvfHb8cVXzduLMrab96874DFeQG+8n3
         lXCKG6azobtWmqwMh24MSdXDM48jjOmVJB2CMmk1ZUSOsP6s1eMA4OPaj+S3KgAtc6
         cDEPU8ZC9f1UKPiJUyOOMAuZENPzgcK6R+cqXE/mTq26Z769OTXpcfBC4UHJkrVbQ/
         i05h7bn35nb9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 86894EAC081;
        Thu,  2 Jun 2022 00:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-06-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165413101254.24390.11206759473228548099.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 00:50:12 +0000
References: <20220601110741.90B28C385A5@smtp.kernel.org>
In-Reply-To: <20220601110741.90B28C385A5@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Jun 2022 11:07:41 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-06-01
    https://git.kernel.org/netdev/net/c/38a4762e4ba6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


