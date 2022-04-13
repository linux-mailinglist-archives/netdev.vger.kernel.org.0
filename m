Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22224FF7A2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiDMNco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbiDMNch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EBC1BEBF;
        Wed, 13 Apr 2022 06:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 326A4B824AB;
        Wed, 13 Apr 2022 13:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7907C385A6;
        Wed, 13 Apr 2022 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649856613;
        bh=Kpz+ZhBQ/A797FgHxn2N+N4z7P61sZzrGBo5U75eR3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mpd2Jc5qBHMkEBxf2stG2oyA1sALH2K0c4bVA2zjSPv9Oxqm27KvB/Wvv5x+jg9ZA
         /e2rWsUJqBq2crouAGsMRQv3pEj9LV+e5De5O0YNMTcMGDEGlLr3rrIa82zI6t8I6A
         FOSKZoJkVEWzzmXj6cA3Y8YDXmE5VNzDGzZL42JVEfbwATwYLQ36Sf2Zq6Li4NENRP
         LZgfGWYMctfqavD+AzQgS/k3hGpoAYJAGpcVggvhczy5StLhMHf9djbBR7hOwz9gdu
         NxEsu8fDaAm5RORyDORKdNcvWIYuO7gcZTWx1jDv6UFe6GpO7WRaPT3vVi5fA1ALj3
         7yiCfWdX2obxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8D47E8DD5E;
        Wed, 13 Apr 2022 13:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985661381.7515.9077533227511646876.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 13:30:13 +0000
References: <20220413063849.C1EE4C385A3@smtp.kernel.org>
In-Reply-To: <20220413063849.C1EE4C385A3@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 06:38:49 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-04-13
    https://git.kernel.org/netdev/net/c/dad32cfeed7c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


