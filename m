Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF194EDDE5
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239074AbiCaPwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239035AbiCaPwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:52:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D202E5BE6E;
        Thu, 31 Mar 2022 08:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88B7EB82182;
        Thu, 31 Mar 2022 15:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2387DC34111;
        Thu, 31 Mar 2022 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648741812;
        bh=o7oPdubvZbNMJTrfhkep5P7tDTE5bni0j0+fbJ2Adgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GcvFcHYYkT2wBfM3XNUj00NDUQjBkdTCfhKhlMjjgpP6r2fh6vVPu5RNbhjpGRxnF
         vSD6r218N/X/mDeu/0uJpmjTtLxojJw2KqJUnqZYUDRNR+MgkwqcmaH9xAE5MAaihF
         ZYUf0RZFCk2WmmEZMFXU/QjB+OlXiBGCyUZpiDiWrZ3iUcoNfNYTa27K3pZaKm/Yr5
         QdyaX0jda/JmF8zMda3ULw67g15b0ktc2rdE9ufK8WuYO8Wz7MOwhj0BxWOEICO1rq
         HgRdK92ALCN5/Ez3SIcB98KajfVrfpfgRK0lbjIUyU6ZAFa3JaYKEY2YIQXa+lJNWY
         kQM/0kGSM4x2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09B31EAC09B;
        Thu, 31 Mar 2022 15:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] can: isotp: restore accidentally removed MSG_PEEK
 feature
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164874181203.9626.8941419874377463587.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 15:50:12 +0000
References: <20220331084634.869744-2-mkl@pengutronix.de>
In-Reply-To: <20220331084634.869744-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net, derekrobertwill@gmail.com
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

This patch was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu, 31 Mar 2022 10:46:27 +0200 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> In commit 42bf50a1795a ("can: isotp: support MSG_TRUNC flag when
> reading from socket") a new check for recvmsg flags has been
> introduced that only checked for the flags that are handled in
> isotp_recvmsg() itself.
> 
> [...]

Here is the summary with links:
  - [net,1/8] can: isotp: restore accidentally removed MSG_PEEK feature
    https://git.kernel.org/netdev/net/c/e382fea8ae54

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


