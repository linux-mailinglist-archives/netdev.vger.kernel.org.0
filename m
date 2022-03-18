Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E484DDCE0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiCRPbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238006AbiCRPbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:31:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A03F9157F;
        Fri, 18 Mar 2022 08:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B83E260B4B;
        Fri, 18 Mar 2022 15:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 217FAC340F0;
        Fri, 18 Mar 2022 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647617415;
        bh=qWX+Dxut6aXlGsUzI5MODUaW+oy7mOHHD1KjBgplK5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dErid/CitA7QduTOrYSHotDM80y8HEvEy4mTI4tQh1AKqgoZV1cp9tE1pYUd1zKZJ
         nk3J2y8iB9+A9lDD6pV5DI2WLrDvK/IW8z2q4elHFH8JKnrZ7EV2KXsNhufz7T8yP7
         lbA++x7zHcasb4GCjaNzhN6GMjh6LReqDvgNplDtk3kXm8qflw5yQzYVwxNbvAmh13
         JnKv79Ecu7doCvQWCX4YbrAFRB+3gvre4QnFRhITJ74lG99SGC0iGT7yOOAARVt/nK
         BU+1lWN7l/MdzYCrm9rcWe4H1O4RDl9CQIpZX5N1GzLZhRfKWebyVpETyCo835DKZv
         I8kpiWBUZhgkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB13FF03842;
        Fri, 18 Mar 2022 15:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-03-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164761741495.31796.9730181568772495029.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 15:30:14 +0000
References: <20220318144657.4C9E1C340E8@smtp.kernel.org>
In-Reply-To: <20220318144657.4C9E1C340E8@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
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

This pull request was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Mar 2022 14:46:57 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-03-18
    https://git.kernel.org/netdev/net-next/c/dca51fe7fbb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


