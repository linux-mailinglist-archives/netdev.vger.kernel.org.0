Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F017B4DD17B
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 00:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiCQXvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 19:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiCQXvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 19:51:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693FE2B04FA;
        Thu, 17 Mar 2022 16:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23A0DB820F3;
        Thu, 17 Mar 2022 23:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C57ADC340EE;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647561012;
        bh=xjxwpu7dNH7KZwEMZJSJ3w2kaLh6Kkub/7iGqhMnWj4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UxjD1wCM3Im0DLozNHMjeWkRqVqoS+iEA5SRNVncB0VKNAVf91TEAbIPDSm4b33lQ
         dw1n8Cbeu5HxBi7MgwDSvh7XK5QcT1+h2INzm7nWsdZz+kdBQgSPJ7gwxdY/vVpPa/
         R16FkJfpDgZFp54joc97hZi48i/1fPw4QQYthlOGEoFhPdZrJmN8IK9AwroohsCNa2
         GtTgRFGcn7jgC8xAt+i+2fRyhLxc4vyf0E5Rr+ctsCWX8u9KPGKf8/smmQ8JdxPat2
         iMwT9PyL9Xlsj438LGHfU/Q8m7N86s78+F11tO5EljENYGnvpVQAyrqXz08fBLwy4q
         IaJ/ewgnCrhyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AB14DE8DD5B;
        Thu, 17 Mar 2022 23:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: Fix spelling mistake and clean up message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164756101269.14093.9710637048125873924.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 23:50:12 +0000
References: <20220316233455.54541-1-colin.i.king@gmail.com>
In-Reply-To: <20220316233455.54541-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, colin.king@intel.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Mar 2022 23:34:55 +0000 you wrote:
> There is a spelling mistake in a dev_err message and the MAX_SKB_FRAGS
> value does not need to be printed between parentheses. Fix this.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/ti/netcp_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: ethernet: ti: Fix spelling mistake and clean up message
    https://git.kernel.org/netdev/net-next/c/30fb35989dcc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


