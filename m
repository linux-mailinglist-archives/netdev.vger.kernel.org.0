Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F4F4ECD3F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350731AbiC3TcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350717AbiC3TcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:32:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C61710C7
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 12:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3B94B81D51
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 19:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94DF5C340F2;
        Wed, 30 Mar 2022 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648668612;
        bh=mcLJ88gF62OfeoOH1ng5fYKfSuxf+TSCFFH5yv3Rcfs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VWgzRfrUy23LRVUN2cMr/Oy6sPCirXNvewxVhKCp1ce9yJlAmFxNgFlncqNAbizEd
         /ZXBVN4/ph7+fW4Zf9c4c+t8TIUHFOyGzP54pSJ2pbXLZ+ipbvccFhUlug+ZVotGda
         Jaqebf3qJ9qrVCSpwXb58rWIciVggM6/WVIlVgG9lGnL6OkHEmN4FryUuLLIQXCeEK
         PsK0lxryOPJ7mkkmmGFVadYCfuV7724fWQV4AnVPj4y5/xNp1Eq7dokCOIyZh8heKp
         lQ/DI+/wtfaAqC0CJQL5CnUa5OChMjr2Nl6rKv2IN5Z517IjexevMWO/t1wpZ5mv51
         FV+TMGxwnvAvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7662BF0384C;
        Wed, 30 Mar 2022 19:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: ocp: handle error from nvmem_device_find
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164866861248.12292.8762520658834151114.git-patchwork-notify@kernel.org>
Date:   Wed, 30 Mar 2022 19:30:12 +0000
References: <20220329160354.4035-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220329160354.4035-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Mar 2022 09:03:54 -0700 you wrote:
> nvmem_device_find returns a valid pointer or IS_ERR().
> Handle this properly.
> 
> Fixes: 0cfcdd1ebcfe ("ptp: ocp: add nvmem interface for accessing eeprom")
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/ptp/ptp_ocp.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net] ptp: ocp: handle error from nvmem_device_find
    https://git.kernel.org/netdev/net/c/8f0588e80e33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


