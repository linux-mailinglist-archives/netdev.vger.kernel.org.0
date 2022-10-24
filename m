Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C28660BD31
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 00:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiJXWOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 18:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiJXWOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 18:14:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC6DA3BBA;
        Mon, 24 Oct 2022 13:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D065F615C2;
        Mon, 24 Oct 2022 20:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35CDFC43470;
        Mon, 24 Oct 2022 20:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666642018;
        bh=CARoY+Ok4svh1OGrY05r3kFMP7KpVCIBpNkOyX5Xy6w=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=FpxIlJxG9oUrwlv/DxM2q6NQX+8Pd9O5jGB3Pi/TCAGAU3mrQTNkz1zgrN8c+Osf/
         ZJTOF1jftVhMVNzhzPtw1dKqXXtbg5wwgbSB+2p8cVg1xinF2+SF9y3VEHRODXsdwb
         /zIaKIbpqfqEIXYP254uu57G7c9fgLkt/tOGUjghD3tkVV0Evo6IAsveMtZ7guQr/D
         BN1LP7E2PKuuso4uCj0xEpaQlZGyXxsc6dteHGudka6Z07V9asTgfB3M/zQtHHQu0s
         +376ky6/NZYCS75KnAl2w8Wk1lgSOAdBw78m2mKYlpXhZq3/HpoKc0I8aRzeRsAeCz
         BLo2AYZBwQSjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21727E270DD;
        Mon, 24 Oct 2022 20:06:58 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.1-rc3 (part 1)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221024181835.475631-1-kuba@kernel.org>
References: <20221024181835.475631-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221024181835.475631-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc3-1
X-PR-Tracked-Commit-Id: 720ca52bcef225b967a339e0fffb6d0c7e962240
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 337a0a0b63f1c30195733eaacf39e4310a592a68
Message-Id: <166664201813.4311.1413049515114810298.pr-tracker-bot@kernel.org>
Date:   Mon, 24 Oct 2022 20:06:58 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 24 Oct 2022 11:18:35 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.1-rc3-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/337a0a0b63f1c30195733eaacf39e4310a592a68

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
