Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1212662DAE7
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbiKQMbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbiKQMb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:31:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B95A77224;
        Thu, 17 Nov 2022 04:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 90428CE1D56;
        Thu, 17 Nov 2022 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABF57C433D7;
        Thu, 17 Nov 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668688216;
        bh=dxewDuZ53JhFRzXcMVssnNx9vIVLWAdgouwtlbk4mgE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=THg5IYch5VJ52BwwSbX0eZZrUS0zaDvld0v4f9AyGZ/eBdmgyOQr0GIeYEIdQpW/e
         P8UNovCFogB3XTuB6kONCxFNy/vWw6ncrT7tdvLd9Ov7Yz3dXAixJIWdlqZSce+my3
         ipldDGcvu5Wh5B+U9CjU0/5vP+ilAka9IyFiYAAFlElo4TDO2rOyuoldfGY7Wf0KXj
         TVDO0jnCvWoiGSBl93Vr5Nc+nJT9YSknCPvmcLuxeCkdPBbvEuXMenEW6mlfuu0HRA
         un5B+LYvhuqe+Ym4LcV5BcoBD8GtwawKcA7vQGn01ZarEWU5sgRBmXcSCFQyrq2/oZ
         g702OGMOD+XWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 949C4E29F44;
        Thu, 17 Nov 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next][V2]: sundance: remove unused variable cnt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166868821560.8111.4968020441298912876.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Nov 2022 12:30:15 +0000
References: <20221115093137.144002-1-colin.i.king@gmail.com>
In-Reply-To: <20221115093137.144002-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     kda@linux-powerpc.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 15 Nov 2022 09:31:37 +0000 you wrote:
> Variable cnt is just being incremented and it's never used
> anywhere else. The variable and the increment are redundant so
> remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net-next,V2] : sundance: remove unused variable cnt
    https://git.kernel.org/netdev/net-next/c/710cfc6ab4b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


