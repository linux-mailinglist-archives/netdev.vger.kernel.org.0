Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784FC54EA20
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378364AbiFPT2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378455AbiFPT2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:28:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431301C136;
        Thu, 16 Jun 2022 12:28:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F219AB825B4;
        Thu, 16 Jun 2022 19:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADC52C34114;
        Thu, 16 Jun 2022 19:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655407698;
        bh=3VSz/03Va3LbYLaumYOCkE6RxrwLdkighMxL7MUWMPc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=QT1ocsc3Bs9zVJ2zDMMmzevGNV57O22CeeUdKdivQVP+hE0sDQJqAg7wN3NBW+ybf
         zDSghperERNqwSXySzQcTy2brsLtrPSd0nn18TzY2r+fQAoZwIAC3cd1fg4wlmgirZ
         BA5wewCsQgXF8eqXnmnuQlKXd2HltdWLmPJFFtR/qLDT+N1ap6bPQnuQBE2wcscEuw
         GZeZnC+CwLPRXT2R9Xl6+yjdC4EPJvjzJ2nOqO2en5xXGDHnJw1pPoMGnQxHf1Jq0x
         BchiYuP8Rzn8NirqYdS/UE/2ip+jSd7Wrak1XcHqMEWEmgcidZ/BM3u1rCqlsg8/B7
         IctLo0ZmtXnQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A307FD99FB;
        Thu, 16 Jun 2022 19:28:18 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.19-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220616183659.3471896-1-kuba@kernel.org>
References: <20220616183659.3471896-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220616183659.3471896-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc3
X-PR-Tracked-Commit-Id: 2e7bf4a6af482f73f01245f08b4a953412c77070
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 48a23ec6ff2b2a5effe8d3ae5f17fc6b7f35df65
Message-Id: <165540769862.27515.1016745561047384156.pr-tracker-bot@kernel.org>
Date:   Thu, 16 Jun 2022 19:28:18 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 16 Jun 2022 11:36:59 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/48a23ec6ff2b2a5effe8d3ae5f17fc6b7f35df65

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
