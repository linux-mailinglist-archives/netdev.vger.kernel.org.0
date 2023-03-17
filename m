Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD876BF4B8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjCQVzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbjCQVzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:55:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A47CC305;
        Fri, 17 Mar 2023 14:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFAF5B82738;
        Fri, 17 Mar 2023 21:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB25DC433EF;
        Fri, 17 Mar 2023 21:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679089917;
        bh=wptaZDt3yDeZgxhc2CiH5c/QRbtFHU8GDlk+IC1MhJM=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=CGGChXUIduO1LnPfJ26lC7w2714GHqpwAQiDtTKrQWOuw769Q5H280vGWAeUrJYd9
         JZ5N9b4xpAO1QFvDoR3saLi6Dp2tzJJyUDPxTBgaSC1AoBbLQ5QlUc774l6oIfr+B2
         g/Yes0QkXDsXZbC6o8FH8+LFiFaYgzZ8oISdoF1Ui/h47xtYek3KzRNmcBvOceS0/Y
         Kg8i6SV7B0Uma95rmbtt5gZD4D2Z1KDQXxlrYS13XqeYAoLW3xtB+4lPhLGIegdtzc
         wQubY02VrU3LcjfCSdDCPPFR/uhkOsdF2b9CmhtHNlLbe37NxiLVcIlWyQQ5S2r1B9
         CVT1/LRiIdGmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99692E66CBF;
        Fri, 17 Mar 2023 21:51:57 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.3-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230317053152.2232639-1-kuba@kernel.org>
References: <20230317053152.2232639-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230317053152.2232639-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc3
X-PR-Tracked-Commit-Id: 0c98b8bc48cf91bf8bdad123d6c07195341b0a81
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 90de546d9a0b3c771667af18bb3f80567eabb89b
Message-Id: <167908991762.6577.12740367448486038411.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Mar 2023 21:51:57 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 16 Mar 2023 22:31:52 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/90de546d9a0b3c771667af18bb3f80567eabb89b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
