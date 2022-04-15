Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA05031B4
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355296AbiDOVcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356177AbiDOVcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBA0205FF
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3899B83094
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4998CC385A8;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650058213;
        bh=/r+f/8u6fVn9Ql4jpr3urdfZVQ5UuB4Riqx46NYGe4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RYDsdzPCXgW15RqkjbkFBlcRD+70JavvO9klj2mLt2CrfFQRoctNV29JxydBZ3oks
         YPSL6dAKm9l2Q7y1AgA0dBnK7Gp6HFUzr6kxkMgCWqlXXH02RqcNmr6p7Q9M0nSQlt
         oRbhk3NijBZQmszjntt41gwSnwyHWqrAWMCWAr/uJ2eAwYs+0owXDhnTtcjuvFiP7P
         9H690qekta9QOz2OrZUg4Z+LJrCxQT7KHuCm8gFKEisH5Jfujc15849KY9xBgnU2IT
         qZ2AGPLVI2Tyejj9yrkTHCkiuRt2wD3qhZoGs9/xTcw32RRmGs3+yHZWHQ+WI3hXoQ
         YQG0Eq0AlA7Fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D9D0E8DD67;
        Fri, 15 Apr 2022 21:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] ibmvnic: Use a set of LTBs per pool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005821318.11686.18277363963264140032.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:30:13 +0000
References: <20220413171026.1264294-1-drt@linux.ibm.com>
In-Reply-To: <20220413171026.1264294-1-drt@linux.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Apr 2022 13:10:20 -0400 you wrote:
> From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> ibmvnic uses a single large long term buffer (LTB) per rx or tx
> pool (queue). This has two limitations.
> 
> First, if we need to free/allocate an LTB (eg during a reset), under
> low memory conditions, the allocation can fail.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ibmvnic: rename local variable index to bufidx
    https://git.kernel.org/netdev/net-next/c/8880fc669ded
  - [net-next,2/6] ibmvnic: define map_rxpool_buf_to_ltb()
    https://git.kernel.org/netdev/net-next/c/2872a67c6bcf
  - [net-next,3/6] ibmvnic: define map_txpool_buf_to_ltb()
    https://git.kernel.org/netdev/net-next/c/0c91bf9ceba6
  - [net-next,4/6] ibmvnic: convert rxpool ltb to a set of ltbs
    https://git.kernel.org/netdev/net-next/c/d6b458509035
  - [net-next,5/6] ibmvnic: Allow multiple ltbs in rxpool ltb_set
    https://git.kernel.org/netdev/net-next/c/a75de820575d
  - [net-next,6/6] ibmvnic: Allow multiple ltbs in txpool ltb_set
    https://git.kernel.org/netdev/net-next/c/93b1ebb348a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


