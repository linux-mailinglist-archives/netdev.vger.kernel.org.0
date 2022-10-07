Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3331B5F74E5
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJGHub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiJGHuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7832F6DAF4;
        Fri,  7 Oct 2022 00:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 157AAB82282;
        Fri,  7 Oct 2022 07:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41906C43145;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129016;
        bh=xu2YnFZWaMD6TEbFxHesRTbEB2hPndjQVpSwkzYbh48=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WOymxihCh30Vl4QnleLUXuzat7lkU+LReCOFEuk0TNEpmUIrLSHuuzmcCLMRARw4e
         kcStMcp3uU7u/gGEbRTEHqQ9YvPdAL/wzVz0PwUs5ONWtix4+F0eVLtNcpikvCME8e
         oTzhcrQZ6wVonsJyLjfS4U6zLZor460BVBcRDgxmgDc+NVs4tzbtwYM2mDU2cZnqhL
         AQBSWDrvzrnBwHAsbwHH9MoRAUvtUgJiCs1KT9WUlnvoM8if+MDc+PAcGObyWvvjSF
         8mk5V0eZAD6jyiceKw5x4GCghzp/sUs/eZuGuwJ0Ht1NoKTTzzSOVzXQfgeAMgoTDQ
         oyk6Y0HF0wXSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D484E49BBD;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] hv_netvsc: Fix race between VF offering and VF
 association message from host
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512901611.847.9066991883848590032.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 07:50:16 +0000
References: <1665035579-13755-2-git-send-email-gauravkohli@linux.microsoft.com>
In-Reply-To: <1665035579-13755-2-git-send-email-gauravkohli@linux.microsoft.com>
To:     Gaurav Kohli <gauravkohli@linux.microsoft.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Oct 2022 22:52:59 -0700 you wrote:
> During vm boot, there might be possibility that vf registration
> call comes before the vf association from host to vm.
> 
> And this might break netvsc vf path, To prevent the same block
> vf registration until vf bind message comes from host.
> 
> Cc: stable@vger.kernel.org
> Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
> 
> [...]

Here is the summary with links:
  - [v2,net] hv_netvsc: Fix race between VF offering and VF association message from host
    https://git.kernel.org/netdev/net/c/365e1ececb29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


