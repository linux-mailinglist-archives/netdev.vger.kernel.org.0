Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF4A4DE660
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 07:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbiCSGLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 02:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiCSGLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 02:11:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EC42A1EA6;
        Fri, 18 Mar 2022 23:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E7B460C92;
        Sat, 19 Mar 2022 06:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BD66C340EF;
        Sat, 19 Mar 2022 06:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647670211;
        bh=XHwwGhTHxFb2bwVg/Ibu0VYQoWzKGKJiwS+67lDPUAE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H9YcDx69WX8WYy8jnGNOGroE5zf8jpZ/D8DTSm3wWaYyZ0Sb0ErlZzBeGpsN928o1
         QwtUUZQr8jEUKGAe6fh0B6aVTNtc1385NxluTZDDJQqVPZcMf/uyYrtsavoiM/O1/H
         xuXxcxE7HEVUe5a0JgWS5WOiSMTJSoLCiHM9/AnWc49T5I0OgZ3cCv7/ggzf7HOSdk
         guoQ0+qwh6SBbiC/gZ/bVXIh3bJcb3duQr0jTnc/B3vyRnEAc+TIe8SGg0Dgn4PWEI
         2r83s3mTdK6bBBGhNTosGmL+nRZNr2sAhsWPzK8UI+nZ8KF/wARQlgvencLckbE60s
         RkSJf5m36P+cw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41460E6D402;
        Sat, 19 Mar 2022 06:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth-next 2022-03-18
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <164767021126.27135.8650935055751237438.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 06:10:11 +0000
References: <20220318224752.1477292-1-luiz.dentz@gmail.com>
In-Reply-To: <20220318224752.1477292-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

This pull request was applied to bluetooth/bluetooth-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Mar 2022 15:47:52 -0700 you wrote:
> The following changes since commit e89600ebeeb14d18c0b062837a84196f72542830:
> 
>   af_vsock: SOCK_SEQPACKET broken buffer test (2022-03-18 15:13:19 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-03-18
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth-next 2022-03-18
    https://git.kernel.org/bluetooth/bluetooth-next/c/53fb430e2070

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


