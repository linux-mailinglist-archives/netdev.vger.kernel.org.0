Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2498C636663
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239239AbiKWRAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238881AbiKWRAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:00:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10ADBF5B6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40C9FB821D3
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED35CC433C1;
        Wed, 23 Nov 2022 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669222818;
        bh=FGNg3KBDg177aMn+56oMu6XaujZtVbSBCX1alvq5YJ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I7IzPxIMfvTf4jrYp1gornPm28FRvdcrl6sUdHXhZCHJQnW/b+69pCO5VPdRy0bQO
         LL0STyeUJZL6/75yMZdWky+PvO8FwcZGD1T0d0vZ6kER4d8RI8r97bv655PrlLae4f
         QhxWZDBm4kc8/hb+dHjQpIv1Xw6iNn5rRLWr+2apoAEzECrdJEPZxuNPOHr4N4DdvQ
         jNxDqEtiUU/6ywtWy+cqWDyVhn5x/CV8z2rtinc/VeWyBI+h0aisOIcBZrQ9TfooPx
         ppi2B+z41Ipdjd07Rgmoe0sWyUwLIipPa6ZLmAdJF2i3phrRolb43tXK2IxNbRDpiL
         k4CZSFfA3ZHcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFB50E21EFD;
        Wed, 23 Nov 2022 17:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v1] tc_util: Fix no error return when large
 parent id used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166922281684.9414.17456612951830729390.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 17:00:16 +0000
References: <1668663197-22115-1-git-send-email-jun.ann.lai@intel.com>
In-Reply-To: <1668663197-22115-1-git-send-email-jun.ann.lai@intel.com>
To:     Lai Peter Jun Ann <jun.ann.lai@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        muhammad.husaini.zulkifli@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 17 Nov 2022 13:33:17 +0800 you wrote:
> This patch is to fix the issue where there is no error return
> when large value of parent ID is being used. The return value by
> stroul() is unsigned long int. Hence the datatype for maj and min
> should defined as unsigned long to avoid overflow issue.
> 
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v1] tc_util: Fix no error return when large parent id used
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=e0ecee3a33af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


