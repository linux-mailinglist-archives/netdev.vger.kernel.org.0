Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1116E17BD
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjDMWxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjDMWxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:53:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9667C1FFC;
        Thu, 13 Apr 2023 15:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C305A64234;
        Thu, 13 Apr 2023 22:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02F42C433EF;
        Thu, 13 Apr 2023 22:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681426402;
        bh=+yWl/x4kVnPUoAnPTIYC1ZtrABCVDGSUvL2SJXrP0Mw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qJrf++gf9U4wosXjZ9LU/4uYxCyQx8Mnx0QIGD8XL5Szo5gB1REhUz+OFXOxqwxAB
         fXa1VMGqTQQVVIe/HO+Z96V2hnPFFdsQZjI9o8zdcQoZZKUAB5Nhq+TOHisHUmvukl
         72V56HS+eFl/iIYUbJ178fiwoXzKjpVCEADYXnGVv01mQ4HLl72p84l+0mLwQ7elrT
         RAdINBe4cQyi2aqtRXYQNKplNIaG5ReSRIynVxFYjFwM5ly6chUAVPH3Peju/wmp2x
         nkZo9MkE+qB9QtKlxgLrKicgBtCHmZxTp4vn+OCcEwcZbjUrOTONBg0GSa0zYrg8VZ
         wftCRiLaAPTPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5433E5244F;
        Thu, 13 Apr 2023 22:53:21 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for v6.3-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230413213217.822550-1-kuba@kernel.org>
References: <20230413213217.822550-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230413213217.822550-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.3-rc7
X-PR-Tracked-Commit-Id: d0f89c4c1d4e7614581d4fe7caebb3ce6bceafe6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 829cca4d1783088e43bace57a555044cc937c554
Message-Id: <168142640193.8338.13603287710718642906.pr-tracker-bot@kernel.org>
Date:   Thu, 13 Apr 2023 22:53:21 +0000
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

The pull request you sent on Thu, 13 Apr 2023 14:32:17 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git net-6.3-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/829cca4d1783088e43bace57a555044cc937c554

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
