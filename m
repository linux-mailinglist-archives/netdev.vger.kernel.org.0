Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB754B281B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 15:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346676AbiBKOkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 09:40:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiBKOkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 09:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63020197;
        Fri, 11 Feb 2022 06:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11631B82A77;
        Fri, 11 Feb 2022 14:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88C81C340EF;
        Fri, 11 Feb 2022 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644590410;
        bh=Qbkfp88xlU29ukfRtrt3inkgqWqrG5PJBsS7q6mE7Vs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZGoOm8TGcQDZeFRm5CubmJNItqXloox55eR4a+LUUGYqVufocmjstb+AnBWvLU2ME
         q960NYTEqMmcDF5bNefVkFCeFp7+WrVyugMZtLuNCfXuZ2kmKibUKc5o4VruDlzuQr
         nZ4HZ2LLFa/174bmyMtvb7MWGLQmIgn6f3ZNp5PuMeJXejKXGXKEuXSWJ/snBeDMU9
         LrhqqGDSMKDiKcVE9VO4IrALOW5yWWZQP8AzoR/Pwt2qbjbJXTQD5uJA6OLOjBhRE3
         3c0W6LTzkCqq5qAsqjb2TDKCiVIFFQbYp5weyMQz6/lmL6whLjwewUbEuAolKJ3/W8
         DgBbaVKoZCMtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6E1EEE5CF96;
        Fri, 11 Feb 2022 14:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-02-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164459041044.31178.10103961709998264852.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 14:40:10 +0000
References: <20220211093342.79D5EC340ED@smtp.kernel.org>
In-Reply-To: <20220211093342.79D5EC340ED@smtp.kernel.org>
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

On Fri, 11 Feb 2022 09:33:42 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-02-11
    https://git.kernel.org/netdev/net/c/85d24ad38bc4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


