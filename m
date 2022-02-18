Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B24BB8A6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiBRLub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:50:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiBRLu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:50:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F221AF6DE
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51A7D61ED3
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3D70C340ED;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645185011;
        bh=M92w/Vvn2KP961+PnGi4s2JIBOakuipmVw6Dd0s/pUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uZTUQkBMLZLaLc15PQ2gFSmc7JUWunC3BBDhIUgIHlDlDuUyxrP4q7t7ieU1BDs3t
         WQ2EqYkz3Ul9VznOd2X18eyz0ecGab+TcmAUMIf+VGf0gKkzJO0v2xIXuef2VpjXtd
         kecBSV1X6ifvlQcsaF+DGCamr6iEgcBTgzYkKwUBCHGV6tfLbjcy45qg4TWtp2V/Zj
         Jl4+oqQzfDzz0lPtWzkWRTxl808qRWVdU9RWSncnVcg0rp+0za7k5niejgyGzRy6yY
         UuCZHsgeUHOmhGEiJ/SRpSweEKR3HMiwvwWa53+yspIdh6wp7+qKXphuU9+nrN6DlR
         DFsw104va7UGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F68AE5D07D;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ibmvnic: Cleanup workaround doing an EOI after partition
 migration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518501164.13243.6810888493004564611.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:50:11 +0000
References: <20220218080708.636587-1-clg@kaod.org>
In-Reply-To: <20220218080708.636587-1-clg@kaod.org>
To:     =?utf-8?q?C=C3=A9dric_Le_Goater_=3Cclg=40kaod=2Eorg=3E?=@ci.codeaurora.org
Cc:     drt@linux.ibm.com, sukadev@linux.ibm.com, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Feb 2022 09:07:08 +0100 you wrote:
> There were a fair amount of changes to workaround a firmware bug leaving
> a pending interrupt after migration of the ibmvnic device :
> 
> commit 2df5c60e198c ("net/ibmvnic: Ignore H_FUNCTION return from H_EOI
>        		    to tolerate XIVE mode")
> commit 284f87d2f387 ("Revert "net/ibmvnic: Fix EOI when running in
>        		    XIVE mode"")
> commit 11d49ce9f794 ("net/ibmvnic: Fix EOI when running in XIVE mode.")
> commit f23e0643cd0b ("ibmvnic: Clear pending interrupt after device reset")
> 
> [...]

Here is the summary with links:
  - net/ibmvnic: Cleanup workaround doing an EOI after partition migration
    https://git.kernel.org/netdev/net-next/c/7ea0c16a74a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


