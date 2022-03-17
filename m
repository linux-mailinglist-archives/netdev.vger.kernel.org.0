Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D767B4DD16D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 00:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiCQXvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 19:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbiCQXvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 19:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8118D2B04F1;
        Thu, 17 Mar 2022 16:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C02961337;
        Thu, 17 Mar 2022 23:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3FCDC340FA;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647561013;
        bh=GSOTd2RxSS2kcmyFx4FLiHgoTudEzwGqgoH4ZKQYRv0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SGDYuBs2TF9rGRZ60vJCgfRlPYr2aqy+9e6lWoy5MiU5bDekN1eshO9NX8qtKCdCJ
         Yxd5EveoNUGIcZkVfUy1K+aMu75g2AUlRntP5XQr0PcvJK6iwTZLs4oJa7BspN5krx
         pmKcrWMuH3Fa7ds9pQhaXZkjWCNOhPBf5Hsdk7VUraHroid96td1kzMOmbjNVfnsQr
         lRikQk32sqfI8h5AYLF9kacET9IiWdczwR9UmXSNqSCVmq5wMITpL90EjL18yL9fvf
         oRe30Mht1yHus+x2NEZ4RDFycLkDUzd5WGbnCNaXnWNzyVWIzoDl8KkclEjiPArcg6
         OClPeApAfv1tQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE2F3F03846;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gtp: Remove a bogus tab
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756101290.14093.7117497281533622987.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 23:50:12 +0000
References: <20220317075642.GD25237@kili>
In-Reply-To: <20220317075642.GD25237@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     pablo@netfilter.org, laforge@gnumonks.org, davem@davemloft.net,
        kuba@kernel.org, osmocom-net-gprs@lists.osmocom.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 17 Mar 2022 10:56:42 +0300 you wrote:
> The "kfree_skb(skb_to_send);" is not supposed to be indented that far.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/gtp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] gtp: Remove a bogus tab
    https://git.kernel.org/netdev/net-next/c/02f393381d14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


