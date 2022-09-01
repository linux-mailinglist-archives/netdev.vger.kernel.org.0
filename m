Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C275A8BB1
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiIADAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiIADAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78681792C0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 20:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB33B8241C
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 03:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3BE2C433D6;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662001217;
        bh=mUdT93X5KZk/fA7jUY9ejCJX4y0gPeEgHNgdHNO9HHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wsyz5m/1GrqJZYaYRq0Ve2DVUyBs8j0X/Yys9xXRnwnSRRiAZHA0pKRliDyqazDy/
         RvJdKDmlrWJX7WUbq3FiPTYGaR/LG5VTuOlQ3H1XMt/yVlQvzu33hTlHDlEGoj0JGO
         esPjo76O2jyc8f/NTJvNFl/BRnRPJo+70AbRSoP4hjx+DHOYPcP+faD20Q84W2qPON
         7pxGmZuzHNHfPAedQbVDygGjoj/meu4ca7Nu5WlrextGwVXFDYqnARqxj+MTpRWhw6
         JIfnPUtmXBrlE+4HCrdnoy7VzujzL+ulYooHla5KWqk/ul6hYRh9TjK4l8Y9rnYIKB
         1MwApt/LV2JHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1EC5E924DA;
        Thu,  1 Sep 2022 03:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 1/2] mnlg: remove unnused mnlg_socket structure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166200121785.29714.1995531038106178936.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 03:00:17 +0000
References: <20220826181741.3878852-1-jacob.e.keller@intel.com>
In-Reply-To: <20220826181741.3878852-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us
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

This series was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Fri, 26 Aug 2022 11:17:40 -0700 you wrote:
> Commit 62ff25e51bb6 ("devlink: Use generic socket helpers from library")
> removed all of the users of struct mnlg_socket, but didn't remove the
> structure itself. Fix that.
> 
> Fixes: 62ff25e51bb6 ("devlink: Use generic socket helpers from library")
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] mnlg: remove unnused mnlg_socket structure
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=0c3540635d67
  - [iproute2-next,2/2] utils: extract CTRL_ATTR_MAXATTR and save it
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=89afe6ef89e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


