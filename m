Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F358675CF8
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 19:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjATSrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 13:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjATSq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 13:46:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE2743A9;
        Fri, 20 Jan 2023 10:46:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01DEAB829C3;
        Fri, 20 Jan 2023 18:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CFDFC433D2;
        Fri, 20 Jan 2023 18:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674240415;
        bh=yLqUPDJuAMDYKm3TpsL2T+a4TFuITf8cC8pK6jZZ2i0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=s2Gmm3DsLIt7HjV+A/OTSKWwOIKcu7BtwZvikbZESyaRu3pDGt276cSaHYbWORI1M
         zEDSy2Ncose9wbMVsTY6m6QHzlpQvwy2Tk7UzDnBDMEZx2rku+qG4iR35OWwgMawn2
         lb5nOlyhrOQnCClKMRsW3MOzlBjr18iLzo9oDPVz83bdq4AzSRq+5FfwCiXpVdqhma
         mYuoliRHza9e6zcnz4ojC7j1OQh6omlRzIX+cfxdFRwae66Iitdc78REeARPTuZqR7
         nw1lMG228b/WOSboxmlUtsEztA8A0UlKz2rxNP6WolbR7Gl6RZRlhq/K8unOSXjF8T
         NMgMUa12zD62A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82244C04E34;
        Fri, 20 Jan 2023 18:46:55 +0000 (UTC)
Subject: Re: [PULL v2] Networking for v6.2-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230120165004.1372146-1-kuba@kernel.org>
References: <20230120165004.1372146-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230120165004.1372146-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc5-2
X-PR-Tracked-Commit-Id: 45a919bbb21c642e0c34dac483d1e003560159dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5deaa98587aca2f0e7605388e89cfa1df4bad5cb
Message-Id: <167424041552.21297.10334830893531625071.pr-tracker-bot@kernel.org>
Date:   Fri, 20 Jan 2023 18:46:55 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Fri, 20 Jan 2023 08:50:04 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc5-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5deaa98587aca2f0e7605388e89cfa1df4bad5cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
