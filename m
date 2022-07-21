Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0757D3BC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbiGUS6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiGUS6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:58:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7E48CCAE;
        Thu, 21 Jul 2022 11:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD6B9B8263D;
        Thu, 21 Jul 2022 18:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47304C3411E;
        Thu, 21 Jul 2022 18:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658429877;
        bh=4FIynROk9Og8SSJR3uswbAuPEpKwxjR/r2whaAVIdKU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TPejvYmHykPHEmYZ5qDBrAD7OVE+xlOOlf8uf479Lo4Y4DinnX+ySFw72T8PSv3bS
         JfGcHcTOEtY4MCwum7dWUiGl756Tr1Ll/OuL44qkZQOa7n16FRnkf5jNa55Khrszvg
         x+LAwSLygnsunCNnOLxHJFMXlKEizTXLZCGEJlcFwAEA+8R+6UwRhzsMUns5f787Bq
         9GpcB9aA8TV7R2r7Rn50fqM3x5MJrnSBIEC7M+0rUU8btDcuzwAjW9lQ/6mQGEKHTt
         usK6f8gE6/oE2oCToaOEsagv5mlInQgTLSrYBnJjgv0sxQH3iygnc0Gvcmr3A/zJv+
         TAi2AvurXfV+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35387D9DDDD;
        Thu, 21 Jul 2022 18:57:57 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.19-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220721093051.14504-1-pabeni@redhat.com>
References: <20220721093051.14504-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220721093051.14504-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc8
X-PR-Tracked-Commit-Id: 44484fa8eedf1c6e8f23ba2675b266abdd170a6e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ca433dc6dedb2ec98dfc943f6db0c9b8996ed11
Message-Id: <165842987720.25323.2313889054217820289.pr-tracker-bot@kernel.org>
Date:   Thu, 21 Jul 2022 18:57:57 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 21 Jul 2022 11:30:51 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.19-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ca433dc6dedb2ec98dfc943f6db0c9b8996ed11

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
