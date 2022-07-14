Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE51575676
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 22:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbiGNUmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 16:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240594AbiGNUmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 16:42:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A834E628;
        Thu, 14 Jul 2022 13:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 581D3B8258C;
        Thu, 14 Jul 2022 20:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBCB6C34115;
        Thu, 14 Jul 2022 20:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657831351;
        bh=P+iE1Jlewq2iEBtk32EbfXSF4igTE90gdXVoMeUyBmQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=X6iUE+ODclSq2kCQ1AklRuKRM/eBtamZEHfS6dGnI2Gkx251bXeClNcxR8q/hdP4t
         /LXPub+fUVOg5YWYreCNsDajFDiM9wrlpnVT0gH4EErW/vBD7c0RVoMKnIkWuZPbWk
         1dmZrIc96ZWBJuVwO5lFywkR3pGaRnRUZeYpkVEOcNP9cVlQ0CoZnuRewfGLRDC919
         BVrFM9+QqNC7L4G9KSV0Tmgzag7z1g+zY6E8ESvdGOKvmW9K0TwclND0E4R29ULCVe
         EPAjfhZPaKJeub8EAYlOW9y+i5vjQQkHreyzMAsPKvXdNP1T4spO9wxPzN/gv/l1ZV
         TImdkg3eyExmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA0AFE45224;
        Thu, 14 Jul 2022 20:42:31 +0000 (UTC)
Subject: Re: [PULL] Networking for 5.19-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220714190451.2808151-1-kuba@kernel.org>
References: <20220714190451.2808151-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220714190451.2808151-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc7
X-PR-Tracked-Commit-Id: 656bd03a2cd853e7c7c4e08968ad8c0ea993737d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9bd572ec7a66b56e1aed896217ff311d981cf575
Message-Id: <165783135182.13350.1137665657471618634.pr-tracker-bot@kernel.org>
Date:   Thu, 14 Jul 2022 20:42:31 +0000
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

The pull request you sent on Thu, 14 Jul 2022 12:04:51 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9bd572ec7a66b56e1aed896217ff311d981cf575

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
