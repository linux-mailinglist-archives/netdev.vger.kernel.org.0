Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11264E2970
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 15:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348961AbiCUOEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 10:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349057AbiCUODR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 10:03:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA50A173F52;
        Mon, 21 Mar 2022 07:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5007B816EC;
        Mon, 21 Mar 2022 14:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C519C340FB;
        Mon, 21 Mar 2022 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647871212;
        bh=Km7t6CTT6AMW6qnaUz419R2eshIuoIboNM6RXaAqJo8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IR6khApKs5j2Bu4EVGDGUlntqswbgHCtlsoOXvx/XnOei7Xp72jqLkIZ8QeaaedW1
         O7IswM/3R2J3CfVEuxRaJjhjXwSwoknAj1dQDNB0G8MRbROoXhIty6oU+X74T+T3Mb
         eGDDvcW+W775kw+wwlJElWeDPWS3AxbulPLZIU+OpbhCDCVAnuwwN3z8z2kS3KUDhB
         pzSIhkosU6CAzkYNC0wvsRzZixS39P9nrMn4VZ/Euv/f5pMUbsCNeBDxZ5P7e90yvW
         LHAnT2osfgoICz70dZVZqRtuDYO7ubmuOOWlCa5GHcj9/fCGIsLEeKR7r/YIj8ELkP
         IsJ4PMdYqNxQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6358DEAC096;
        Mon, 21 Mar 2022 14:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] fix typos: "to short" -> "too short"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164787121240.8124.7446894244929716663.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Mar 2022 14:00:12 +0000
References: <20220321071350.3476185-1-ztong0001@gmail.com>
In-Reply-To: <20220321071350.3476185-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     isdn@linux-pingi.de, sammy@sammy.net, davem@davemloft.net,
        kuba@kernel.org, pontus.fuchs@gmail.com, kvalo@kernel.org,
        wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-s390@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Mar 2022 00:13:50 -0700 you wrote:
> doing some code review and I found out there are a couple of places
> where "too short" is misspelled as "to short".
> 
> Tong Zhang (4):
>   ar5523: fix typo "to short" -> "too short"
>   s390/ctcm: fix typo "length to short" -> "length too short"
>   i825xx: fix typo "Frame to short" -> "Frame too short"
>   mISDN: fix typo "frame to short" -> "frame too short"
> 
> [...]

Here is the summary with links:
  - [1/4] ar5523: fix typo "to short" -> "too short"
    https://git.kernel.org/netdev/net-next/c/e94b99a40b99
  - [2/4] s390/ctcm: fix typo "length to short" -> "length too short"
    https://git.kernel.org/netdev/net-next/c/4f3dda8b4c4b
  - [3/4] i825xx: fix typo "Frame to short" -> "Frame too short"
    https://git.kernel.org/netdev/net-next/c/d2d803d1c72b
  - [4/4] mISDN: fix typo "frame to short" -> "frame too short"
    https://git.kernel.org/netdev/net-next/c/dc97870682e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


