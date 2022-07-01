Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74095633D9
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiGANAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiGANAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8844133D;
        Fri,  1 Jul 2022 06:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 109DFB8302F;
        Fri,  1 Jul 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAFCFC341C7;
        Fri,  1 Jul 2022 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656680414;
        bh=y/DIWlYTZIQI6jBkHrUN47KtX1knJlN6B9O6tm59ozs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=inTd+O8/sbaoTMyWpmrmqLCYXCioRW//pnWT6Ez5X0je7PjH27HQlvOuu47GtiSfm
         oPxBDC6I+YRbiN206fgPJcB7KKYFyAo6Dm2Imd3IUpZml+Jh1B5fKkTpQ3fC+spnue
         pYBigDMBLTLbDSWOy+1eMxHdGZMNObKSqgKCzTqQEeJS82QSeccp4e4Mm70yTepnsu
         /mwJHLzCEKFwjwAb3S8iGB3wGAYDCNwwnxmsiwcspODYNNXMA7ooDbj9xYWGTdrPsp
         FhM8zJi3mu/tlH/LFJc/5k0vzGyABPIAoqX2ufZmNm/b1WRa50Bc+VzC9X7n83XNGl
         HrDrCwLxgYJlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A323FE49FA0;
        Fri,  1 Jul 2022 13:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/cmsg_sender: Remove a semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165668041466.29442.5312058773095603710.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 13:00:14 +0000
References: <20220701091345.2816-1-kunyu@nfschina.com>
In-Reply-To: <20220701091345.2816-1-kunyu@nfschina.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Jul 2022 17:13:45 +0800 you wrote:
> Remove the repeated ';' from code.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  tools/testing/selftests/net/cmsg_sender.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net/cmsg_sender: Remove a semicolon
    https://git.kernel.org/netdev/net-next/c/dbdd9a28e140

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


