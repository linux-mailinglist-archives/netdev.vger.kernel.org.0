Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A998960EE9D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiJ0DbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiJ0Dao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:30:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A9C303E5;
        Wed, 26 Oct 2022 20:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 636E3B824D4;
        Thu, 27 Oct 2022 03:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0361C433C1;
        Thu, 27 Oct 2022 03:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841424;
        bh=aUIq4BFAd5BdpLVTU/FqPVk2T85pZjeovcY4bheWNGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L/nxlqqjsMVSx3Vb6OD8GhJJ6HedEXWmR2VV79PBAnNBN68IlGOPHiCsuOoQm5SY9
         Lf8LdXUODHugYAGoGY0uY0H3J9khUbAAVpPlFbFHVa15dXZkar8OIK89z6+JVNIKrK
         iO42Cu26knuI0KylfNQlXvTm6Xhzbvrwfd2SiDwlgAgvBk4h5Zfh8wbJUjmd8rgldq
         WZJwuTjWG9W7e1oX955PuxsOX19lD21y4O9aMchYH3Wuc2hawaZNkUX0m2Y6XdHn4D
         AtGUSV7S7K2TMLQUceozwqNF13hpDxPnwgBUIFXLt+P+1ZNyBh2N1A3qApgGi+R2c3
         fRPsOAfv4SmQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF7FFE4D003;
        Thu, 27 Oct 2022 03:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing
 put_clock() in error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684142383.32384.10539750340050944615.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:30:23 +0000
References: <20221026075520.1502520-2-mkl@pengutronix.de>
In-Reply-To: <20221026075520.1502520-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, dzm91@hust.edu.cn
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 26 Oct 2022 09:55:19 +0200 you wrote:
> From: Dongliang Mu <dzm91@hust.edu.cn>
> 
> The commit 1149108e2fbf ("can: mscan: improve clock API use") only
> adds put_clock() in mpc5xxx_can_remove() function, forgetting to add
> put_clock() in the error handling code.
> 
> Fix this bug by adding put_clock() in the error handling code.
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in error path
    https://git.kernel.org/netdev/net/c/3e5b3418827c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


