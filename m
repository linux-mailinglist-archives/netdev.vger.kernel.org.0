Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C411B54A28E
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 01:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235357AbiFMXUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 19:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiFMXUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 19:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E75B13F1E
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 16:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D303B81125
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 23:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3DBDC3411F;
        Mon, 13 Jun 2022 23:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655162413;
        bh=00ydswLjboEOtrML9IGapxX9BkjSIJpfJMJoHRTKLjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fKJkYhmmPS4WCXKgn2ryLfP64ZMQZmKdNPYVWf+xm3GS2Lh8+zPUpCzMwELK6qQg4
         Bl2N9d/y5mpJKwvEqiNuflV6FlopWDtTq0NzxoJsw4EWkYUDKwGLRzpLiK/5VPEuWx
         daa5L436JtRkPV2Qdjk/qNTl6Hxl+ssgMX7jAyD18gIj//ewjLBaSrC+mE+e9R4+en
         cmHRjEPtqTabWO7DiSUXob+29YDucXWKGmcO9mEn7ycNCUActo8s+BN5pT7fRa8RDD
         Cgd6DnbjLHp11RDYAh93RYk9n9DBmxpC5rKE/PxBJFbLfdXB5oFMEZ/2ybx1f0EPI8
         T9okAah568DtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA203E575F6;
        Mon, 13 Jun 2022 23:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 ethtool] ethtool: fec: Change the prompt string to adapt to
 current situations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165516241288.27849.11138395439375410363.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 23:20:12 +0000
References: <20220608094312.126306-1-simon.horman@corigine.com>
In-Reply-To: <20220608094312.126306-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, oss-drivers@corigine.com,
        yu.xiao@corigine.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed,  8 Jun 2022 11:43:12 +0200 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Majority upstream drivers uses `Configured FEC encodings` to report
> supported modes. At which point it is better to change the text in
> ethtool user space that changes the meaning of the field, which is
> better to suit for the current situations.
> 
> [...]

Here is the summary with links:
  - [v2,ethtool] ethtool: fec: Change the prompt string to adapt to current situations
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=2b3ddcb35357

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


