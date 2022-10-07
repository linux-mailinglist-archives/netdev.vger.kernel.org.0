Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B955F74E2
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 09:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJGHua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 03:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJGHuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 03:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327D66AA0F;
        Fri,  7 Oct 2022 00:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79EE5B8227D;
        Fri,  7 Oct 2022 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D955C43141;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665129016;
        bh=yGPwnS7p08HUueJ0YP/t7ySOsn5fF0XGqHfplQ2fhAA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=as4JpaL6qsZz5mVCGT9MvkkIm1vK+EA6qHTVEPHrBqCGD7hrLNH8GL/IPjFEZOakO
         M+4Czb//Q5FOs9Y0vqIpU4mqKIY30aYrgWm1+LWAsUWJVxFmg9Hxjy56qtuHLgYUXQ
         325kxFpa0PG7eAa/Y/rbEXYKsiMAqI9URyHVCshRZ576cucIoU8VoFny91zdDiPz57
         EkBujbHvcihAiOCkKsA3X3Pegnz79K6RfR/4pXniL+NJOXFwhEmjSMnxh5V04x+tZg
         WQiWeQQ7kginxC4mKk8bdvgForrEPtPsPvJ+hyD13t9V0BB8R79unymyQf47eotPfV
         kAh996JJFUzOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13075E49BBB;
        Fri,  7 Oct 2022 07:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: add Jan as SMC maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166512901607.847.8068745684855128563.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Oct 2022 07:50:16 +0000
References: <20221007065436.33915-1-wenjia@linux.ibm.com>
In-Reply-To: <20221007065436.33915-1-wenjia@linux.ibm.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        kgraul@linux.ibm.com, wintera@linux.ibm.com, jaka@linux.ibm.com,
        twinkler@linux.ibm.com
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

On Fri,  7 Oct 2022 08:54:36 +0200 you wrote:
> Add Jan as maintainer for Shared Memory Communications (SMC)
> Sockets.
> 
> Acked-by: Jan Karcher <jaka@linux.ibm.com>
> Acked-by: Alexandra Winter <wintera@linux.ibm.com>
> Signed-off-by: Wenjia Zhang <wenjia@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: add Jan as SMC maintainer
    https://git.kernel.org/netdev/net/c/87d1aa8b90d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


