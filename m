Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5FB50B4B8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446424AbiDVKNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352684AbiDVKNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:13:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC45C2BB04
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7554461E38
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 10:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEA61C385AB;
        Fri, 22 Apr 2022 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650622211;
        bh=5o0k17JUbjinBPHY3d9VN22XMaUz/TimHJQCkGFQ0hE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UqYve/ZsrFSsMBx1DcbJDrEHaY1lbtSRTzkG5Sl05oTiQqhVv3G8wtl8BESiZyRC9
         vJgidA54/pPEm10NfL8mEoLl/rmb1iwKHE7puCEwNeHmAlfHoHkTYhklDjAnH0WD3O
         /udV6PYMqQFTd31gdEvXZvcyy/tR3uKmnO43dvy1jc7peFCGR6w+9pouRsKsr9q0g+
         TMx3wsnoxy1uZRKsxcaP8s7XND7SlzCFtSa2W3n6HghYJSJPNjI8jQvVpaZBv8PHLa
         ZHeeiFMXY52br4cEzP44mQACNPVyVxtPPVSD/xdUbJnVn1pRY4M6kIbElxT1zFdgfN
         nUcZE1zUqLaiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B119EE8DBDA;
        Fri, 22 Apr 2022 10:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "rtnetlink: return EINVAL when request cannot
 succeed"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062221172.10818.17738644265301241370.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 10:10:11 +0000
References: <20220419125151.15589-1-florent.fourcot@wifirst.fr>
In-Reply-To: <20220419125151.15589-1-florent.fourcot@wifirst.fr>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        brian.baboch@wifirst.fr
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Apr 2022 14:51:51 +0200 you wrote:
> This reverts commit b6177d3240a4
> 
> ip-link command is testing kernel capability by sending a RTM_NEWLINK
> request, without any argument. It accepts everything in reply, except
> EOPNOTSUPP and EINVAL (functions iplink_have_newlink / accept_msg)
> 
> So we must keep compatiblity here, invalid empty message should not
> return EINVAL
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "rtnetlink: return EINVAL when request cannot succeed"
    https://git.kernel.org/netdev/net-next/c/6f37c9f9dfbf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


