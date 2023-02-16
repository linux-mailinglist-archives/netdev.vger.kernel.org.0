Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB27699039
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjBPJlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjBPJlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:41:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32C3518E6
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 01:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 287AEB826A9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CAE37C4339B;
        Thu, 16 Feb 2023 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676540417;
        bh=Fru8R9LwtPC7ZVQpPPl2ET3Dv7GzCC59kTl/d6Cl7xs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ns32gCzvrLWn3CyRn3D+JxD8pv0x3iAERbSMKR1apzF7qqw+fsA7xlIjNHHzhYru3
         lE7kDDCNddEkAAt+wMSY2xhmRlMqZIfUWbRECWYH1uk5nUrXpnSN9vIW9aZFf6yFTn
         DXjN1JJysHiB1zyiRmy9hlk6EiOyWB8fsmpgQm99fdw+vCraFRCd50Mu18HmsP7kkk
         DDz51qJ75r5KhhfwzP8cj4+f1tNNUBdMeiHsjAmvupTeWk2w7Z6fGuoBM0lBRe7Ip4
         W2sKw2Uh5/61ln6BCJ4Nqk9VnvrlBrdDl5gvCUW8PQ68hIkLVnLyB3a6qmUWvPX+su
         nONjnC8/4HhAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ABBF8E68D2E;
        Thu, 16 Feb 2023 09:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 0/2] net/core: commmon prints for promisc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167654041768.15687.3979753210870532003.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 09:40:17 +0000
References: <20230214210117.23123-1-jesse.brandeburg@intel.com>
In-Reply-To: <20230214210117.23123-1-jesse.brandeburg@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 14 Feb 2023 13:01:15 -0800 you wrote:
> Add a print to the kernel log for allmulticast entry and exit, and
> standardize the print for entry and exit of promiscuous mode.
> 
> These prints are useful to both user and developer and should have the
> triggering driver/bus/device info that netdev_info (optionally) gives.
> 
> Jesse Brandeburg (2):
>   net/core: print message for allmulticast
>   net/core: refactor promiscuous mode message
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/2] net/core: print message for allmulticast
    https://git.kernel.org/netdev/net-next/c/802dcbd6f30f
  - [net-next,v1,2/2] net/core: refactor promiscuous mode message
    https://git.kernel.org/netdev/net-next/c/3ba0bf47edf9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


