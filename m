Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E461F5E7B27
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiIWMub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiIWMua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:50:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64AA51166D4;
        Fri, 23 Sep 2022 05:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16F98B8317C;
        Fri, 23 Sep 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7673C433D7;
        Fri, 23 Sep 2022 12:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663937414;
        bh=Amqa2Q5rxGYINkTmRz3S+7GGUX2jay5F7luuA9oDrz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NpBx67rcaEbRExl7Rrtvvi/Rk2DXY55ms2Df41p4FU18Fm9xolS3Qh6MBtYWB+quw
         fGU6Qz0skAj20GSoADbAil6v34L53qqqbP1xnGoL/SQvKa8dFDnQky9UQoIpFI3BZp
         zY8uSZ8Brb15IJ54NpvUJ7igcevJjf1mpzeH/FB5GRChgYC0YNl3qMTUr5XS1aM4nT
         1vGmorLK5Q5zLjeDC/ST7r/Ojd2QYz6qGqQ05Xk7a7YAXQ9s/7nGCY5LexsxQKyHM+
         tgmy+RI72a3Omt31OOOFZImwQa9FtynZSOQ1BoldI3NmoQJCRh4cRyMeKi2RbfD4pO
         9O/eRkx3a1kng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CC34E4D03D;
        Fri, 23 Sep 2022 12:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: rectify file entry in TEAM DRIVER
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166393741463.6856.17054212763990591343.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 12:50:14 +0000
References: <20220922114053.10883-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220922114053.10883-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     bpoirier@nvidia.com, davem@davemloft.net, netdev@vger.kernel.org,
        jiri@resnulli.us, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 13:40:53 +0200 you wrote:
> Commit bbb774d921e2 ("net: Add tests for bonding and team address list
> management") adds the net team driver tests in the directory:
> 
>   tools/testing/selftests/drivers/net/team/
> 
> The file entry in MAINTAINERS for the TEAM DRIVER however refers to:
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: rectify file entry in TEAM DRIVER
    https://git.kernel.org/netdev/net/c/f8497b3e9650

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


