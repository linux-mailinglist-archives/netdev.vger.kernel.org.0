Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876006EADA6
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjDUPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjDUPAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:00:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEC29EF2;
        Fri, 21 Apr 2023 08:00:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D45A61B9D;
        Fri, 21 Apr 2023 15:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3072C433EF;
        Fri, 21 Apr 2023 15:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682089242;
        bh=cAGgKU7Q/1LqHz8wXIS3qEUfihzPCQ+eBotR0hAqZew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pqQUYkqw5KZ2xh2xQW0UTIyM6rB4gAtEzTO2qdohrVw/XbUNZsPyMemR99h2XI9st
         gjoYlLWtgoTkngJcYtXPImCp8I8bexM+EZ3bNQTuBaPdoU8WpnBup+SFvS+S/Bx/5Q
         gApcH9oacN7EDmlmGh0DpNu/0WEcWquu3fGgi4fwfSx4KNzlshaph7Fk8bvPdOigPA
         aN4RcI5NBjrE1ih4EAUERyEoz5iXLzKMHH0HBXanUNa4oqtXxYVP/nUidB0CjQPZoR
         TFUd1z13CNhC7UYBKBGCT5hgSlkprqdagFNm8rqSMLecVsnhCGRiy/mHznPPcKGLc1
         Slky2zA7NHkrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D69DAC561EE;
        Fri, 21 Apr 2023 15:00:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-04-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168208924187.15667.11609697303265049571.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 15:00:41 +0000
References: <20230421104726.800BCC433D2@smtp.kernel.org>
In-Reply-To: <20230421104726.800BCC433D2@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
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

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Apr 2023 10:47:26 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-04-21
    https://git.kernel.org/netdev/net-next/c/ca2889658015

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


