Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1656D1092
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 23:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjC3VLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 17:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjC3VLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 17:11:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FB7E1BD;
        Thu, 30 Mar 2023 14:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17E65B829A5;
        Thu, 30 Mar 2023 21:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C91DEC4339C;
        Thu, 30 Mar 2023 21:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680210662;
        bh=HE6r3U/EIESUOjI0K6IdIisKCKen8GTTKyAovJmHVY0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bzuARHDrCJcBj34/x8xJlq9e6BRaNrk/831KaLhiqo+e8pCmxNb+Bs45DphcVsjoq
         pOuQ1Bok4Zowfw/eRavbvXmBiDS2hmKlkej/1aQMIovXSjTOIm21YWmo08udoSR26D
         izfjOK9UypQi0TF25919cOIzORXFPTEXKcH+m80FONclrPK39TDZefHt5Cp2OVo6OT
         sikEhYwqZ/pX9K+feGbVxnv7eo92oj9R5pEFiAlJktN1mu+POGaIprrMZuhut3gvpx
         2Iyp26N6ymC/IN0FFHLuDiEtfmvUDe4x+T8X/cu12AHT68UF35lzz9wTFqD4iyQ/74
         ePMej50Ggaong==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8961E2A03F;
        Thu, 30 Mar 2023 21:11:02 +0000 (UTC)
Subject: Re: [PULL] Networking for v6.3-rc5
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230330200100.78996-1-kuba@kernel.org>
References: <20230330200100.78996-1-kuba@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230330200100.78996-1-kuba@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc5
X-PR-Tracked-Commit-Id: 924531326e2dd4ceabe7240f2b55a88e7d894ec2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b2bc47e9b2011a183f9d3d3454a294a938082fb9
Message-Id: <168021066275.12065.15852438879730598269.pr-tracker-bot@kernel.org>
Date:   Thu, 30 Mar 2023 21:11:02 +0000
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 30 Mar 2023 13:01:00 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.3-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b2bc47e9b2011a183f9d3d3454a294a938082fb9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
