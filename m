Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C32E4DB7EE
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354950AbiCPSb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354613AbiCPSb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:31:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53056D95D;
        Wed, 16 Mar 2022 11:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E407B81A71;
        Wed, 16 Mar 2022 18:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 022D0C340F2;
        Wed, 16 Mar 2022 18:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647455411;
        bh=LO/RUu00sqiUYvB9f0a9zQ1Khjj7+kdyjKMfrelj+MI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kCw1NNsxhVnPoy2xHJH6HUCGpcQWYlxo0ojzc5zU5EJ5ef97syNoGbnSkC5/Luxml
         3an0gax9UViaRDB7vAqPM/98ROwoO2XOz6Q/caR//ki0KaCzsUeiD6ZtiuSReixYCl
         NuphHrDmJzJXNdO2OrKny3h3uwbJv48lIxbabgfRwyhFntRwFFTGu0AQb6dKKsyloC
         ARvNQ6w7zoBhZp3u/MjHhOSyzhe3gUwKIZqpB5UVuv7Fkkho3RNSiCcML7V2Ucq+iJ
         TPggqF7v5JYxn4OJXGrPZyM/YzJTjD26VFEVKIOzRQhkuKDMncnv5dPeJjaKB6QelA
         VOJu99aav0Jzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CEB61F0383F;
        Wed, 16 Mar 2022 18:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-03-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164745541084.25916.10068737564049624683.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Mar 2022 18:30:10 +0000
References: <20220316130249.B5225C340EC@smtp.kernel.org>
In-Reply-To: <20220316130249.B5225C340EC@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Mar 2022 13:02:49 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-03-16
    https://git.kernel.org/netdev/net/c/1bbdcbaeda44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


