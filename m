Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F86D636662
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbiKWRAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238572AbiKWRAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:00:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9309584337
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32976B821D1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 17:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5214C433B5;
        Wed, 23 Nov 2022 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669222817;
        bh=tOJ0sEsNzmErBRLrskVdNszdJ7A4jGCmXSCqdcAPEqs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mFxQ42nvUf0YGOOjBfB2sySoW6IDLG5xYDdYL4iv5WPkZ0BTpEIZukU7QDY3oB/bw
         /J+ueaIA+DfQ5uPExZ8gyji7NvyzCLE7O8YBOTcBK5MVWBc1TjR6WZRoTWOoDwVtVP
         6xTmf7PIAXB4sIlxLEfEYOzpmLndQz8AHQTWhSJK3qWMPHHnSuquCkPQD6fdHkq5uO
         nag544Nal56JD5Q9nK9NobQTWsAzRDjuLvFn87QwvqKx+TV31fRI6SZzxJvOpXFpg+
         j+cr8MnRl9LaMXmBn30B+FE8fTexH0vJTWyPRWrrLKAsV/V8U/Q8iOLGsueJeChGjz
         d5Il5rBGAIVxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5F4DC395C5;
        Wed, 23 Nov 2022 17:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v1] tc_util: Change datatype for maj to avoid
 overflow issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166922281680.9414.18146696909266702016.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 17:00:16 +0000
References: <1668997749-5942-1-git-send-email-jun.ann.lai@intel.com>
In-Reply-To: <1668997749-5942-1-git-send-email-jun.ann.lai@intel.com>
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

On Mon, 21 Nov 2022 10:29:09 +0800 you wrote:
> The return value by stroul() is unsigned long int. Hence the datatype
> for maj should defined as unsigned long to avoid overflow issue.
> 
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Signed-off-by: Lai Peter Jun Ann <jun.ann.lai@intel.com>
> ---
>  tc/tc_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [iproute2-next,v1] tc_util: Change datatype for maj to avoid overflow issue
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=455fa8295298

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


